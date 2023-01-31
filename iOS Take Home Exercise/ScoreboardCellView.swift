//
//  ScoreboardCellView.swift
//  iOS Take Home Exercise
//
//  Created by Matthew Mashyna on 1/29/23.
//  Copyright © 2023 Lewanda, David. All rights reserved.
//

import SwiftUI

/// Displays the Away team over the Home team
struct ScoreboardCellView: View {
    let game: GameInfo

    var body: some View {
        VStack(alignment:.leading) {
            TeamView(teamInfo: game.teams.away, info: game)
            TeamView(teamInfo: game.teams.home, info: nil)
        }
    }
}

/// Constructs a row for each teams's score
struct TeamView: View {
    let teamInfo: TeamDetailInfo
    let info: GameInfo?
    let navColor = Color("navColor")

    let scoreFont = Font.system(size: 24, weight: .semibold)
    let teamFont = Font.system(size: 18)
    let recordFont = Font.system(size: 12)
    let statusFont = Font.system(size: 14, weight: .medium)

    var body: some View {
        ZStack {
            HStack {
                Image(teamInfo.team.teamCode)
                    .resizable()
                    .frame(width:50, height: 40)
                    .aspectRatio(contentMode: .fit)
                
                VStack(alignment:.leading) {
                    Text(teamInfo.team.teamName)
                        .font(teamFont)

                    Text("\(teamInfo.leagueRecord.wins)-\(teamInfo.leagueRecord.losses)")
                        .foregroundColor(.gray)
                        .font(recordFont)
                }

                Spacer()

                Text(statusText())
                    .foregroundColor(navColor)
                    .font(statusFont)
            }

            // The score loats off center to the right
            Text("\(teamInfo.score)")
                .font(scoreFont)
                .offset(x:40, y:0)
       }
    }

    /// Provides info about the game state like "Final"
    private func statusText() -> String {
        guard let status = info?.gamePlayStatusText else {
            return ""
        }

        return "\(status) >"
    }
}

struct ScoreboardCellView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardCellView(game: GameInfo.sample)
    }
}
