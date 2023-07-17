//
//  LayerNavigator.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-17.
//

import SwiftUI

struct LayerNavigator: View {
    @Binding public var layers: [any IconLayer]

    var body: some View {
        ForEach(layers, id: \(any IconLayer).id) { layer in
            layer.toggleUi
            
        }
    }
}
