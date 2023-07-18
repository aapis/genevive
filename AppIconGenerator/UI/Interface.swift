//
//  Interface.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-16.
//

import SwiftUI

struct Interface: View {
    @Binding public var colours: [Color]
    @Binding public var layers: [any IconLayer]
    @Binding public var startPoint: UnitPoint
    @Binding public var endPoint: UnitPoint
    @Binding public var numberOfLayers: Float
    @Binding public var maskCornerRoundness: Float
    @Binding public var constrained: Bool
    @Binding public var backgroundColour: Int
    @Binding public var shapeFillType: Int
    @Binding public var uiVisible: Bool
    @Binding public var sfsAppIcon: String
    @Binding public var imageType: GeneratedImageType

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.accentColor
                .shadow(color: .black.opacity(0.3), radius: 0, x: 10, y: 10)

            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            uiVisible.toggle()
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.plain)
                    .onHover { inside in
                        if inside {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
                }
                Text("Configuration")
                    .font(.title)

                VStack(alignment: .leading) {
                    Divider()

                    Text("Layers")
                        .font(.title3)
                    Text("Change the number of layers to achieve different, random, effects!")

                    HStack {
                        VStack {
                            if shapeFillType == 1 {
                                Slider(value: $numberOfLayers, in: 1...20)
                            } else {
                                Slider(value: $numberOfLayers, in: 1...300)
                            }

                            Text("\(Int(numberOfLayers))")
                        }

                        if imageType == .icon {
                            VStack {
                                Slider(value: $maskCornerRoundness, in: 0...300) {
                                    Text("Bevel")
                                }

                                Text("\(Int(maskCornerRoundness))")
                            }
                        }
                    }
                }

                VStack(alignment: .leading) {
                    Divider()

                    Text("Colours")
                        .font(.title3)
                    Text("Change shape fill, background colour, or randomize colours")

                    HStack {
                        Picker("Shape fill type", selection: $shapeFillType) {
                            Text("Gradient").tag(0)
                            Text("Solid").tag(1)
                        }

                        Picker("Background colour", selection: $backgroundColour) {
                            Text("From random set").tag(0)
                            Text("White").tag(1)
                            Text("Black").tag(2)
                        }

                        Button {
                            withAnimation {
                                colours = [
                                    Color.random(),
                                    Color.random(),
                                    Color.random()
                                ]
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .font(.title)
                                .help("Randomize colours")
                        }
                        .buttonStyle(.plain)
                        .onHover { inside in
                            if inside {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                        // TODO: add this back, make it work to generate large scale art
                        Toggle("Size constraints?", isOn: $constrained)
                            .onChange(of: constrained) { _ in
                                if constrained {
                                    imageType = .icon
                                } else {
                                    imageType = .wallpaper
                                }
                            }
                    }
                }

                if imageType == .icon {
                    VStack(alignment: .leading) {
                        Divider()

                        Text("Icon")
                            .font(.title3)
                        Text("Choose an icon from the SF Symbols app/library")

                        HStack {
                            TextField("SF Symbols icon", text: $sfsAppIcon)
                        }
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}

