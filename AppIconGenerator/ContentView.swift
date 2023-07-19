//
//  ContentView.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-15.
//

import SwiftUI

struct ContentView: View {
    @Binding public var colours: [Color]
    @Binding public var planes: Int
    @Binding public var gradientLayers: [any IconLayer]
    @Binding public var startPoint: UnitPoint
    @Binding public var endPoint: UnitPoint
    @Binding public var numberOfLayers: Float
    @Binding public var maskCornerRoundness: Float
    @Binding public var constrained: Bool
    @Binding public var backgroundColour: Int
    @Binding public var shapeFillType: Int
    @Binding public var sfsAppIcon: String
    @Binding public var imageType: GeneratedImageType
    @Binding public var screenH: CGFloat
    @Binding public var screenW: CGFloat
    @Binding public var invertIconColour: Bool

    var body: some View {
        VStack {
            let content = ZStack {
                if backgroundColour == 3 {
                    LinearGradient(gradient: Gradient(colors: colours), startPoint: .top, endPoint: .bottom)
                } else {
                    BackgroundColour(use: $backgroundColour, set: $colours).render()
                }

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

                if imageType == .icon {
                    if !sfsAppIcon.isEmpty {
                        Image(systemName: sfsAppIcon)
                            .font(.system(size: 700))
                            .opacity(0.8)
                            .foregroundColor(iconFgColour())
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }

            if imageType == .icon {
                content
                    .mask(
                        ZStack {
                            RoundedRectangle(cornerRadius: CGFloat(maskCornerRoundness))
                                .frame(width: 1016, height: 1016)
                        }
                    )
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 10, y: -10)
                    .frame(width: 1124, height: 1124)
                    .background(.clear)
            } else if imageType == .wallpaper {
                content
                    .frame(width: screenW, height: screenH)
            }

        }
        .onAppear(perform: updateLayers)
        .onChange(of: numberOfLayers) { _ in
            updateLayers()
        }
        .onChange(of: colours) { newColours in
            modifyLayers()
        }

    }

    private func updateLayers() -> Void {
        // reset each time does destroy the current state but avoids the problem of too many layers
        gradientLayers = []

        for _ in 0...Int(numberOfLayers) {
            var layer: any IconLayer = shapeFillType == 0 ? GradientLayer(colours: colours, screenH: screenH, screenW: screenW) : SolidLayer(colours: colours, screenH: screenH, screenW: screenW)
            layer.randomize()

            gradientLayers.append(layer)
        }
    }

    private func modifyLayers() -> Void {
        for i in 0...Int(numberOfLayers) {
            gradientLayers[i].randomize()
        }

        // For some reason this is required to trigger a view refresh. Above loop should too?
        numberOfLayers += 1
    }

    private func iconFgColour() -> Color {
        let colour = colours.first!.isBright() ? Color.black : Color.white

        if invertIconColour {
            if colour == .black {
                return Color.white
            } else {
                return Color.black
            }
        }

        return colour
    }
}
