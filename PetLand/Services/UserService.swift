//
//  UserService.swift
//  PetLand
//
//  Created by Никита Сигал on 05.05.2023.
//

import Alamofire
import Foundation

extension Endpoint {
    static let login = Endpoint(path: "/login", method: .post)
    static let registration = Endpoint(path: "/registration/new", method: .post)
    static let verifyEmail = Endpoint(path: "/email/code", method: .post)
    static let getUser = Endpoint(path: "/user/info", method: .get)
    static let updateChatCredentials = Endpoint(path: "/user/chat/update", method: .patch)
}

enum UserServiceError: Error {
    case wrongCredentials
    case userAlreadyExists
}

protocol UserServiceProtocol {
    func login(user: String, password: String, stayLoggedIn: Bool, completion: @escaping (Error?) -> ())
    func register(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Error?) -> ())
    func verifyEmail(email: String, completion: @escaping (Error?) -> ())
    func getUser(completion: @escaping (Result<User, Error>) -> ())
    func updateChatCredentials(chatID: String, sessionID: String, completion: @escaping (Error?) -> ())
}

class UserService: UserServiceProtocol {
    static let shared = UserService()

    private let validationManager: ValidationManagerProtocol = ValidationManager.shared
    private let accessTokenStorage: AccessTokenStorageProtocol = AccessTokenStorage.shared

    func login(user: String, password: String, stayLoggedIn: Bool, completion: @escaping (Error?) -> ()) {
        let endpoint = Endpoint.login
        let parameters = [
            "login": user,
            "password": password
        ]

        AF.request(endpoint.url, method: endpoint.method, parameters: parameters, encoder: JSONParameterEncoder())
            .validate()
            .responseDecodable(of: [String: String].self) { [weak self] response in
                debugPrint(response)

                guard let token = response.value?["accessToken"] else {
                    if let error = response.error {
                        switch error {
                            case .responseValidationFailed(reason: .unacceptableStatusCode(code: 400)):
                                completion(UserServiceError.wrongCredentials)
                            case .responseValidationFailed(reason: .unacceptableStatusCode(code: 500)):
                                completion(APIError.serverDown)
                            default:
                                completion(error)
                        }
                    }
                    return
                }

                self?.accessTokenStorage.save(token, stayLoggedIn: stayLoggedIn)
                completion(nil)
            }
    }

    func register(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Error?) -> ()) {
        let endpoint = Endpoint.registration
        let parameters = [
            "firstName": firstName,
            "surName": lastName,
            "email": email,
            "password": password
        ]

        AF.request(endpoint.url, method: endpoint.method, parameters: parameters, encoder: JSONParameterEncoder())
            .validate()
            .response { [weak self] response in
                debugPrint(response)

                if let error = response.error {
                    switch error {
                        case .responseValidationFailed(reason: .unacceptableStatusCode(code: 409)):
                            completion(UserServiceError.userAlreadyExists)
                        case .responseValidationFailed(reason: .unacceptableStatusCode(code: 500)):
                            completion(APIError.serverDown)
                        default:
                            completion(error)
                    }
                    return
                }

                self?.login(user: email, password: password, stayLoggedIn: true, completion: completion)
            }
    }

    func verifyEmail(email: String, completion: @escaping (Error?) -> ()) {
        let endpoint = Endpoint.verifyEmail

        let code = validationManager.generateVerificationCode()
        let parameters = [
            "email": email,
            "code": String(code)
        ]

        AF.request(endpoint.url, method: endpoint.method, parameters: parameters, encoder: JSONParameterEncoder())
            .validate()
            .response { response in
                debugPrint(response)

                if let error = response.error {
                    switch error {
                        case .responseValidationFailed(reason: .unacceptableStatusCode(code: 500)):
                            completion(APIError.serverDown)
                        default:
                            completion(error)
                    }
                }

                completion(nil)
            }
    }

    func getUser(completion: @escaping (Result<User, Error>) -> ()) {
        let endpoint = Endpoint.getUser

        AF.request(endpoint.url, method: endpoint.method, headers: [accessTokenStorage.authHeader])
            .validate()
            .responseDecodable(of: User.self) { [weak self] response in
                debugPrint(response)

                guard let value = response.value else {
                    if let error = response.error {
                        switch error {
                            case .responseValidationFailed(reason: .unacceptableStatusCode(code: 401)):
                                completion(.failure(APIError.unauthorized))
                            case .responseValidationFailed(reason: .unacceptableStatusCode(code: 500)):
                                completion(.failure(APIError.serverDown))
                            default:
                                completion(.failure(error))
                        }
                    }
                    return
                }

                completion(.success(value))
                self?.accessTokenStorage.setUserID(value.id)
            }
    }

    func updateChatCredentials(chatID: String, sessionID: String, completion: @escaping (Error?) -> ()) {
        let endpoint = Endpoint.updateChatCredentials

        let parameters = [
            "chatID": chatID,
            "sessionID": sessionID
        ]

        AF.request(endpoint.url, method: endpoint.method, parameters: parameters, encoder: JSONParameterEncoder(encoder: .custom), headers: [accessTokenStorage.authHeader])
            .validate()
            .response { response in
                debugPrint(response)

                if let error = response.error {
                    switch error {
                        case .responseValidationFailed(reason: .unacceptableStatusCode(code: 500)):
                            completion(APIError.serverDown)
                        default:
                            completion(error)
                    }
                }

                completion(nil)
            }
    }
}
