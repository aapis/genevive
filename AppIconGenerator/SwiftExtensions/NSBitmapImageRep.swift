//
//  NSBitmapImageRep.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-17.
//

import SwiftUI

// THX SO
// https://stackoverflow.com/questions/29262624/nsimage-to-nsdata-as-png-swift
extension NSBitmapImageRep {
    var png: Data? { representation(using: .png, properties: [:]) }
}
