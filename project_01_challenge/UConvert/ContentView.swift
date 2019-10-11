//
//  ContentView.swift
//  UConvert
//
//  Created by Nikolay Volosatov on 10/11/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

enum LengthUnit: Int {
    case millimeter
    case centimeter
    case meter
    case kilometer

    case inch
    case foot
    case yard
    case mile
}

extension LengthUnit {
    var normalizedValue: Double {
        switch self {
        case .millimeter:
            return 0.001
        case .centimeter:
            return 0.01
        case .meter:
            return 1.0
        case .kilometer:
            return 1000.0

        case .inch:
            return 25.4 * LengthUnit.millimeter.normalizedValue
        case .foot:
            return 12.0 * LengthUnit.inch.normalizedValue
        case .yard:
            return 3.0 * LengthUnit.foot.normalizedValue
        case .mile:
            return 5280 * LengthUnit.foot.normalizedValue
        }
    }

    var pluralTitle: String {
        switch self {
        case .millimeter:
            return "Millimeters"
        case .centimeter:
            return "Centimeters"
        case .meter:
            return "Meters"
        case .kilometer:
            return "Kilometers"

        case .inch:
            return "Inches"
        case .foot:
            return "Feet"
        case .yard:
            return "Yards"
        case .mile:
            return "Miles"
        }
    }
}

struct UnitPicker: View {
    let title: String
    let units: [LengthUnit]
    let value: Binding<Int>

    var body: some View {
        Picker(title, selection: value) {
            ForEach(0..<units.count) {
                Text(self.units[$0].pluralTitle)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
}

struct ContentView: View {
    @State private var sourceIndex = 2
    @State private var targetIndex = 3
    @State private var sourceValue = ""
    @State var sourceGroup = 0

    var targetGroup: Int {
        (sourceGroup + 1) % 2
    }

    var sourceUnits: [LengthUnit] {
        (0..<4).map{ LengthUnit(rawValue: $0 + self.sourceGroup * 4)! }
    }
    var targetUnits: [LengthUnit] {
        (0..<4).map{ LengthUnit(rawValue: $0 + self.targetGroup * 4)! }
    }

    func swapUnits() {
        swap(&sourceIndex, &targetIndex)
        sourceGroup = targetGroup
    }

    var targetValue: Double {
        (Double(sourceValue) ?? 0.0)
            * sourceUnits[sourceIndex].normalizedValue
            / targetUnits[targetIndex].normalizedValue
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Source value", text: $sourceValue)
                    UnitPicker(title: "Source units", units: sourceUnits, value: $sourceIndex)
                    Button(action: swapUnits) {
                        HStack {
                            Text("swap")
                        }.frame(maxWidth: .infinity)
                    }
                    UnitPicker(title: "Target units", units: targetUnits, value: $targetIndex)
                }
                Section(header: Text("Result")) {
                    Text("\(targetValue, specifier: "%.4f") \(targetUnits[targetIndex].pluralTitle)")
                }
            }
            .navigationBarTitle("UConvert")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
