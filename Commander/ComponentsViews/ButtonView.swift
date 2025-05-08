import SwiftUI

enum TypeBtn {
    case primary
    case secondary
    case tertiary
}

struct ButtonView: ViewModifier {
    var typeBtn: TypeBtn
    
    var textBtn: String
    var icon: String
    var width: CGFloat? = nil
    var height: CGFloat? = 50
    var fontSizeBtn: CGFloat = 18
    var cornerRadius: CGFloat = 10
    var colorHex: String
    
    
    var backgroundColor: Color {
        switch typeBtn {
        case .primary:
            return Color(hex: darkColor)
        case .secondary:
            return Color.gray.opacity(0.2)
        case .tertiary:
            return Color.clear
        }
    }
    
    var textColor: Color {
        switch typeBtn {
        case .primary:
            return .white
        case .secondary:
            return .black
        case .tertiary:
            return .blue
        }
    }

    func body(content: Content) -> some View {
        Button(action: {
            print("click")
        }) {
            HStack {
                if !icon.isEmpty {
                    Image(systemName: icon)
                }
                Text(textBtn)
                    .font(.custom("KodeMono-Regular", size: fontSizeBtn))
                    .foregroundColor(textColor)
            }
            .frame(width: width, height: height)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
        }
    }
}

extension View {
    func customButton(
        typeBtn: TypeBtn,
        textBtn: String,
        icon: String,
        width: CGFloat,
        height: CGFloat,
        fontSizeBtn: CGFloat,
        cornerRadius: CGFloat,
        colorHex: String
    ) -> some View {
        self.modifier(ButtonView(
            typeBtn: typeBtn,
            textBtn: textBtn,
            icon: icon,
            width: width,
            height: height,
            fontSizeBtn: fontSizeBtn,
            cornerRadius: cornerRadius,
            colorHex: colorHex
        ))
    }
}
