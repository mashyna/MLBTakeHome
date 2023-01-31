//
//  ScoreDetailView.swift
//  iOS Take Home Exercise
//
//  Created by Matthew Mashyna on 1/30/23.
//  Copyright © 2023 Lewanda, David. All rights reserved.
//

import SwiftUI

struct ScoreDetailView: View {
    let game: GameInfo
    let plainFont = Font.system(size: 14)
    let boldFont = Font.system(size: 14, weight: .bold)
    let finalFont = Font.system(size: 28, weight: .medium)
    let logoHeight: CGFloat = 30
    let logoWidth: CGFloat = 40

    var body: some View {
        VStack {
            header
            finalScore
                .padding(.top)

            boxScore
                .padding(.top)
            Spacer()
        }
        .padding()

    }

    /// View Header
    private var header: some View {
        VStack {
            Text(game.gameDateString)
            Text(game.venue.name)
        }
    }

    /// Runs, hits and errors
    private var finalScore: some View {
        HStack(alignment: .imageTitleAlignmentGuide) {
            logoColumn
            teamColumn
           finalColumns()
        }
        .font(finalFont)
    }

    /// Score with innings detail
    private var boxScore: some View {
        VStack(alignment: .center) {
            HStack(alignment: .bottom) {
                teamColumn
                    .font(plainFont)

                ForEach(game.linescore.innings!, id: \.num) { inning in
                    inningColumn(inning)
                }
                .font(plainFont)

                finalColumns()
                    .font(boldFont)
                    .padding(.leading, 5)

            }
        }
    }

    /// A column with the away over the home team names
    private var teamColumn: some View {
        VStack(alignment: .leading) {
            Text(game.teams.away.team.teamName)
            Text(game.teams.home.team.teamName)
        }
    }

    /// A column with the away over the home team logos
    private var logoColumn: some View {
        VStack {
            Image(game.teams.away.team.teamCode)
                .resizable()
                .scaledToFit()
                .frame(width:logoWidth, height: logoHeight)
                .aspectRatio(contentMode: .fit)

            Image(game.teams.home.team.teamCode)
                .resizable()
                .scaledToFit()
                .frame(width:logoWidth, height: logoHeight)
                .aspectRatio(contentMode: .fit)

        }
    }

    /// A column with the away over the home team score by inning
    private func inningColumn(_ inning: InningInfo) -> some View {
        VStack {
            Text("\(inning.num)")
            Text("\(inning.away.runs ?? 0)")
            Text("\(inning.home.runs ?? 0)")
        }
    }

    /// A set of columns with the away over the home team stats
    private func finalColumns() -> some View {
        HStack {
            VStack {
                Text("R")
                Text("\(game.linescore.teams.away.runs ?? 0)")
                Text("\(game.linescore.teams.home.runs ?? 0)")
            }
            VStack {
                Text("H")
                Text("\(game.linescore.teams.away.hits ?? 0)")
                Text("\(game.linescore.teams.home.hits ?? 0)")
            }
            VStack {
                Text("E")
                Text("\(game.linescore.teams.away.errors ?? 0)")
                Text("\(game.linescore.teams.home.errors ?? 0)")
            }
        }
   }
}

struct ScoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreDetailView(game: GameInfo.sample)
    }
}

/// helps with score alignment
extension VerticalAlignment {
    /// A custom alignment for image titles.
    private struct ImageTitleAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            // Default to bottom alignment if no guides are set.
            context[VerticalAlignment.bottom]
        }
    }

    /// A guide for aligning titles.
    static let imageTitleAlignmentGuide = VerticalAlignment(
        ImageTitleAlignment.self
    )
}
