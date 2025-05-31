import SwiftUI

// removed colorHex


enum TypeBtn {
    case primary
    case secondary
    case tertiary
}

struct ButtonView: ViewModifier {
    var typeBtn: TypeBtn
    
   // var textBtn: String
  //  var icon: String
    var width: CGFloat? = nil
    var height: CGFloat? = 50
 //   var fontSizeBtn: CGFloat = 18
    var cornerRadius: CGFloat = 10
    
    
    var backgroundColor: Color {
        switch typeBtn {
        case .primary:
            return Color(hex: accentCustomColor)
        case .secondary:
            return Color.white
        case .tertiary:
            return Color.clear
        }
    }
    
    var textColor: Color {
        switch typeBtn {
        case .primary:
            return .black
        case .secondary:
            return .black
        case .tertiary:
            return .white
        }
    }

    var borderColor: Color? {
        switch typeBtn {
        case .tertiary:
            return Color(hex: white)
        default:
            return nil
        }
    }
    func body(content: Content) -> some View {
            content
                .frame(width: width, height: height)
                .background(backgroundColor)
                .foregroundColor(textColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor ?? .clear, lineWidth: 1.5)
                )
                .cornerRadius(cornerRadius)
                .contentShape(Rectangle())
    }
}

extension View {
    func customButton(
        typeBtn: TypeBtn,
     //   textBtn: String,
      //  icon: String,
        width: CGFloat,
        height: CGFloat,
      //  fontSizeBtn: CGFloat,
        cornerRadius: CGFloat
        
    ) -> some View {
        self.modifier(ButtonView(
            typeBtn: typeBtn,
          //  textBtn: textBtn,
           // icon: icon,
            width: width,
            height: height,
          //  fontSizeBtn: fontSizeBtn,
            cornerRadius: cornerRadius
            
        ))
    }
}
