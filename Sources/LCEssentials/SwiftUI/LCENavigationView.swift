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
    @Published var rightButtonImage: Image? = nil
    @Published var rightButtonText: Text = Text("")
    @Published var rightButtonAction: () -> Void = {}
    
    @Published var leftButtonImage: Image? = nil
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
}

@available(iOS 15, *)
public extension LCENavigationView {
    
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
//            if let image = state.leftButtonImage {
//                image.foregroundColor(.loGrey)
//            }
            state.leftButtonText
        }
    }
    
    private var NavRightButton: some View {
        Button(action: state.rightButtonAction) {
//            if let image = state.rightButtonImage {
//                image.foregroundColor(.loGrey)
//            }
            state.rightButtonText
        }
    }
    
    func setRightButton(text: Text,
                        image: Image? = nil,
                        action: @escaping () -> Void) -> LCENavigationView {
        state.rightButtonImage = image
        state.rightButtonText = text
        state.rightButtonAction = action
        return self
    }
    
    func setLeftButton(text: Text,
                       image: Image? = nil,
                       action: @escaping () -> Void) -> LCENavigationView {
        state.leftButtonImage = image
        state.leftButtonText = text
        state.leftButtonAction = action
        return self
    }
    
    func setTitle(text: Text, subTitle: Text? = nil) -> LCENavigationView {
        state.title = text
        state.subTitle = subTitle
        return self
    }
    
    func hideNavigationView(_ hide: Bool) -> LCENavigationView {
        state.hideNavigationBar = hide
        return self
    }
}
#endif
