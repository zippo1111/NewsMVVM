//
//  NewsEntity.swift
//  NewsMVVM
//
//  Created by Mangust on 25.08.2024.
//

struct NewsEntity: Codable {
    let news: [NewsArticleEntity]
    let totalCount: Int
}
