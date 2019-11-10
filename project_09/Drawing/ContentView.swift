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

struct Trapezoid: Shape {
    var insetAmount: CGFloat
    var scale: CGFloat

    var animatableData: AnimatablePair<Double, Double> {
        get { .init(Double(insetAmount), Double(scale)) }
        set {
            self.insetAmount = CGFloat(newValue.first)
            self.scale = CGFloat(newValue.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))

        path = path.applying(CGAffineTransform(scaleX: scale, y: scale))

        return path
    }
}

struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    var amount: CGFloat

    var animatableData: CGFloat {
        get { amount }
        set { self.amount = newValue }
    }

    static private func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b

        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }

        return a
    }

    func path(in rect: CGRect) -> Path {
        let divisor = Self.gcd(innerRadius, outerRadius)
        let outerRadius = CGFloat(self.outerRadius)
        let innerRadius = CGFloat(self.innerRadius)
        let distance = CGFloat(self.distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * CGFloat.pi * outerRadius / CGFloat(divisor)) * amount

        var path = Path()

        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)

            x += rect.width / 2
            y += rect.height / 2

            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path
    }
}

struct Arrow: InsettableShape {
    var headHeightFactor: CGFloat = 0.3
    var tailWidthFactor: CGFloat = 0.4

    var inset: CGFloat = 0

    func inset(by amount: CGFloat) -> Arrow {
        var shape = self
        shape.inset = amount
        return shape
    }

    func path(in originalRect: CGRect) -> Path {
        var path = Path()
        let rect = CGRect(x: originalRect.minX + inset, y: originalRect.minY + inset,
                          width: originalRect.width - inset * 2, height: originalRect.height - inset * 2)

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        let points = [
            (0, headHeightFactor),
            (0.5 - tailWidthFactor / 2, headHeightFactor),
            (0.5 - tailWidthFactor / 2, 1),
            (0.5 + tailWidthFactor / 2, 1),
            (0.5 + tailWidthFactor / 2, headHeightFactor),
            (1.0, headHeightFactor),
            (0.5, 0),
            (0, headHeightFactor), // Additional point
        ]
        for point in points {
            path.addLine(to: CGPoint(x: rect.minX + point.0 * rect.width,
                                     y: rect.minY + point.1 * rect.height))
        }
        return path
    }
}

struct ColorCyclingRectangle: View {
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
                Rectangle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)
                    ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
        .drawingGroup()
    }
}

struct ContentView: View {
    static let strokeSizes: [CGFloat] = [1,3,5,10,20]

    @State private var headHeightFactor: CGFloat = 0.3
    @State private var tailWidthFactor: CGFloat = 0.4
    @State private var strokeSize: CGFloat = 10.0

    @State private var color = 0.0

    @State private var animationAmount = 0.0

    var body: some View {
        TabView {
            VStack {
                Arrow(headHeightFactor: headHeightFactor, tailWidthFactor: tailWidthFactor)
                    .stroke(lineWidth: strokeSize)
                    .frame(width: 100, height: 300)
                    .foregroundColor(.yellow)
                    .animation(.interpolatingSpring(stiffness: 5, damping: 1))
                    .padding()
                Form {
                    Section(header: Text("Head Height")) {
                        Slider(value: $headHeightFactor)
                    }
                    Section(header: Text("Tail Width")) {
                        Slider(value: $tailWidthFactor)
                    }
                    Section(header: Text("Stroke Size")) {
                        Picker("Stroke Size", selection: $strokeSize) {
                            ForEach(Self.strokeSizes, id: \.self) { value in
                                Text("\(Int(value))")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
            .tabItem({ Text("Arrow") })

            VStack {
                ColorCyclingRectangle(amount: color)
                    .frame(width: 300, height: 300)
                    .padding()
                Form {
                    Section(header: Text("Color Hue")) {
                        Slider(value: $color)
                    }
                }
            }
            .tabItem({ Text("ColorCyclingRectangle") })

            AppMetricaLogo(value: CGFloat(animationAmount))
                .frame(width: 400, height: 400)
                .onTapGesture {
                    withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                        self.animationAmount += 1.0
                        if self.animationAmount >= 2.0 {
                            self.animationAmount = 0.0
                        }
                    }
            }
            .tabItem({ Text("AppMetrica") })
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
