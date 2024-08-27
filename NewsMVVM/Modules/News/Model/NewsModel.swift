//
//  NewsModel.swift
//  NewsMVVM
//
//  Created by Mangust on 25.08.2024.
//

import UIKit

struct NewsModel {
    func getNextNews(currentPage: Int) async -> News? {
        do {
            let articles = try await withThrowingTaskGroup(
                of: NewsArticle.self, returning: [NewsArticle]?.self
            ) { group in
                let nextPage = currentPage + 1
                await prepareResponse(page: nextPage)?.news.forEach { item in
                    group.addTask {
                        try await NewsArticle(
                            title: item.title,
                            titleImage: downloaderService.downloadImage(
                                from: URL(string: item.titleImageUrl)
                            )
                        )
                    }
                }

                return try await group.reduce(into: [NewsArticle]()) {
                    $0.append($1)
                }
            }

            guard let articles = articles else {
                return nil
            }

            return News(news: articles, page: currentPage + 1)
        } catch {
            return nil
        }
    }

    func getPrevNews(currentPage: Int) async -> News? {
        do {
            let articles = try await withThrowingTaskGroup(
                of: NewsArticle.self, returning: [NewsArticle]?.self
            ) { group in
                let prevPage = currentPage - 1
                await prepareResponse(page: prevPage)?.news.forEach { item in
                    group.addTask {
                        try await NewsArticle(
                            title: item.title,
                            titleImage: downloaderService.downloadImage(
                                from: URL(string: item.titleImageUrl)
                            )
                        )
                    }
                }

                return try await group.reduce(into: [NewsArticle]()) {
                    $0.append($1)
                }
            }

            guard let articles = articles else {
                return nil
            }

            return News(news: articles, page: currentPage - 1)
        } catch {
            return nil
        }
    }

    private func prepareResponse(page: Int) async -> NewsEntity? {
        let response = await newsService.getNews(1, Constants.defaultPerPageLimit)
        let total = response?.totalCount ?? 15
        let pages = Array(1...total/Constants.defaultPerPageLimit)

        guard pages.contains(page) else {
            return nil
        }

        return await newsService.getNews(page, Constants.defaultPerPageLimit)
    }

    private var newsService = NewsService()
    private var downloaderService = ImageDownloaderService()
}

fileprivate extension NewsModel {
    enum Constants {
        static let defaultPerPageLimit = 5
    }
}
