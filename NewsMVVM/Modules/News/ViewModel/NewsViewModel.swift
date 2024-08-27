//
//  NewsViewModel.swift
//  NewsMVVM
//
//  Created by Mangust on 25.08.2024.
//

import UIKit

struct NewsArticlesPageViewModel {
    let articles: [NewsArticleViewModel]
    let currentPage: Int
}

struct NewsArticleViewModel {
    let title: String
    let titleImage: UIImage
}

@MainActor
final class NewsViewModel {

    func fetchNextNews(page: Int) async -> NewsArticlesPageViewModel? {
        guard let response = await model.getNextNews(currentPage: page) else {
            return nil
        }

        let articles = response.news.map {
            NewsArticleViewModel(
                title: $0.title,
                titleImage: $0.titleImage
            )
        }

        return NewsArticlesPageViewModel(
            articles: articles,
            currentPage: response.page
        )
    }

    func fetchPrevNews(page: Int) async -> NewsArticlesPageViewModel? {
        guard let response = await model.getPrevNews(currentPage: page) else {
            return nil
        }

        let articles = response.news.map {
            NewsArticleViewModel(
                title: $0.title,
                titleImage: $0.titleImage
            )
        }

        return NewsArticlesPageViewModel(
            articles: articles,
            currentPage: response.page
        )
    }

    var news: [NewsArticleViewModel]? = []

    private let model = NewsModel()
}
