//
//  Model.swift
//  news_API
//
//  Created by Cenk Bahadır Çark on 4.08.2022.
//

import Foundation

struct NewsResponse: Codable {
    let status: String?
    let news: [News]?
    let page: Int?
}

struct News: Codable {
    let id, title, newsDescription: String?
    let url: String?
    let author: String?
    let image: String?
    let language: Language?
    let category: [String]?
    let published: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case newsDescription = "description"
        case url, author, image, language, category, published
    }
}
    //Can be change
enum Language: String, Codable {
    case en = "en"
    case es = "es"
}
