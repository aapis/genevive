//
//  Storage.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-18.
//

import Foundation
import SwiftUI

public class Storage: ObservableObject {
    public var type: GeneratedImageType = .icon
    public var screenHeight: CGFloat = 100
    public var screenWidth: CGFloat = 100
    public var view: (any View)?
    private var path: URL?

    public func saveCurrentStateAsIcon(of: any View) -> Void {
        let data = saveCurrentState(of: of)

        saveAtSize(screenshot: data!, h: 1024, w: 1024)
        saveAtSize(screenshot: data!, h: 512, w: 512)
        saveAtSize(screenshot: data!, h: 256, w: 256)
        saveAtSize(screenshot: data!, h: 128, w: 128)
        saveAtSize(screenshot: data!, h: 64, w: 64)
        saveAtSize(screenshot: data!, h: 32, w: 32)
        saveAtSize(screenshot: data!, h: 16, w: 16)
    }

    public func saveCurrentStateAsWallpaper(of: any View) -> Void {
        let data = saveCurrentState(of: of)

        saveAtSize(screenshot: data!, h: Int(screenHeight), w: Int(screenWidth))
    }

    public func setView(_ view: some View) -> Void {
        self.view = view
    }

    public func setType(_ type: GeneratedImageType) -> Void {
        self.type = type

        determineScreenSize()
    }

    public func saveScreenshot() -> Void {
        if type == .icon {
            saveCurrentStateAsIcon(of: view!)
        } else if type ==  .wallpaper  {
            saveCurrentStateAsWallpaper(of: view!)
        }
    }

    public func setAsWallpaper() -> Void {
        saveScreenshot()

        let workspace = NSWorkspace.shared

        do {
            if let screen = NSScreen.main {
                try workspace.setDesktopImageURL(path!, for: screen)
            }
        } catch {
            print("Unable to set desktop background")
        }
    }

    public func determineScreenSize() -> Void {
        if let screen = NSScreen.main {
            screenWidth = screen.frame.size.width
            screenHeight = screen.frame.size.height
        } else {
            print("Unable to determine screen size")
        }
    }

    private func saveAtSize(screenshot: NSImage, h: Int, w: Int) -> Void {
        let image = screenshot.resize(w: w, h: h)
        let fileName = "\(h)x\(w).png"

        if let png = image.png {
            do {
                try png.write(to: path!.appending(component: fileName))
                print("\(fileName) saved")
            } catch {
                print(error)
            }
        } else {
            print("No PNG data?")
        }
    }

    private func saveCurrentState(of: any View) -> NSImage? {
        let screenshot = of.snapshot()
        let generatorCode = Int.random(in: 99999...9999999)
        let exportFolder = "/Genevive/export-\(type)-\(generatorCode)/"
        let picturesDir = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!
        path = picturesDir
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

        return screenshot
    }
}
