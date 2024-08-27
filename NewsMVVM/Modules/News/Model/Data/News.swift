//
//  News.swift
//  NewsMVVM
//
//  Created by Mangust on 26.08.2024.
//

import UIKit

struct NewsArticle {
    let title: String
    let titleImage: UIImage
}

struct News {
    let news: [NewsArticle]
    let page: Int
}
