//
//  BackgroundColour.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-17.
//

import SwiftUI

public struct BackgroundColour {
    @Binding public var use: Int
    @Binding public var set: [Color]

    public func render() -> Color {
        if use == 0 {
            return set.first!
        } else if use == 1 {
            return Color.white
        }

        return Color.black
    }
}
