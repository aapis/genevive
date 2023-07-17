//
//  ContentView.swift
//  AppIconGenerator
//
//  Created by Ryan Priebe on 2023-07-15.
//

import SwiftUI

public protocol IconLayer: Identifiable {
    var id: UUID {get set}
    var startPoint: UnitPoint {get set}
    var endPoint: UnitPoint {get set}
    var fill: LinearGradient {get set}
    var rotation: Double {get set}
    var positionX: CGFloat {get set}
    var positionY: CGFloat {get set}
    var opacity: CGFloat {get set}
    var mask: AnyView? {get set}

    mutating func randomize() -> Void
}

public struct GradientLayer: IconLayer {
    public var id: UUID = UUID()
    public var startPoint: UnitPoint
    public var endPoint: UnitPoint
    public var fill: LinearGradient
    public var rotation: Double = Double.random(in: 1...1000)
    public var positionX: CGFloat = CGFloat.random(in: 1...1000)
    public var positionY: CGFloat = CGFloat.random(in: 1...1000)
    public var opacity: CGFloat = CGFloat.random(in: 0.1...1)
    public var mask: AnyView?

    public init(colours: [Color]) {
        self.startPoint = .top
        self.endPoint = .bottom
        self.fill = LinearGradient(gradient: Gradient(colors: colours), startPoint: self.startPoint, endPoint: self.endPoint)
    }

    mutating public func randomize() -> Void {
        let points = [UnitPoint.top, UnitPoint.bottom, UnitPoint.leading, UnitPoint.trailing]

        startPoint = points.randomElement()!
        endPoint = points.randomElement()!
        
        rotation = Double.random(in: 1...1000)
        positionX = CGFloat.random(in: 1...1000)
        positionY = CGFloat.random(in: 1...1000)
        opacity = CGFloat.random(in: 0.1...1)

        let shapes: [any View] = [Circle(), Rectangle(), Ellipse(), Capsule()]
        let shape = shapes.randomElement()!
            .frame(width: CGFloat.random(in: 100...1024), height: CGFloat.random(in: 100...1024))
            .position(x: positionX, y: positionY)

        mask = AnyView(shape)
    }
}

public struct SolidLayer: IconLayer {
    public var id: UUID = UUID()
    public var startPoint: UnitPoint
    public var endPoint: UnitPoint
    public var fill: LinearGradient
    public var rotation: Double = Double.random(in: 1...1000)
    public var positionX: CGFloat = CGFloat.random(in: 1...1000)
    public var positionY: CGFloat = CGFloat.random(in: 1...1000)
    public var opacity: CGFloat = CGFloat.random(in: 0.1...1)
    public var mask: AnyView?

    public init(colours: [Color]) {
        self.startPoint = .top
        self.endPoint = .bottom
        self.fill = LinearGradient(gradient: Gradient(colors: [colours.first!]), startPoint: self.startPoint, endPoint: self.endPoint)
    }

    mutating public func randomize() -> Void {
        let points = [UnitPoint.top, UnitPoint.bottom, UnitPoint.leading, UnitPoint.trailing]

        startPoint = points.randomElement()!
        endPoint = points.randomElement()!

        rotation = Double.random(in: 1...1000)
        positionX = CGFloat.random(in: 1...1000)
        positionY = CGFloat.random(in: 1...1000)
        opacity = CGFloat.random(in: 0.1...1)

        let shapes: [any View] = [Circle(), Rectangle(), Ellipse(), Capsule()]
        let shape = shapes.randomElement()!
            .frame(width: CGFloat.random(in: 100...1024), height: CGFloat.random(in: 100...1024))
            .position(x: positionX, y: positionY)

        mask = AnyView(shape)
    }
}

public struct BackgroundColour {
    @Binding public var use: Int
    @Binding public var set: [Color]

    public func render() -> Color {
        if use == 0 {
            return set.first!
        } else if use == 1 {
            return Color.white
        }

        return Color.black
    }
}

struct ContentView: View {
    @Binding public var colours: [Color]
    @Binding public var gradientLayers: [any IconLayer]
    @Binding public var startPoint: UnitPoint
    @Binding public var endPoint: UnitPoint
    @Binding public var numberOfLayers: Float
    @Binding public var maskCornerRoundness: Float
    @Binding public var constrained: Bool
    @Binding public var backgroundColour: Int
    @Binding public var shapeFillType: Int
    @Binding public var sfsAppIcon: String

    var body: some View {
        VStack {
            ZStack {
                BackgroundColour(use: $backgroundColour, set: $colours).render()

                ForEach(gradientLayers, id: \(any IconLayer).id) { layer in
                    layer.fill
                        .rotationEffect(.degrees(layer.rotation))
                        .position(x: layer.positionX, y: layer.positionY)
                        .opacity(layer.opacity)
                        .mask {
                            layer.mask
                        }
                }

                if !sfsAppIcon.isEmpty {
                    Image(systemName: sfsAppIcon)
                        .font(.system(size: 700))
                        .opacity(0.8)
                        .foregroundColor(colours.first!.isBright() ? Color.black : Color.white)
                        .symbolRenderingMode(.hierarchical)
                }
            }
            .mask(
                constrained ?
                ZStack {
                    RoundedRectangle(cornerRadius: CGFloat(maskCornerRoundness))
                        .frame(width: 1016, height: 1016)
                }
                : nil
            )
        }
        .shadow(color: .black.opacity(0.3), radius: 8, x: 10, y: -10)
        .frame(width: 1124, height: 1124)
        .onAppear(perform: updateLayers)
        .onChange(of: numberOfLayers) { _ in
            updateLayers()
        }
    }

    private func updateLayers() -> Void {
        for _ in 0...Int(numberOfLayers) {
            var layer: any IconLayer = shapeFillType == 0 ? GradientLayer(colours: colours) : SolidLayer(colours: colours)
            layer.randomize()

            if gradientLayers.count > Int(numberOfLayers) {
                gradientLayers.removeAll()
            } else {
                gradientLayers.append(layer)
            }
        }
    }
}

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

// THX SO
// https://stackoverflow.com/questions/29262624/nsimage-to-nsdata-as-png-swift
extension NSBitmapImageRep {
    var png: Data? { representation(using: .png, properties: [:]) }
}
extension Data {
    var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
}
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

// THIS ONE IS ME
extension Color {
    static func random() -> Color {
        return Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
    }

    public func isBright() -> Bool {
        guard let components = cgColor?.components, components.count > 2 else {return false}
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return (brightness > 0.5)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    @State public var showUi: Bool = true
//    static var previews: some View {
//        ContentView(showUi: $showUi)
//    }
//}
