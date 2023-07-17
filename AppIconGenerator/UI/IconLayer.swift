//
//  IconLayer.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-17.
//

import Foundation
import SwiftUI

public protocol IconLayer: Identifiable {
    var id: UUID {get set}
    var index: Int {get set}
    var startPoint: UnitPoint {get set}
    var endPoint: UnitPoint {get set}
    var fill: LinearGradient {get set}
    var rotation: Double {get set}
    var positionX: CGFloat {get set}
    var positionY: CGFloat {get set}
    var opacity: CGFloat {get set}
    var mask: AnyView? {get set}
    var toggleUi: AnyView? {get set}
    var visible: Bool {get set}

    mutating func randomize() -> Void
    mutating func toggle() -> Void
}
