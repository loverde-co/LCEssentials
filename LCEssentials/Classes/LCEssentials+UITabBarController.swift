//  
// Copyright (c) 2018 Loverde Co.
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
 

import Foundation
#if os(iOS) || os(macOS)
extension UITabBarController {

    public func setBadges(badgeValues: [Int]) {

        for view in self.tabBar.subviews {
            if view is CustomTabBadge {
                view.removeFromSuperview()
            }
        }

        for index in 0...badgeValues.count-1 {
            if badgeValues[index] != 0 {
                addBadge(index: index, value: badgeValues[index], color: .red, font: UIFont(name: "Helvetica-Light", size: 11)!)
            }
        }
    }

    public func addBadge(index: Int, value: Int, color: UIColor, font: UIFont) {
        let badgeView = CustomTabBadge()

        badgeView.clipsToBounds = true
        badgeView.textColor = UIColor.white
        badgeView.textAlignment = .center
        badgeView.font = font
        badgeView.text = String(value)
        badgeView.backgroundColor = color
        badgeView.tag = index
        tabBar.addSubview(badgeView)

        self.positionBadges()
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.positionBadges()
    }

    // Positioning
    public func positionBadges() {

        var tabbarButtons = self.tabBar.subviews.filter { (view: UIView) -> Bool in
            return view.isUserInteractionEnabled // only UITabBarButton are userInteractionEnabled
        }

        tabbarButtons = tabbarButtons.sorted(by: { $0.frame.origin.x < $1.frame.origin.x })

        for view in self.tabBar.subviews {
            if view is CustomTabBadge {
                let badgeView = view as! CustomTabBadge
                self.positionBadge(badgeView: badgeView, items:tabbarButtons, index: badgeView.tag)
            }
        }
    }

    public func positionBadge(badgeView: UIView, items: [UIView], index: Int) {

        let itemView = items[index]
        let center = itemView.center

        let xOffset: CGFloat = 10
        let yOffset: CGFloat = -14
        badgeView.frame.size = CGSize(width: 17, height: 17)
        badgeView.center = CGPoint(x: center.x + xOffset, y: center.y + yOffset)
        badgeView.layer.cornerRadius = badgeView.bounds.width/2
        tabBar.bringSubview(toFront: badgeView)
    }
}
#endif
