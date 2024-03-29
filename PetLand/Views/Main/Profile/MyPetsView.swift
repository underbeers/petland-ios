//
//  MyPetsView.swift
//  PetLand
//
//  Created by Никита Сигал on 07.05.2023.
//

import SwiftUI

struct MyPetsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var model: ProfileView.ProfileViewModel

    var body: some View {
        ScrollView {
            if model.pets.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("У вас пока нет питомцев")
                        .font(.cTitle2)
                        .foregroundColor(.cText)
                    Text("Если у вас уже есть питомец, добавьте его описание на PetLand")
                        .font(.cMain)
                        .foregroundColor(.cText)
                    NavigationLink {
                        PetEditView()
                    } label: {
                        HStack {
                            Text("Добавить питомца")
                                .font(.cButton)
                            Image("icons:plus")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                        }
                        .foregroundColor(.white)
                    }
                    .buttonStyle(CustomButton(.primary, isEnabled: true))

                    Text("Или найдите друга в объявлениях PetLand")
                        .font(.cMain)
                        .foregroundColor(.cText)
                    Button {
                        appState.setCurrentTab(to: .adverts)
                    } label: {
                        HStack {
                            Text("Доска объявлений")
                            Image("icons:advert")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .buttonStyle(CustomButton(.primary, isEnabled: true, color: .green))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
            } else {
                VStack(spacing: 28) {
                    ForEach(model.pets) { pet in
                        NavigationLink {
                            PetDetailView(pet)
                        } label: {
                            HStack(spacing: 16) {
                                CustomImage(pet.photo) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .aspectRatio(3 / 4, contentMode: .fill)
                                .clipped()
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.25), radius: 6, x: 4, y: 4)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(pet.name)
                                        .lineLimit(2, reservesSpace: true)
                                        .multilineTextAlignment(.leading)
                                        .font(.cTitle2)
                                        .foregroundColor(.cText)
                                    Spacer()
                                    CustomChip(title: pet.type)
                                    CustomChip(title: pet.breed)
                                    CustomChip(title: pet.gender)
                                    CustomChip(title: pet.age)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .padding(16)
                .animation(.default, value: model.pets)
                .onAppear { model.fetchPets() }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink {
                            PetEditView()
                        } label: {
                            Image("icons:plus")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.cOrange)
                                .frame(width: 24, height: 24)
                        }
                    }
                }
            }
        }
        .navigationTitle("Мои питомцы")
    }
}

struct MyPetsView_Previews: PreviewProvider {
    static let someModel: ProfileView.ProfileViewModel = {
        let model = ProfileView.ProfileViewModel()
        model.pets = [.dummy, .dummy, .dummy]
        return model
    }()

    static let emptyModel: ProfileView.ProfileViewModel = {
        let model = ProfileView.ProfileViewModel()
        model.pets = []
        return model
    }()

    static var previews: some View {
        NavigationStack {
            MyPetsView()
                .environmentObject(AppState())
                .environmentObject(someModel)
        }

        NavigationStack {
            MyPetsView()
                .environmentObject(AppState())
                .environmentObject(emptyModel)
        }
    }
}
