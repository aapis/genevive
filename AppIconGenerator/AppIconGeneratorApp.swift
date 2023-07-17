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

@main
struct AppIconGeneratorApp: App {
    @State public var colours: [Color] = [
        Color.random(),
        Color.random(),
        Color.random()
    ]
    @State public var numberOfLayers: Float = 1.0
    @State public var startPoint: UnitPoint = .top
    @State public var endPoint: UnitPoint = .bottom
    @State public var layers: [any IconLayer] = []
    @State public var maskCornerRoundness: Float = 300.0
    @State public var constrained: Bool = true
    @State public var backgroundColour: Int = 0
    @State public var shapeFillType: Int = 0
    @State public var uiVisible: Bool = true

    var body: some Scene {
        let preview = ContentView(
            colours: $colours,
            gradientLayers: $layers,
            startPoint: $startPoint,
            endPoint: $endPoint,
            numberOfLayers: $numberOfLayers,
            maskCornerRoundness: $maskCornerRoundness,
            constrained: $constrained,
            backgroundColour: $backgroundColour,
            shapeFillType: $shapeFillType
        )

        let interface = Interface(
            colours: $colours,
            layers: $layers,
            startPoint: $startPoint,
            endPoint: $endPoint,
            numberOfLayers: $numberOfLayers,
            maskCornerRoundness: $maskCornerRoundness,
            constrained: $constrained,
            backgroundColour: $backgroundColour,
            shapeFillType: $shapeFillType,
            uiVisible: $uiVisible
        )
        
        WindowGroup {
            VStack(alignment: .leading) {
//                HStack(alignment: .top) {
//                    preview
//                        .frame(width: 100, height: 100)
//                        .scaledToFill()
//                        .background(.clear)
//                    interface
//                }
                ZStack(alignment: .top) {
                    ScrollView {
                        preview
                            .frame(width: 1100, height: 1100)
                            .background(.clear)
                    }

                    if uiVisible {
                        interface
                    } else {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation {
                                    uiVisible.toggle()
                                }
                            } label: {
                                ZStack {
                                    Color.accentColor
                                    Image(systemName: "arrow.down.backward.square")
                                        .font(.largeTitle)
                                }
                                .frame(width: 50, height: 50)
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
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("Save") {
                    let screenshot = preview.snapshot()
                    let timestamp = Date.now.timeIntervalSince1970
                    let exportFolder = "/AIG-Export-\(timestamp)/"
                    let picturesDir = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!
                    let imageURL = picturesDir
                        .appending(component: exportFolder)

                    do {
                        try FileManager.default.createDirectory(atPath: picturesDir.path + exportFolder, withIntermediateDirectories: false)
                    } catch {
                        print("Couldn't create folder")
                    }

                    saveAtSize(screenshot: screenshot!, h: 1024, w: 1024, path: imageURL)
                    saveAtSize(screenshot: screenshot!, h: 512, w: 512, path: imageURL)
                    saveAtSize(screenshot: screenshot!, h: 256, w: 256, path: imageURL)
                    saveAtSize(screenshot: screenshot!, h: 128, w: 128, path: imageURL)
                    saveAtSize(screenshot: screenshot!, h: 64, w: 64, path: imageURL)
                    saveAtSize(screenshot: screenshot!, h: 32, w: 32, path: imageURL)
                    saveAtSize(screenshot: screenshot!, h: 16, w: 16, path: imageURL)
                }
                .keyboardShortcut("s", modifiers: .command)
            }
        }
    }

    private func saveAtSize(screenshot: NSImage, h: Int, w: Int, path: URL) -> Void {
        let image = screenshot.resize(w: w, h: h)
        let fileName = "\(h)x\(w).png"

        if let png = image.png {
            do {
                try png.write(to: path.appending(component: fileName))
                print("\(fileName) saved")
            } catch {
                print(error)
            }
        } else {
            print("No PNG data?")
        }
    }
}
