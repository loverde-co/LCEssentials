//  
// Copyright (c) 2023 Loverde Co.
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

public class ImageZoomController: UIViewController {
    
    fileprivate lazy var blackView: UIView = {
        $0.isOpaque = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.black
        $0.alpha = 0.8
        return $0
    }(UIView())
    
    fileprivate lazy var scrollView: UIScrollView = {
        $0.isOpaque = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        return $0
    }(UIScrollView())
    
    fileprivate lazy var closeButton: UIButton = {
        $0.isOpaque = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            $0.setImage(UIImage(systemName: "xmark"), for: .normal)
            $0.tintColor = UIColor.white
        }
        $0.setWidth(size: 50.0)
        $0.setHeight(size: 50.0)
        $0.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return $0
    }(UIButton(type: .custom))
    
    lazy var imageView: UIImageView = {
        $0.isOpaque = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())
    
    public var minimumZoomScale: CGFloat = 1.0
    public var maximumZoomScale: CGFloat = 6.0
    public var addGestureToDismiss: Bool = true
    public weak var delegate: ImageZoomControllerDelegate?

    private var minimumVelocityToHide: CGFloat = 1500
    private var minimumScreenRatioToHide: CGFloat = 0.5
    private var animationDuration: TimeInterval = 0.2

    
    public init(_ withImage: UIImage) {
        super.init(nibName: nil, bundle: nil)
        
        self.addComponentsAndConstraints()
        
        self.imageView.image = withImage
        self.imageView.addAspectRatioConstraint()
        
        self.scrollView.minimumZoomScale = self.minimumZoomScale
        self.scrollView.maximumZoomScale = self.maximumZoomScale
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if addGestureToDismiss {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
            view.addGestureRecognizer(panGesture)
        }
    }
    
    fileprivate func addComponentsAndConstraints() {
        
        scrollView.addSubview(imageView, translatesAutoresizingMaskIntoConstraints: false)
        view.addSubviews([blackView, scrollView, closeButton])
        
        blackView
            .setConstraintsTo(view, .all, 0, true)
        
        scrollView
            .setConstraintsTo(view, .all, 0, true)
        
        imageView.setHeight(min: 200)
        imageView
            .setConstraintsTo(scrollView, .centerX, 0)
            .setConstraints(.centerY, 0)
        
        closeButton
            .setConstraintsTo(view, .leading, 20, true)
            .setConstraints(.top, 0)
    }
    
    public func present(completion: (()->())? = nil) {
        guard let viewController = LCEssentials.getTopViewController(aboveBars: true) else {
            fatalError("Ops! Look like it doesnt have a ViewController")
        }
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .overFullScreen
        viewController.present(self, animated: true) {
            completion?()
        }
    }
    
    public func dismiss(completion: (()->())? = nil) {
        self.dismiss(animated: true) {
            completion?()
        }
    }
    
    @objc private func close(){
        delegate?.imageZoomController?(controller: self, didClose: self.imageView.image)
        self.dismiss()
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

extension ImageZoomController: UIScrollViewDelegate {
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        delegate?.imageZoomController?(controller: self, didZoom: self.imageView.image)
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
#endif
