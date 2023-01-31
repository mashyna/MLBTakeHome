//
//  MLBAPIStructs.swift
//  iOS Take Home Exercise
//
//  Created by Matthew Mashyna on 1/30/23.
//  Copyright © 2023 Lewanda, David. All rights reserved.
//

import Foundation

/// Defines the current state of a game
enum GamePlayStatus {
    case unknown
    case notStarted(start: Date)
    case inProgress(inning: Int, side: String)
    case rainDelay
    case complete(innings: Int)
}

struct GameStatus: Codable {
    let abstractGameState: String
    let codedGameState: String
    let detailedState: String
}

struct LeagueRecord: Codable {
    let wins: Int
    let losses: Int
    let pct: String
}

struct TeamInfo: Codable {
    let name: String
    let shortName: String
    let teamName: String
    let teamCode: String
}

struct TeamDetailInfo: Codable {
    let leagueRecord: LeagueRecord
    let team: TeamInfo
    let score: Int
    let isWinner: Bool
}

struct TeamPairInfo: Codable {
    let home: TeamDetailInfo
    let away: TeamDetailInfo
}

struct VenueInfo: Codable {
    let id: Int
    let name: String
}

struct InningStats: Codable {
    let runs: Int?
    let hits: Int?
    let errors: Int?
    let leftOnBase: Int?
    let isWinner: Bool?
}

struct InningInfo: Codable {
    let num: Int
    let ordinalNum: String
    let home: InningStats
    let away: InningStats
}

struct Linescore: Codable {
    let currentInning: Int
    let currentInningOrdinal: String
    let inningState: String
    let innings: [InningInfo]?
    let teams: FinalStats

    var inningCount: Int {
        innings?.count ?? 0
    }
}

struct FinalStats: Codable {
    let home: InningStats
    let away: InningStats
}

struct GameInfo: Codable {
    let gamePk: Int
    let venue: VenueInfo
    let link: String
    let gameType: String
    let season: String
    let gameDate: Date
    let officialDate: String
    let status: GameStatus
    let scheduledInnings: Int
    let teams: TeamPairInfo
    let linescore: Linescore
}

struct ScoreInfo: Codable {
    let date: String
    let totalItems: Int
    let totalEvents: Int
    let totalGames: Int
    let totalGamesInProgress: Int
    let games: [GameInfo]
}

struct ScoreList: Codable {
    let totalItems: Int
    let totalGamesInProgress: Int
    let copyright: String
    let dates: [ScoreInfo]
}

enum MLBAPIerror: Error {
    case urlError
    case dataError
    case someError
}

// MARK: - Extensions

extension GameInfo {
    static var sample: GameInfo{
        GameInfo(gamePk: 531687,
                 venue: VenueInfo.sample,
                 link: "/api/v1/venues/2889",
                 gameType: "R",
                 season: "2018",
                 gameDate: Date(),
                 officialDate: "2018-09-19",
                 status: GameStatus.sample,
                 scheduledInnings: 9,
                 teams: .sample,
                 linescore: .sample)
    }

    /// Provides a concrete status
    var gamePlayStatus: GamePlayStatus {
        if status.codedGameState == "F" {
            return .complete(innings: linescore.inningCount)
        }

        if gameDate < Date() {
            return .notStarted(start: gameDate)
        }

        return .inProgress(inning: linescore.currentInning, side: linescore.inningState)
    }

    /// Provides a concrete status text
    var gamePlayStatusText: String {
        switch gamePlayStatus {
        case .unknown:
            return ""

        case .notStarted(let start):
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return "\(formatter.string(from: start))"

        case .inProgress:
            return "\(linescore.inningState) of the \(linescore.currentInningOrdinal)>"

        case .rainDelay:
            return "Delay"

        case .complete(innings: let innings):
            if innings != 9 {
                return "Final/\(innings)"
            }

            return "Final"
        }
    }

    var gameDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: gameDate)

    }
}

extension VenueInfo {
    static var sample: VenueInfo {
        VenueInfo(id: 2889, name: "Busch Stadium")
    }
}

extension GameStatus {
    static var sample: GameStatus {
        GameStatus(abstractGameState: "Final",
                   codedGameState: "F",
                   detailedState: "Final")
    }
}

extension TeamPairInfo {
    static var sample: TeamPairInfo {
        TeamPairInfo(home: .sample1,
                     away: .sample2)
    }
}

extension TeamDetailInfo {
    static var sample1: TeamDetailInfo {
        TeamDetailInfo(leagueRecord: .sample, team: .sample1, score: 5, isWinner: true)
    }

    static var sample2: TeamDetailInfo {
        TeamDetailInfo(leagueRecord: .sample, team: .sample2, score: 5, isWinner: true)
    }
}

extension LeagueRecord {
    static var sample: LeagueRecord {
        LeagueRecord(wins: 80, losses: 80, pct: "0.500")
    }
}

extension TeamInfo {
    static var sample1: TeamInfo {
        TeamInfo(name: "Pittsburgh Pirates", shortName: "Pirates", teamName: "Pirates", teamCode: "pit")
    }

    static var sample2: TeamInfo {
        TeamInfo(name: "Cleveland Guardians", shortName: "Guardians", teamName: "Guardians", teamCode: "cle")
    }
}

extension Linescore {
    static var sample : Linescore {
        Linescore(currentInning: 9,
                  currentInningOrdinal: "9th",
                  inningState: "Top",
                  innings: [InningInfo.sample(1),
                            InningInfo.sample(2),
                            InningInfo.sample(3),
                            InningInfo.sample(4),
                            InningInfo.sample(5),
                            InningInfo.sample(6),
                            InningInfo.sample(7),
                            InningInfo.sample(8),
                            InningInfo.sample(9)],
                  teams: .sample)
    }
}

extension InningInfo {
    static func sample(_ inning: Int) -> InningInfo {
        InningInfo(num: inning,
                   ordinalNum: "\(inning)th",
                   home: .sample1,
                   away: .sample2)
    }
}

extension FinalStats {
    static var sample : FinalStats {
        FinalStats(home: .sample1, away: .sample2)
    }
}

extension InningStats {
    static var sample1 : InningStats {
        InningStats(runs: 2, hits: 5, errors: 0, leftOnBase: 6, isWinner: true)
    }
    
    static var sample2 : InningStats {
        InningStats(runs: 1, hits: 4, errors: 1, leftOnBase: 8, isWinner: false)
    }
}
