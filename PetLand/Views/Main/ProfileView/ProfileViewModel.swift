//
//  ProfileViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 06.05.2023.
//

import Foundation

extension ProfileView {
    @MainActor final class ProfileViewModel: ObservableObject {
        private var appState: AppState?
        private let userService: UserServiceProtocol = UserService.shared

        @Published var user: User = .init()

        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false

        func setup(_ appState: AppState) {
            self.appState = appState
        }

        func signOut() {
            appState?.signOut()
        }

        func fetchUserInfo() {
            userService.getUserInfo { [weak self] result in
                switch result {
                    case .success(let value):
                        self?.user = value
                    case .failure(let error):
                        switch error {
                            case UserServiceError.unauthorized:
                                self?.alertMessage = "Ошибка авторизации. Зайдите в аккаунт заново."
                            case UserServiceError.serverDown:
                                self?.alertMessage = "Проблема с доступом к серверу"
                            default:
                                self?.alertMessage = error.localizedDescription
                        }
                        self?.presentingAlert = true
                }
            }
        }
    }
}
