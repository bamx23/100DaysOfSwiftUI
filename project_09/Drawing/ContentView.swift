//
//  ContentView.swift
//  Drawing
//
//  Created by Nikolay Volosatov on 11/7/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: .init(x: rect.midX, y: rect.minY))
        path.addLine(to: .init(x: rect.minX, y: rect.maxY))
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        path.addLine(to: .init(x: rect.midX, y: rect.minY))

        return path
    }
}

struct Arc: InsettableShape {
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool

    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        var path = Path()
        path.addArc(center: .init(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2 - insetAmount,
                    startAngle: startAngle - rotationAdjustment,
                    endAngle: endAngle - rotationAdjustment,
                    clockwise: clockwise)
        return path
    }

    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

struct Flower: Shape {
    var petalOffset: Double = -20
    var petalWidth: Double = 100

    func path(in rect: CGRect) -> Path {
        var path = Path()

        for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8) {
            let rotation = CGAffineTransform(rotationAngle: number)
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset),
                                                        y: 0,
                                                        width: CGFloat(petalWidth),
                                                        height: rect.width / 2))
            let rotatedPetal = originalPetal.applying(position)
            path.addPath(rotatedPetal)
        }

        return path
    }
}

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        if targetHue > 1 {
            targetHue -= 1
        }
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                .inset(by: CGFloat(value))
                    //.strokeBorder(self.color(for: value, brightness: 1), lineWidth: 2)
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)
                    ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
        .drawingGroup()
    }
}

struct AppMetricaLogo: View {
    var value: CGFloat = 1.0

    var body: some View {
        let red = Color(red: 254.0 / 255.0, green: 0.0 / 255.0, blue: 2.0 / 255.0)
        let yellow = Color(red: 255.0 / 255.0, green: 203.0 / 255.0, blue: 0.0 / 255.0)
        let blue = Color(red: 59.0 / 255.0, green: 169.0 / 255.0, blue: 255.0 / 255.0)
        let purple = Color(red: 71.0 / 255.0, green: 66.0 / 255.0, blue: 184.0 / 255.0)

        let triangle = Triangle()
            .frame(width: 350 * value, height: 300)
            .offset(.init(width: 0, height: 100 - value * 100 + 50))
        let topRectangle = Rectangle()
            .frame(width: 500, height: 300)

            .offset(.init(width: 0, height: -150))
        .rotationEffect(.degrees(90 - 90 * Double(value)))

        let bottomRectangle = Rectangle()
            .frame(width: 500, height: 300)

            .offset(.init(width: 0, height: 150))
        .rotationEffect(.degrees(90 - 90 * Double(value)))

        return ZStack {
            topRectangle
                .foregroundColor(yellow)
            triangle
                .foregroundColor(red)
            ZStack {
                bottomRectangle
                    .foregroundColor(blue)
                triangle
                    .foregroundColor(purple)
                topRectangle
                    .blendMode(.destinationOut)
            }
            .drawingGroup()
        }
        .clipShape(Circle())
    }
}

struct ContentView: View {
    @State private var amount: CGFloat = 0.0
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 200 * amount)
                    .offset(x: -50, y: -80)
                    .blendMode(.screen)

                Circle()
                    .fill(Color.green)
                    .frame(width: 200 * amount)
                    .offset(x: 50, y: -80)
                    .blendMode(.screen)

                Circle()
                    .fill(Color.blue)
                    .frame(width: 200 * amount)
                    .blendMode(.screen)
            }
            .frame(width: 300, height: 300)

            Slider(value: $amount)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
