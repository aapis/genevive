//
//  Interface.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-16.
//

import SwiftUI

struct Interface: View {
    @Binding public var colours: [Color]
    @Binding public var planes: Int
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
    @Binding public var invertIconColour: Bool
    
    @State private var selectedScreenDimensions: Int = 0

    @EnvironmentObject private var storage: Storage

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

                    Picker("Canvas size", selection: $selectedScreenDimensions) {
                        Text("Icon (1024x1024)").tag(0)
                        Text("Wallpaper").tag(1)
                    }
                    .onChange(of: selectedScreenDimensions) { _ in
                        constrained.toggle()

                        if constrained {
                            imageType = .icon
                        } else {
                            imageType = .wallpaper
                        }

                        storage.setType(imageType)
                    }

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
                            Text("Random gradient").tag(3)
                        }
                    }

                    if shapeFillType == 0 {
                        HStack {
                            Picker("Number of gradient stops", selection: $planes) {
                                Text("2").tag(2)
                                Text("3").tag(3)
                            }
                            .onChange(of: planes) { numPlanes in
                                if colours.count == 2 {
                                    if numPlanes == 3 {
                                        colours.append(Color.random())
                                    }
                                } else {
                                    let _ = colours.popLast()
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
                                Toggle("Invert colour", isOn: $invertIconColour)
                            }
                        }
                    }

                    // button group, last section in list
                    Divider()
                    HStack {
                        Button {
                            withAnimation {
                                colours = [
                                    Color.random(),
                                    Color.random(),
                                    Color.random()
                                ]
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.blue)

                                HStack {
                                    Image(systemName: "arrow.clockwise.circle.fill")
                                        .font(.title)
                                        .help("Randomize colours")
                                        .symbolRenderingMode(.hierarchical)
                                    Text("Randomize")
                                }
                                .padding()
                            }
                        }
                        .buttonStyle(.plain)
                        .onHover { inside in
                            if inside {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }

                        Button {
                            storage.saveScreenshot()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.orange)

                                HStack {
                                    Image(systemName: "arrow.down.to.line.circle")
                                        .font(.title)
                                        .help("Save to ~/Pictures/Genevive")
                                        .symbolRenderingMode(.hierarchical)
                                    Text("Save")
                                }
                                .padding()
                            }
                        }
                        .buttonStyle(.plain)
                        .onHover { inside in
                            if inside {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }

                        if imageType == .wallpaper {
                            Button {
                                storage.setAsWallpaper()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.indigo)

                                    HStack {
                                        Image(systemName: "desktopcomputer.and.arrow.down")
                                            .font(.title)
                                            .help("Set as desktop wallpaper")
                                            .symbolRenderingMode(.hierarchical)
                                        Text("Set Desktop Picture")
                                    }
                                    .padding()
                                }
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
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}

