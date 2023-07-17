//
//  View.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-17.
//

import SwiftUI

// THX SO
// https://stackoverflow.com/a/68988631
extension View {
    func snapshot() -> NSImage? {
        let controller = NSHostingController(rootView: self)
        let targetSize = controller.view.intrinsicContentSize
        let contentRect = NSRect(origin: .zero, size: targetSize)

        let window = NSWindow(
            contentRect: contentRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.contentView = controller.view

        guard
            let bitmapRep = controller.view.bitmapImageRepForCachingDisplay(in: contentRect)
        else { return nil }

        controller.view.cacheDisplay(in: contentRect, to: bitmapRep)
        controller.view.layer?.shouldRasterize = true
        let image = NSImage(size: bitmapRep.size)
        image.addRepresentation(bitmapRep)
        return image
    }
}
