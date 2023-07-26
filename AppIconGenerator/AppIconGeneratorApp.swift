//
//  AppIconGeneratorApp.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-15.
//

import Foundation
import SwiftUI

public enum ShapeFillType {
    case gradient, solid
}

public enum GeneratedImageType {
    case icon, wallpaper
}

@main
struct AppIconGeneratorApp: App {
    @State public var colours: [Color] = [
        Color.random(),
        Color.random()
    ]
    @State public var numberOfGradientPlanes: Int = 3
    @State public var numberOfLayers: Float = 5.0
    @State public var startPoint: UnitPoint = .top
    @State public var endPoint: UnitPoint = .bottom
    @State public var layers: [any IconLayer] = []
    @State public var maskCornerRoundness: Float = 300.0
    @State public var constrained: Bool = true
    @State public var backgroundColour: Int = 0
    @State public var shapeFillType: Int = 0
    @State public var uiVisible: Bool = true
    @State public var sfsAppIcon: String = ""
    @State public var imageType: GeneratedImageType = .icon
    @State private var screenH: CGFloat = 0
    @State private var screenW: CGFloat = 0
    @State private var invertIconColour: Bool = false

    @StateObject public var storage: Storage = Storage()

    var body: some Scene {
        let preview = ContentView(
            colours: $colours,
            planes: $numberOfGradientPlanes,
            gradientLayers: $layers,
            startPoint: $startPoint,
            endPoint: $endPoint,
            numberOfLayers: $numberOfLayers,
            maskCornerRoundness: $maskCornerRoundness,
            constrained: $constrained,
            backgroundColour: $backgroundColour,
            shapeFillType: $shapeFillType,
            sfsAppIcon: $sfsAppIcon,
            imageType: $imageType,
            screenH: $screenH,
            screenW: $screenW,
            invertIconColour: $invertIconColour
        )

        let interface = Interface(
            colours: $colours,
            planes: $numberOfGradientPlanes,
            layers: $layers,
            startPoint: $startPoint,
            endPoint: $endPoint,
            numberOfLayers: $numberOfLayers,
            maskCornerRoundness: $maskCornerRoundness,
            constrained: $constrained,
            backgroundColour: $backgroundColour,
            shapeFillType: $shapeFillType,
            uiVisible: $uiVisible,
            sfsAppIcon: $sfsAppIcon,
            imageType: $imageType,
            invertIconColour: $invertIconColour
        )
            .environmentObject(storage)

        let minimizedInterface = MinimizedInterface(
            colours: $colours,
            uiVisible: $uiVisible
        )
            .environmentObject(storage)
        
        WindowGroup {
            VStack(alignment: .leading) {
                ZStack(alignment: .topLeading) {
                    if imageType == .icon {
                        ScrollView {
                            preview
                        }
                    } else if imageType == .wallpaper {
                        preview
                    }

                    if uiVisible {
                        interface
                            .frame(maxWidth: 700, maxHeight: constrained ? 500 : 400)
                    } else {
                        minimizedInterface
                    }
                }
            }
            .onAppear(perform: {
                storage.setType(imageType)
                storage.setView(preview)

                // TODO: see if we can pass Storage to the structs that need these values
                screenH = storage.screenHeight
                screenW = storage.screenWidth
                
            })
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("Save") {
                    storage.saveScreenshot()
                }
                .keyboardShortcut("s", modifiers: .command)
            }

            CommandGroup(after: .newItem) {
                Button("Randomize colours") {
                    // TODO: put this callback in storage or some similar structure
                    colours = [
                        Color.random(),
                        Color.random(),
                        Color.random()
                    ]
                }
                .keyboardShortcut("r", modifiers: .command)
            }

            CommandGroup(after: .newItem) {
                Button("Set Desktop Picture") {
                    if imageType == .wallpaper {
                        storage.setAsWallpaper()
                    }
                }
                .keyboardShortcut("s", modifiers: [.command, .shift])
                .disabled(imageType != .wallpaper)
            }
        }
    }
}
