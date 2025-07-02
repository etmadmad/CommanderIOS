import SwiftUI

var accentCustomColor: String = "#00FF33"
var darkColor: String = "#121212"
var white: String = "#ffffff"
var black: String = "#000000"
var grayDetails: String = "#747474"
var redError: String = "#ff0033"

var bombColor: String = "#EA33F7"
var swordsColor: String = "#75FBFD"
var skullColor: String = "#F19E39"

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
