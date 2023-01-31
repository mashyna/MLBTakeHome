//
//  ViewController.swift
//  iOS Take Home Exercise
//
//  Created by Lewanda, David on 1/25/19.
//  Copyright © 2019 Lewanda, David. All rights reserved.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    private var scores: ScoreList?

    override func viewDidLoad() {
        super.viewDidLoad()
        addMattsSwiftUIView()
    }

    /// Matt cheats and stuffs in a much better SwiftUI view
    private func addMattsSwiftUIView() {
        // Create the SwiftUI view
        let scoreboardView = ScoreboardView()
        let controller = UIHostingController(rootView: scoreboardView)

        controller.view.translatesAutoresizingMaskIntoConstraints = false

        // Add it as a child view and controller
        addChild(controller)
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)

        let v = controller.view as Any

        // Stick to the parent full view size
        self.view.addConstraints([
            NSLayoutConstraint(
                item: v, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: v, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: v, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(
                item: v, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1,
                constant: 0),
        ])
    }

}

