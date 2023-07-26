//
//  GradientLayer.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-17.
//

import SwiftUI

public struct GradientLayer: IconLayer {
    public var id: UUID = UUID()
    public var index: Int = 0
    public var startPoint: UnitPoint
    public var endPoint: UnitPoint
    public var fill: LinearGradient
    public var rotation: Double = Double.random(in: 1...360)
    public var positionX: CGFloat = CGFloat.random(in: 1...1000)
    public var positionY: CGFloat = CGFloat.random(in: 1...1000)
    public var opacity: CGFloat = CGFloat.random(in: 0.1...1)
    public var mask: AnyView?
    public var toggleUi: AnyView?
    public var visible: Bool = true

    private var screenH: CGFloat = 1000
    private var screenW: CGFloat = 1000
    private var colours: [Color] = []

//    @State public var enabled: Bool = true

    public init(colours: [Color], screenH: CGFloat, screenW: CGFloat) {
        self.startPoint = .top
        self.endPoint = .bottom
        self.colours = colours
        self.fill = LinearGradient(gradient: Gradient(colors: colours), startPoint: self.startPoint, endPoint: self.endPoint)
        self.index += 1
//        self.toggleUi = AnyView(Toggle("Layer \(id)", isOn: $enabled))
        self.screenH = screenH
        self.screenW = screenW
    }

    mutating public func randomize() -> Void {
        let points = [UnitPoint.top, UnitPoint.bottom, UnitPoint.leading, UnitPoint.trailing]

        startPoint = points.randomElement()!
        endPoint = points.randomElement()!

        // TODO: This works, but needs to be an option since the colours for each layer are completely random
        // TODO: will need to make all the colours based on the same random set instead of a random set for each
        // TODO: individual layer
//        colours = [
//            Color.random(),
//            Color.random(),
//            Color.random()
//        ]
//
//        fill = LinearGradient(gradient: Gradient(colors: colours), startPoint: startPoint, endPoint: endPoint)
        // TODO: end

        rotation = Double.random(in: 1...360)
        positionX = CGFloat.random(in: 1...screenW)
        positionY = CGFloat.random(in: 1...screenH)
        opacity = CGFloat.random(in: 0.1...1)

        let shapes: [any View] = [Circle(), Rectangle(), Ellipse(), Capsule()]
        let shape = shapes.randomElement()!
            .frame(width: CGFloat.random(in: 100...1024), height: CGFloat.random(in: 100...1024))
            .position(x: positionX, y: positionY)

        mask = AnyView(shape)
    }

    mutating public func toggle() -> Void {
        visible.toggle()
    }
}
