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

    var body: some View {
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
            Text("Change the number of layers to achieve different, random, effects!")
                .font(.body)
            Divider()

            HStack {
                VStack {
                    if shapeFillType == 1 {
                        Slider(value: $numberOfLayers, in: 1...20) {
                            Text("Layers")
                        }
                    } else {
                        Slider(value: $numberOfLayers, in: 1...300) {
                            Text("Layers")
                        }
                    }

                    Text("\(Int(numberOfLayers))")
                }

                VStack {
                    Slider(value: $maskCornerRoundness, in: 0...300) {
                        Text("Roundness")
                    }

                    Text("\(Int(maskCornerRoundness))")
                }
            }

            HStack {
                // TODO: add custom colour fields
                Spacer()

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
                    colours = [
                        Color.random(),
                        Color.random(),
                        Color.random()
                    ]
                    numberOfLayers += 1
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

//                Toggle("Size constraints?", isOn: $constrained)

            }
        }
        .padding()
        .background(Color.accentColor)
    }
}

