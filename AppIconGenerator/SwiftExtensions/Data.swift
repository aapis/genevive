//
//  Data.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-17.
//

import SwiftUI

extension Data {
    var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
}
