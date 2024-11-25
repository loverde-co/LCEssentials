//  
// Copyright (c) 2024 Loverde Co.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
#if canImport(SwiftUI)
import SwiftUI

@available(iOS 15, *)
class LCENavigationState: ObservableObject {
    @Published var rightButtonImage: AnyView? = nil
    @Published var rightButtonText: Text = Text("")
    @Published var rightButtonAction: () -> Void = {}
    
    @Published var leftButtonImage: AnyView? = nil
    @Published var leftButtonText: Text = Text("")
    @Published var leftButtonAction: () -> Void = {}
    
    @Published var hideNavigationBar: Bool = false
    
    @Published var title: Text = Text("")
    @Published var subTitle: Text? = nil
}

@available(iOS 15, *)
public struct LCENavigationView<Content: View>: View {
    @ObservedObject private var state: LCENavigationState
    
    let content: Content
    
    public init(
        title: Text = Text(""),
        subTitle: Text? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self._state = ObservedObject(
            wrappedValue: LCENavigationState()
        )
        self.state.title = title
        self.state.subTitle = subTitle
    }
    
    public var body: some View {
        VStack {
            if !state.hideNavigationBar {
                NavigationBarView
            }
            content
        }
        .navigationBarHidden(true)
    }

    private var NavigationBarView: some View {
        HStack {
            NavLeftButton
            Spacer()
            TitleView
            Spacer()
            NavRightButton
        }
        .font(.headline)
        .padding()
        .background {
            Color.clear.ignoresSafeArea(edges: .top)
        }
    }
    
    private var TitleView: some View {
        VStack {
            state.title
            if let subTitle = state.subTitle {
                subTitle
            }
        }
    }
    
    private var NavLeftButton: some View {
        Button(action: state.leftButtonAction) {
            HStack {
                if let image = state.leftButtonImage {
                    image
                }
                state.leftButtonText
            }
        }
    }
    
    private var NavRightButton: some View {
        Button(action: state.rightButtonAction) {
            HStack {
                state.rightButtonText
                if let image = state.rightButtonImage {
                    image
                }
            }
        }
    }
    
    public func setRightButton(
        text: String,
        color: Color = .primary,
        image: (any View)? = nil,
        action: @escaping () -> Void
    ) -> LCENavigationView {
        if let image {
            state.rightButtonImage = AnyView(image)
        } else {
            state.rightButtonImage = nil
        }
        state.rightButtonText = Text(text).foregroundColor(color)
        state.rightButtonAction = action
        
        if let string = state.leftButtonText.string, string.isEmpty {
            state.leftButtonText = Text(text).foregroundColor(.clear)
        }
        if state.leftButtonImage == nil {
            state.leftButtonImage = image?.foregroundColor(.clear) as? AnyView
        }
        
        return self
    }
    
    public func setLeftButton(
        text: String,
        color: Color = .primary,
        image: (any View)? = nil,
        action: @escaping () -> Void
    ) -> LCENavigationView {
        if let image {
            state.leftButtonImage = AnyView(image)
        } else {
            state.leftButtonImage = nil
        }
        state.leftButtonText = Text(text).foregroundColor(color)
        state.leftButtonAction = action
        
        if let string = state.rightButtonText.string, string.isEmpty {
            state.rightButtonText = Text(text).foregroundColor(.clear)
        }
        if state.rightButtonImage == nil {
            state.rightButtonImage = image?.foregroundColor(.clear) as? AnyView
        }
        
        return self
    }
    
    public func setTitle(
        text: Text,
        subTitle: Text? = nil
    ) -> LCENavigationView {
        state.title = text
        state.subTitle = subTitle
        return self
    }
    
    public func hideNavigationView(_ hide: Bool) -> LCENavigationView {
        state.hideNavigationBar = hide
        return self
    }
}

@available(iOS 15.0, *)
extension FormatStyle {
    func format(any value: Any) -> FormatOutput? {
        if let v = value as? FormatInput {
            return format(v)
        }
        return nil
    }
}

@available(iOS 15.0, *)
extension LocalizedStringKey {
    var resolved: String? {
        let mirror = Mirror(reflecting: self)
        guard let key = mirror.descendant("key") as? String else {
            return nil
        }

        guard let args = mirror.descendant("arguments") as? [Any] else {
            return nil
        }

        let values = args.map { arg -> Any? in
            let mirror = Mirror(reflecting: arg)
            if let value = mirror.descendant("storage", "value", ".0") {
                return value
            }

            guard let format = mirror.descendant("storage", "formatStyleValue", "format") as? any FormatStyle,
                  let input = mirror.descendant("storage", "formatStyleValue", "input") else {
                return nil
            }

            return format.format(any: input)
        }

        let va = values.compactMap { arg -> CVarArg? in
            switch arg {
            case let i as Int:      return i
            case let i as Int64:    return i
            case let i as Int8:     return i
            case let i as Int16:    return i
            case let i as Int32:    return i
            case let u as UInt:     return u
            case let u as UInt64:   return u
            case let u as UInt8:    return u
            case let u as UInt16:   return u
            case let u as UInt32:   return u
            case let f as Float:    return f
            case let f as CGFloat:  return f
            case let d as Double:   return d
            case let o as NSObject: return o
            default:                return nil
            }
        }

        if va.count != values.count {
            return nil
        }

        return String.localizedStringWithFormat(key, va)
    }
}

@available(iOS 15.0, *)
extension Text {
    var string: String? {
        let mirror = Mirror(reflecting: self)
        if let s = mirror.descendant("storage", "verbatim") as? String {
            return s
        } else if let attrStr = mirror.descendant("storage", "anyTextStorage", "str") as? AttributedString {
            return String(attrStr.characters)
        } else if let key = mirror.descendant("storage", "anyTextStorage", "key") as? LocalizedStringKey {
            return key.resolved
        } else if let format = mirror.descendant("storage", "anyTextStorage", "storage", "format") as? any FormatStyle,
                  let input = mirror.descendant("storage", "anyTextStorage", "storage", "input") {
            return format.format(any: input) as? String
        } else if let formatter = mirror.descendant("storage", "anyTextStorage", "formatter") as? Formatter,
                  let object = mirror.descendant("storage", "anyTextStorage", "object") {
            return formatter.string(for: object)
        }
        return nil
    }
}

//@available(iOS 15.0, *)
//struct LCENavigationView_Previews: PreviewProvider {
//    static var previews: some View {
//        LCENavigationView {
//            Text("Hello, World!")
//        }
//        .setTitle(text: Text("Hellow Nav Title"))
//        .setLeftButton(text: "Back") {
//            print("Button tapped!")
//        }
//    }
//}

#endif
