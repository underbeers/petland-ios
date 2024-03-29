//
//  UserModel.swift
//  PetLand
//
//  Created by Никита Сигал on 06.05.2023.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    var id: String = UUID().uuidString
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var image: String = ""
    var chatID: String = UUID().uuidString
    var sessionID: String = UUID().uuidString

    enum CodingKeys: String, CodingKey {
        case id = "userID"
        case firstName
        case lastName = "surName"
        case email
        case image = "imageLink"
        case chatID
        case sessionID
    }
}
