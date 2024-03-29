//
//  Dummies.swift
//  PetLand
//
//  Created by Никита Сигал on 06.05.2023.
//

import Foundation

extension User {
    static let dummy = User(firstName: "Test",
                            lastName: "Testing",
                            email: "test@server.domain",
                            image: "preview:profile-photo")
}

extension Pet {
    static let dummy = Pet(name: "Котяра",
                           typeID: 1,
                           type: "Собака",
                           breedID: 2,
                           breed: "Австралийская овчарка (аусси)",
                           birthday: ISO8601DateFormatter().date(from: "2020-04-28T00:00:00Z")!,
                           isMale: false,
                           gender: "Девочка",
                           color: "Красная с белыми полосками",
                           care: "Кормить только тунцом и красной икрой",
                           pedigree: "Из рода Бранденбургов",
                           character: "Любит играть в гольф и теннис, иногда взрывает ядерные боеприпасы",
                           vaccinated: true)
}

extension PetCard {
    static let dummy = PetCard(name: "Котяра",
                               type: "Собака",
                               breed: "Австралийская овчарка (аусси)",
                               gender: "Девочка",
                               birthday: ISO8601DateFormatter().date(from: "2020-04-28T00:00:00Z")!)
}

extension AdvertCard {
    static let dummy = AdvertCard(name: "Котяра",
                                  type: "Собака",
                                  breed: "Австралийская овчарка (аусси)",
                                  gender: "Девочка",
                                  birthday: ISO8601DateFormatter().date(from: "2020-04-28T00:00:00Z")!,
                                  price: 12999,
                                  description: "пожалуйста купите умоляю прошу вас я бедный студент без еды и денег",
                                  city: "Нижний Новгород",
                                  district: "Советский р-н",
                                  publication: ISO8601DateFormatter().date(from: "2023-02-18T16:12:28Z")!)
}

extension AdvertCardList {
    static let dummy = AdvertCardList(adverts: [.dummy, .init(), .init(), .init(), .init()])
}

extension Advert {
    static let dummy = Advert(name: "Котяра",
                              type: "Собака",
                              breed: "Австралийская овчарка (аусси)",
                              gender: "Девочка",
                              birthday: ISO8601DateFormatter().date(from: "2020-04-28T00:00:00Z")!,
                              care: "Очень любит водку, квас и соленые огурцы",
                              price: 12999,
                              description: "пожалуйста купите умоляю прошу вас я бедный студент без еды и денег",
                              chat: true,
                              phone: "+7 123 456-78-90",
                              city: "Нижний Новгород",
                              district: "Советский р-н",
                              publication: ISO8601DateFormatter().date(from: "2023-02-18T16:12:28Z")!)
}

extension Message {
    static let dummy = Message(text: "Hello, World!", from: "1", to: "0", timestamp: .now)
}

extension Dialog {
    static let dummy = Dialog(
        messages: [
            .dummy,
            .init(text: .LoremIpsum.russian, from: "0", to: "1", timestamp: .distantPast),
        ],
        chatID: "1",
        username: "Test Testing",
        connected: false)
}
