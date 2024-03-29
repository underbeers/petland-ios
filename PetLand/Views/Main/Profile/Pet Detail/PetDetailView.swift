//
//  PetDetailView.swift
//  PetLand
//
//  Created by Никита Сигал on 10.05.2023.
//

import SwiftUI

struct PetDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var model: PetDetailViewModel = .init()
    private let cachedPet: PetCard

    init(_ pet: PetCard) {
        self.cachedPet = pet
    }

    private var name: String {
        model.pet.name.isEmpty ? cachedPet.name : model.pet.name
    }

    private var type: String {
        model.pet.type.isEmpty ? cachedPet.type : model.pet.type
    }

    private var breed: String {
        model.pet.breed.isEmpty ? cachedPet.breed : model.pet.breed
    }

    private var gender: String {
        model.pet.gender.isEmpty ? cachedPet.gender : model.pet.gender
    }

    private var age: String {
        model.pet.birthday == .now ? cachedPet.age : model.pet.age
    }

    @State var presentingDeletion: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                let photos = model.pet.photos.isEmpty ? [cachedPet.photo] : model.pet.photos.map { $0.original }
                TabView {
                    ForEach(photos, id: \.self) { photo in
                        CustomImage(photo) { image in
                            ZStack {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .blur(radius: 8)
                                    .brightness(-0.2)
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    .aspectRatio(4 / 3, contentMode: .fit)
                            }
                        }
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .aspectRatio(4 / 3, contentMode: .fit)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.25), radius: 6, x: 4, y: 4)

                Text(name)
                    .font(.cTitle1)
                    .foregroundColor(.cText)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CustomChip(title: type)
                        CustomChip(title: gender)
                        CustomChip(title: breed)
                        CustomChip(title: age)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Окрас")
                        .font(.cTitle4)
                        .foregroundColor(.cText)
                    Text(model.pet.color)
                        .font(.cMain)
                        .foregroundColor(.cText)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Особенности ухода")
                        .font(.cTitle4)
                        .foregroundColor(.cText)
                    Text(model.pet.care)
                        .font(.cMain)
                        .foregroundColor(.cText)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Родословная")
                        .font(.cTitle4)
                        .foregroundColor(.cText)
                    Text(model.pet.pedigree)
                        .font(.cMain)
                        .foregroundColor(.cText)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Черты характера")
                        .font(.cTitle4)
                        .foregroundColor(.cText)
                    Text(model.pet.character)
                        .font(.cMain)
                        .foregroundColor(.cText)
                }

                if ["Кошка", "Собака"].contains(model.pet.type) {
                    HStack(spacing: 32) {
                        HStack(spacing: 8) {
                            Image(model.pet.sterilized ? "icons:checkmark" : "icons:cross")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(model.pet.sterilized ? .cGreen : .cRed)
                                .frame(width: 28, height: 28)
                            Text("Стерилизация")
                                .font(.cMain)
                                .foregroundColor(.cText)
                        }
                        HStack(spacing: 8) {
                            Image(model.pet.vaccinated ? "icons:checkmark" : "icons:cross")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(model.pet.vaccinated ? .cGreen : .cRed)
                                .frame(width: 28, height: 28)
                            Text("Вакцинация")
                                .font(.cMain)
                                .foregroundColor(.cText)
                        }
                    }
                }
            }
            .padding(16)
        }
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            model.fetchInfoBy(id: cachedPet.id)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink {
                    PetEditView(initialPet: model.pet)
                } label: {
                    Image("icons:edit")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.cOrange)
                        .frame(width: 24, height: 24)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    presentingDeletion = true
                } label: {
                    Image("icons:delete")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.cRed)
                        .frame(width: 24, height: 24)
                }
            }
        }
        .alert(isPresented: $presentingDeletion) {
            Alert(title: Text("Удаление питомца"),
                  message: Text("Вы уверены, что хотите удалить питомца?\n\nЭто действие невозможно отменить."),
                  primaryButton: .destructive(Text("Да, удалить")) {
                      model.delete { dismiss() }
                  },
                  secondaryButton: .cancel(Text("Отмена")) {})
        }
        .alert("Что-то пошло не так...", isPresented: $model.presentingAlert) {
            Text(model.alertMessage)
        }
    }
}

struct PetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PetDetailView(.dummy)
    }
}
