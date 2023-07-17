//
//  NSImage.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-17.
//

import SwiftUI

// THX SO
// https://stackoverflow.com/questions/29262624/nsimage-to-nsdata-as-png-swift
extension NSImage {
    var png: Data? { tiffRepresentation?.bitmap?.png }

    // https://stackoverflow.com/a/55498562
    func rotated(by angle: CGFloat) -> NSImage {
        let img = NSImage(size: self.size, flipped: false, drawingHandler: { (rect) -> Bool in
            let (width, height) = (rect.size.width, rect.size.height)
            let transform = NSAffineTransform()
            transform.translateX(by: width / 2, yBy: height / 2)
            transform.rotate(byDegrees: angle)
            transform.translateX(by: -width / 2, yBy: -height / 2)
            transform.concat()
            self.draw(in: rect)
            return true
        })
        img.isTemplate = self.isTemplate // preserve the underlying image's template setting
        return img
    }

    // https://stackoverflow.com/a/36004876
    func resize(w: Int, h: Int) -> NSImage {
        let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
        let newImage = NSImage(size: destSize)
        newImage.lockFocus()
        self.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, self.size.width, self.size.height), operation: .copy, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize
        return newImage
    }
}
