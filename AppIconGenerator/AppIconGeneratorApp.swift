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
            screenW: $screenW
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
            imageType: $imageType
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
                ZStack(alignment: .topLeading) {
                    if imageType == .icon {
                        ScrollView {
                            preview
                        }
                    } else if imageType == .wallpaper { // TODO: may render in a scrollview if its better UX
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
            .onAppear(perform: determineScreenSize)
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("Save") {
                    if imageType == .icon {
                        saveCurrentStateAsIcon(of: preview)
                    } else if imageType == .wallpaper {
                        saveCurrentStateAsWallpaper(of: preview)
                    } else {
                        fatalError("What have you done?")
                    }
                }
                .keyboardShortcut("s", modifiers: .command)
            }
        }

    }

    private var minimizedInterface: some View {
        VStack {
            HStack(spacing: 1) {
                Spacer()
                Button {
                    withAnimation {
                        uiVisible.toggle()
                    }
                } label: {
                    ZStack {
                        Color.accentColor
                            .shadow(color: .black.opacity(0.3), radius: 0, x: 10, y: 10)
                        Image(systemName: "arrow.down.backward.square")
                            .font(.largeTitle)
                            .symbolRenderingMode(.hierarchical)
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
                        Color.blue
                            .shadow(color: .black.opacity(0.3), radius: 0, x: 10, y: 10)
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.largeTitle)
                            .symbolRenderingMode(.hierarchical)
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
//                            LayerNavigator(layers: $layers)
        }
        .padding()
    }

    // TODO: move all these functions to a class
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

    private func saveCurrentStateAsIcon(of: any View) -> Void {
        let (data, url) = saveCurrentState(of: of)

        saveAtSize(screenshot: data!, h: 1024, w: 1024, path: url!)
        saveAtSize(screenshot: data!, h: 512, w: 512, path: url!)
        saveAtSize(screenshot: data!, h: 256, w: 256, path: url!)
        saveAtSize(screenshot: data!, h: 128, w: 128, path: url!)
        saveAtSize(screenshot: data!, h: 64, w: 64, path: url!)
        saveAtSize(screenshot: data!, h: 32, w: 32, path: url!)
        saveAtSize(screenshot: data!, h: 16, w: 16, path: url!)
    }

    private func saveCurrentStateAsWallpaper(of: any View) -> Void {
        let (data, url) = saveCurrentState(of: of)

        saveAtSize(screenshot: data!, h: Int(screenH), w: Int(screenW), path: url!)
    }

    private func saveCurrentState(of: any View) -> (NSImage?, URL?) {
        let screenshot = of.snapshot()
        let generatorCode = Int.random(in: 99999...9999999)
        let exportFolder = "/Genevive/export-\(imageType)-\(generatorCode)/"
        let picturesDir = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!
        let imageURL = picturesDir
            .appending(component: exportFolder)

        do {
            try FileManager.default.createDirectory(atPath: picturesDir.path + "/Genevive", withIntermediateDirectories: false)
        } catch {
            // it already exists, do nothing
        }

        do {
            try FileManager.default.createDirectory(atPath: picturesDir.path + exportFolder, withIntermediateDirectories: false)
        } catch {
            print("Unable to create export folder within app folder")
        }

        if screenshot != nil {
            return (screenshot, imageURL)
        }

        return (nil, nil)
    }

    private func determineScreenSize() -> Void {
        if let screen = NSScreen.main {
            screenH = screen.frame.size.height
            screenW = screen.frame.size.width
        } else {
            print("Unable to determine screen size")
        }
    }
}
