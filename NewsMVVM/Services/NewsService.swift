//
//  NewsService.swift
//  NewsMVVM
//
//  Created by Mangust on 25.08.2024.
//

import Foundation

struct NewsService {
    func getNews(_ page: Int, _ perPageLimit: Int) async -> NewsEntity? {
        try? await getData(
            from: "\(Constants.mainUrl)/\(page)/\(perPageLimit)"
        )
    }

    func getTotalCount(page: Int, perPageLimit: Int) async -> Int? {
        await getNews(page, perPageLimit)?.totalCount
    }
}

fileprivate extension NewsService {
    func decode(from jsonData: Data) -> NewsEntity? {
        let decoder = JSONDecoder()

        do {
            return try decoder.decode(NewsEntity.self, from: jsonData)
        } catch {
            return nil
        }
    }

    func getData(from urlString: String) async throws -> NewsEntity? {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        return decode(from: data)
    }

    enum Constants {
        static let mainUrl = "https://webapi.autodoc.ru/api/news"
    }
}
