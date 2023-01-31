//
//  MLBAPIs.swift
//  iOS Take Home Exercise
//
//  Created by Matthew Mashyna on 1/29/23.
//  Copyright © 2023 Lewanda, David. All rights reserved.
//

import Foundation

class MLBAPIs {
    /// Fetch scores for a specific date
    /// - parameter date: That date to fetch scores for
    /// - parameter completion: A completion closure returning scores or an error
    static func fetchScoreboardData(for date: Date, completion: @escaping (Result<ScoreList, Error>) -> Void) {
        let dateFomater = DateFormatter()
        dateFomater.dateFormat = "yyyy-MM-dd"
        let dateString = dateFomater.string(from: date)
        let urlString = "https://statsapi.mlb.com/api/v1/schedule?hydrate=team(league),venue(location,timezone),linescore&date=\(dateString)&sportId=1,51&language=en"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(MLBAPIerror.urlError))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(MLBAPIerror.dataError))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let scores = try decoder.decode(ScoreList.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(scores))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }

        }
        task.resume()

    }
}
