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
import UIKit

public class CustomTabBadge: UILabel {
    
    public init(font: UIFont = UIFont(name: "Helvetica-Light", size: 11) ?? UIFont()) {
        super.init(frame: .zero)
        
        self.font = font
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension UITabBarController {

    func setBadges(badgeValues: [Int], font: UIFont = UIFont(name: "Helvetica-Light", size: 11) ?? UIFont()) {

        for view in self.tabBar.subviews {
            if view is CustomTabBadge {
                view.removeFromSuperview()
            }
        }

        for index in 0...badgeValues.count-1 {
            if badgeValues[index] != 0 {
                addBadge(index: index,
                         value: badgeValues[index],
                         color: .red,
                         font: font)
            }
        }
    }

    func addBadge(index: Int, value: Int, color: UIColor, font: UIFont) {
        let badgeView = CustomTabBadge(font: font)

        badgeView.clipsToBounds = true
        badgeView.textColor = UIColor.white
        badgeView.textAlignment = .center
        badgeView.text = String(value)
        badgeView.backgroundColor = color
        badgeView.tag = index
        tabBar.addSubview(badgeView)

        self.positionBadges()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.positionBadges()
    }

    // Positioning
    func positionBadges() {

        var tabbarButtons = self.tabBar.subviews.filter { (view: UIView) -> Bool in
            return view.isUserInteractionEnabled // only UITabBarButton are userInteractionEnabled
        }

        tabbarButtons = tabbarButtons.sorted(by: { $0.frame.origin.x < $1.frame.origin.x })

        for view in self.tabBar.subviews {
            if view is CustomTabBadge {
                if let badgeView = view as? CustomTabBadge {
                    self.positionBadge(badgeView: badgeView, items: tabbarButtons, index: badgeView.tag)
                }
            }
        }
    }

    func positionBadge(badgeView: UIView, items: [UIView], index: Int) {

        let itemView = items[index]
        let center = itemView.center

        let xOffset: CGFloat = 10
        let yOffset: CGFloat = -14
        badgeView.frame.size = CGSize(width: 17, height: 17)
        badgeView.center = CGPoint(x: center.x + xOffset, y: center.y + yOffset)
        badgeView.layer.cornerRadius = badgeView.bounds.width/2
        tabBar.bringSubviewToFront(badgeView)
    }
    
    func setSelectedView(atIndex: Int, withAnimation: Bool = false, completion:(()->())?){
        if let navController = self.viewControllers![atIndex] as? UINavigationController {
            navController.popToRootViewController(animated: false)
        }
        if withAnimation {
            animateToTab(toIndex: atIndex)
        }else{
            self.selectedIndex = atIndex
        }
        completion?()
    }
    
    func setSelectedView(withNoPop atIndex: Int, withAnimation: Bool = false, completion:(()->())?) {
        //self.viewControllers?[atIndex].viewWillAppear(true)
        if withAnimation {
            animateToTab(toIndex: atIndex)
        }else{
            self.selectedIndex = atIndex
        }
        completion?()
    }
    
    func changeViewControllerToItem(withViewController: UIViewController, Item: Int){
        guard let navController = self.viewControllers?[Item] as? UINavigationController else{ return }
        navController.setViewControllers([withViewController], animated: true)
        self.setSelectedView(atIndex: Item, completion: nil)
    }
    
    func animateToTab(toIndex: Int) {
        let tabViewControllers = viewControllers!
        let fromView = selectedViewController!.view
        let toView = tabViewControllers[toIndex].view
        let fromIndex = self.selectedIndex //tabViewControllers.index(of: selectedViewController!)
        
        guard fromIndex != toIndex else {return}
        
        // Add the toView to the tab bar view
        fromView?.superview!.addSubview(toView!)
        
        // Position toView off screen (to the left/right of fromView)
        let screenWidth = UIScreen.main.bounds.size.width;
        let scrollRight = toIndex > fromIndex;
        let offset = (scrollRight ? screenWidth : -screenWidth)
        toView?.center = CGPoint(x: (fromView?.center.x)! + offset, y: (toView?.center.y)!)
        
        // Disable interaction during animation
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            // Slide the views by -offset
            fromView?.center = CGPoint(x: (fromView?.center.x)! - offset, y: (fromView?.center.y)!);
            toView?.center   = CGPoint(x: (toView?.center.x)! - offset, y: (toView?.center.y)!);
            
        }, completion: { finished in
            
            // Remove the old view from the tabbar view.
            fromView?.removeFromSuperview()
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        })
    }
}
#endif
