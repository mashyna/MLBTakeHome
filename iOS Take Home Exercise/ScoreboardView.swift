//
//  ScoreboardView.swift
//  iOS Take Home Exercise
//
//  Created by Matthew Mashyna on 1/29/23.
//  Copyright © 2023 Lewanda, David. All rights reserved.
//

import SwiftUI

struct ScoreboardView: View {
    /// Our model
    @StateObject var model = ScoreboardViewModel()

    // Fonts
    let navFontRegular = Font.system(size: 16)
    let navFontBold = Font.system(size: 16, weight: .semibold)

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    header

                    if model.noGamesToday == true {
                        // Show that there's no gaves on the selected day
                        noGamesView
                    }
                    else {
                        // Show the list of scores
                        scoreList
                    }
                    Spacer()
                    // shamless self-promotion
                    Text("Matt Mashyna")
                        .font(.system(size: 9))
                }
                .alert(isPresented: $model.showAlert) {
                    // Show an alert if the model indicates there is one
                    Alert(title: Text("Error"), message: Text("An error occured. Please try again"), dismissButton: .default(Text("OK")) {
                        model.clearErrors()
                    })
                }

                if model.isBusy {
                    // Show a busy spinner when busy
                    busyView
                }
            }
        }
        .navigationViewStyle(.stack) // prevent crappy iPad nav
    }

    /// The top part of the view
    private var header: some View {
        VStack {
            logo
            Divider()
            dateNavView
                .frame(height: 32)
            Divider()
        }
    }

    /// The list of scores
    private var scoreList: some View {
        List {
            ForEach(model.scores, id: \.gamePk) { game in
                ZStack(alignment: .leading) {
                    NavigationLink {
                        ScoreDetailView(game: game)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)
                    ScoreboardCellView(game: game)
                }
            }
        }
        .listStyle(.plain)
    }

    /// A logo to show at the top
    private var logo: some View {
        Image("MLBLogo")
    }

    /// Allows selection of the date
    private var dateNavView: some View {
        HStack {
            // Button to go backward
            Button {
                model.previousDay()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .padding(.horizontal)
            }

            Spacer()

             // SwiftUI's date picker breaks the theme so we fool with it
            ZStack {
                DatePicker("", selection: $model.currentDate, displayedComponents: [.date])
                    .labelsHidden()

                // cover the goofy SwiftUI date picker display
                Rectangle()
                    .foregroundColor(.white)
                    .allowsHitTesting(false)

                // Show our better, custom date
                HStack {
                    Text(model.currentDayString ?? "")
                        .font(navFontRegular)
                    Text(model.currentDateString ?? "")
                        .font(navFontBold)
                }
                .allowsHitTesting(false)
            }

            Spacer()

            // Button to go forward
            Button {
                model.nextDay()
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
                    .padding(.horizontal)
            }
       }
    }

    /// Show an overlay when the model is busy
    private var busyView: some View {
        ZStack {
            Color.black.opacity(0.5)

            ProgressView()
                .scaleEffect(2, anchor: .center)
        }
        .ignoresSafeArea()
    }

    /// Show that there are no games for this day
    private var noGamesView: some View {
        Text("")
    }
}

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardView()
    }
}

extension UISplitViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredDisplayMode = .secondaryOnly
        self.preferredSplitBehavior = .overlay
    }
}
