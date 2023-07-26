//
//  MinimizedInterface.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-18.
//

import Foundation
import SwiftUI

struct MinimizedInterface: View {
    @Binding public var colours: [Color]
    @Binding public var uiVisible: Bool

    @EnvironmentObject private var storage: Storage
    
    var body: some View {
        VStack {
            HStack(spacing: 1) {
                Spacer()

                maximize
                refresh
                save
                setAsWallpaper
            }
//                            LayerNavigator(layers: $layers)
        }
        .padding()
    }

    private var maximize: some View {
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
            .help("Show all configuration options")
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

    private var refresh: some View {
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
            .help("Randomize colours")
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

    private var save: some View {
        Button {
            storage.saveScreenshot()
        } label: {
            ZStack {
                Color.orange
                    .shadow(color: .black.opacity(0.3), radius: 0, x: 10, y: 10)
                Image(systemName: "arrow.down.to.line.circle")
                    .font(.largeTitle)
                    .symbolRenderingMode(.hierarchical)
            }
            .frame(width: 50, height: 50)
            .help("Save to ~/Pictures/Genevive")
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

    @ViewBuilder private var setAsWallpaper: some View {
        if storage.type == .wallpaper {
            Button {
                storage.setAsWallpaper()
            } label: {
                ZStack {
                    Color.indigo
                        .shadow(color: .black.opacity(0.3), radius: 0, x: 10, y: 10)
                    Image(systemName: "desktopcomputer.and.arrow.down")
                        .font(.largeTitle)
                        .symbolRenderingMode(.hierarchical)
                }
                .frame(width: 50, height: 50)
                .help("Set as desktop wallpaper")
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
