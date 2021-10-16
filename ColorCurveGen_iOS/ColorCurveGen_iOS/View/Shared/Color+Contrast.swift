//
//  Color+Contrast.swift
//  ColorCurveGen_iOS
//
//  Created by Zoe Van Brunt on 10/16/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import SwiftUI

extension Color {
    
    var luminance: CGFloat? {
        guard let cgColor = cgColor else { return nil }
        let uiColor = UIColor(cgColor: cgColor)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return (0.2126 * red) + (0.7152 * green) + (0.0722 * blue)
    }
    
}
