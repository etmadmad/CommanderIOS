import SwiftUI

enum KodeMonoWeight: String {
    case regular = "KodeMono-Regular"
    case medium = "KodeMono-Medium"
    case bold = "KodeMono-Bold"
    case semibold = "KodeMono-SemiBold"
}

struct CustomTextModifier: ViewModifier {
    var weight: KodeMonoWeight
    var size: CGFloat
    var hexColor: String

    func body(content: Content) -> some View {
        content
            .font(.custom(weight.rawValue, size: size))
            .foregroundStyle(Color(hex: hexColor))
    }
}

extension View {
    func customFont(_ weight: KodeMonoWeight, size: CGFloat, hexColor: String) -> some View {
        self.modifier(CustomTextModifier(weight: weight, size: size, hexColor: hexColor))
    }
}


