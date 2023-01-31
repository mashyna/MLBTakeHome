//
//  ScoreboardViewModel.swift
//  iOS Take Home Exercise
//
//  Created by Matthew Mashyna on 1/29/23.
//  Copyright © 2023 Lewanda, David. All rights reserved.
//

import Foundation

class ScoreboardViewModel: ObservableObject {
    /// Tells the UI we're busy
    @Published var isBusy = false

    /// Published list of scores
    @Published var scores = [GameInfo]()

    /// Published date we're showing scores for
    @Published var currentDate = Date() {
        didSet {
            fetchScores()
        }
    }

    /// Tell the UI that an error has occurred
    @Published var showAlert = false
    var error: Error?

    /// Clear errors
    func clearErrors() {
        error = nil
        showAlert = false
    }

    /// Shows that no games are available for the selected date
    @Published var noGamesToday: Bool?

    /// Provide a string for the current daye like "September 12"
    var currentDateString: String? {
        dateFormatter.string(from: currentDate)
    }

    /// Provide a name for the current day like "Monday"
    var currentDayString: String? {
        dayFormatter.string(from: currentDate)
    }

    /// Our private list
    private var scoreList: ScoreList?

    // date formatters
    private let dateFormatter = DateFormatter()
    private let dayFormatter = DateFormatter()

    /// Select the previous day's games to fetch
    func previousDay() {
        currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        fetchScores()
    }

    /// Select the next day's games to fetch
    func nextDay() {
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        fetchScores()
    }

    init() {
        dateFormatter.dateFormat = "MMMM dd"
        dayFormatter.dateFormat = "EEEE"

        // start with a date that's in season
        let tFormatter = DateFormatter();
        tFormatter.dateFormat = "yyyy-MM-dd"
        currentDate = tFormatter.date(from: "2018-09-18") ?? Date()

        fetchScores()
    }

    /// Public API to fetch scores
    func refresh() {
        fetchScores()
    }

    /// Fetch scores for the day
    private func fetchScores() {
        isBusy = true
        MLBAPIs.fetchScoreboardData(for: currentDate) { result in
            switch result {
            case .success(let scores):
                self.scoreList = scores
                self.scores = self.sortScores(self.scoreList?.dates.first?.games)
                self.noGamesToday = self.scores.count == 0

            case .failure(let error):
                print(error.localizedDescription)
                self.error = error
                self.showAlert = true
            }

            self.isBusy = false
        }
    }

    /// Sort the games by date
    private func sortScores(_ games: [GameInfo]?) -> [GameInfo] {
        guard let unsorted = games else {
            return []
        }

        return unsorted.sorted(by: { $0.gameDate < $1.gameDate })
    }
}
