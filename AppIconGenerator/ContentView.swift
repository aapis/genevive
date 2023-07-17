//
//  ContentView.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-15.
//

import SwiftUI

struct ContentView: View {
    @Binding public var colours: [Color]
    @Binding public var gradientLayers: [any IconLayer]
    @Binding public var startPoint: UnitPoint
    @Binding public var endPoint: UnitPoint
    @Binding public var numberOfLayers: Float
    @Binding public var maskCornerRoundness: Float
    @Binding public var constrained: Bool
    @Binding public var backgroundColour: Int
    @Binding public var shapeFillType: Int
    @Binding public var sfsAppIcon: String

    var body: some View {
        VStack {
            ZStack {
                BackgroundColour(use: $backgroundColour, set: $colours).render()

                ForEach(gradientLayers, id: \(any IconLayer).id) { layer in
                    if layer.visible {
                        layer.fill
                            .rotationEffect(.degrees(layer.rotation))
                            .position(x: layer.positionX, y: layer.positionY)
                            .opacity(layer.opacity)
                            .mask {
                                layer.mask
                            }
                    }
                }

                if !sfsAppIcon.isEmpty {
                    Image(systemName: sfsAppIcon)
                        .font(.system(size: 700))
                        .opacity(0.8)
                        .foregroundColor(colours.first!.isBright() ? Color.black : Color.white)
                        .symbolRenderingMode(.hierarchical)
                }
            }
            .mask(
                constrained ?
                ZStack {
                    RoundedRectangle(cornerRadius: CGFloat(maskCornerRoundness))
                        .frame(width: 1016, height: 1016)
                }
                : nil
            )
        }
        .shadow(color: .black.opacity(0.3), radius: 8, x: 10, y: -10)
        .frame(width: 1124, height: 1124)
        .onAppear(perform: updateLayers)
        .onChange(of: numberOfLayers) { _ in
            updateLayers()
        }
    }

    private func updateLayers() -> Void {
        for _ in 0...Int(numberOfLayers) {
            var layer: any IconLayer = shapeFillType == 0 ? GradientLayer(colours: colours) : SolidLayer(colours: colours)
            layer.randomize()

            if gradientLayers.count > Int(numberOfLayers) {
                gradientLayers.removeAll()
            } else {
                gradientLayers.append(layer)
            }
        }
    }
}
