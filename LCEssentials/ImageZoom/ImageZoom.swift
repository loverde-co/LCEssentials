//  
// Copyright (c) 2020 Loverde Co.
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
 
import UIKit

#if os(iOS) || os(macOS)
@objc public protocol ImageZoomControllerDelegate {
    @objc optional func imageZoomController(controller: ImageZoomController, didZoom image: UIImage?)
    @objc optional func imageZoomController(controller: ImageZoomController, didClose image: UIImage?)
}

 public class ImageZoomController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    public var setImage: UIImage!
    public var addGestureToDismiss: Bool = true
    public var delegate : ImageZoomControllerDelegate?
    
    private var minimumVelocityToHide: CGFloat = 1500
    private var minimumScreenRatioToHide: CGFloat = 0.5
    private var animationDuration: TimeInterval = 0.2
     
    override public func viewDidLoad() {
         super.viewDidLoad()
         self.setupView()
     }

    private func setupView(){
        self.img.image = setImage
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        if addGestureToDismiss {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
            view.addGestureRecognizer(panGesture)
        }
    }
    
    static public func instantiate() -> ImageZoomController {
        let instance: ImageZoomController = ImageZoomController.instantiate(storyBoard: "ImageZoomController", identifier: ImageZoomController.identifier)
        instance.loadView()
        return instance
    }
    
    private func scrollViewDidZoom(_ scrollView: UIScrollView) {
        delegate?.imageZoomController?(controller: self, didZoom: self.setImage)
    }
     
     @IBAction private func close(){
        delegate?.imageZoomController?(controller: self, didClose: self.setImage)
         self.dismiss(animated: true) {
         }
     }
     
    private func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.img
    }

    private func slideViewVerticallyTo(_ y: CGFloat) {
        self.view.frame.origin = CGPoint(x: 0, y: y)
    }

    @objc private func onPan(_ panGesture: UIPanGestureRecognizer) {

        switch panGesture.state {
            case .began, .changed:
                // If pan started or is ongoing then
                // slide the view to follow the finger
                let translation = panGesture.translation(in: view)
                let y = max(0, translation.y)
                slideViewVerticallyTo(y)

            case .ended:
                // If pan ended, decide it we should close or reset the view
                // based on the final position and the speed of the gesture
                let translation = panGesture.translation(in: view)
                let velocity = panGesture.velocity(in: view)
                let closing = (translation.y > self.view.frame.size.height * minimumScreenRatioToHide) || (velocity.y > minimumVelocityToHide)
                if closing {
                    UIView.animate(withDuration: animationDuration, animations: {
                        // If closing, animate to the bottom of the view
                        self.slideViewVerticallyTo(self.view.frame.size.height)
                    }, completion: { (isCompleted) in
                        if isCompleted {
                            // Dismiss the view when it dissapeared
                            self.dismiss(animated: false, completion: nil)
                        }
                    })
                } else {
                    // If not closing, reset the view to the top
                    UIView.animate(withDuration: animationDuration, animations: {
                        self.slideViewVerticallyTo(0)
                    })
                }

            default:
                // If gesture state is undefined, reset the view to the top
                UIView.animate(withDuration: animationDuration, animations: {
                    self.slideViewVerticallyTo(0)
                })
        }
    }
}
#endif
