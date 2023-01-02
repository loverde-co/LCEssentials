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
import UIKit

#if os(iOS) || os(macOS)
public extension UIImageView {

    func changeColorOfImage( _ color: UIColor, image: UIImage? ) -> UIImageView {

        let origImage   = image
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image      = tintedImage
        self.tintColor  = color
        return self
    }
    
    private static var taskKey = 0
    private static var urlKey = 0

    private var currentTask: URLSessionTask? {
        get { return objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var currentURL: URL? {
        get { return objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func downloadAsync(with urlString: String?, alternativeImage: UIImage, numberOfRetry: Int = 0, completion: ((Bool) -> Void)? = nil) {

        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()
        
        DispatchQueue.main.async {
            self.image = alternativeImage
        }

        guard let urlString = urlString else { return }

        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            completion?(true)
            return
        }

        guard let url = URL(string: urlString) else { currentTask = nil; print("ERROR: loadImageAsync - invalid URL"); return; }
        currentURL = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.currentTask = nil

            if let error = error {
                
                DispatchQueue.main.async {
                    self?.image = alternativeImage
                }
                if (error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorCancelled {
                    print("ERROR: loadImageAsync - \(error.localizedDescription)")
                    if numberOfRetry == 0 {
                        completion?(false)
                    } else {
                        let retry = (numberOfRetry - 1)
                        self?.downloadAsync(with: urlString, alternativeImage: alternativeImage, numberOfRetry: retry, completion: completion)
                    }
                    return
                }
                
                print("ERROR: loadImageAsync - \(error.localizedDescription)")
                if numberOfRetry == 0 {
                    completion?(false)
                } else {
                    let retry = (numberOfRetry - 1)
                    self?.downloadAsync(with: urlString, alternativeImage: alternativeImage, numberOfRetry: retry, completion: completion)
                }
                return
            }

            guard let data = data, let downloadedImage = UIImage(data: data) else {
                print("ERROR: loadImageAsync - unable to extract image")
                if numberOfRetry == 0 {
                    completion?(false)
                } else {
                    let retry = (numberOfRetry - 1)
                    self?.downloadAsync(with: urlString, alternativeImage: alternativeImage, numberOfRetry: retry, completion: completion)
                }
                return
            }

            ImageCache.shared.save(image: downloadedImage, forKey: urlString)

            if url == self?.currentURL {
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                    completion?(true)
                }
            }
        }

        currentTask = task
        task.resume()
    }
    
    @IBInspectable var imageColor: UIColor! {
        set {
            super.tintColor = newValue
        }
        get {
            return super.tintColor
        }
    }
    /// SwifterSwift: Make image view blurry
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    func blur(withStyle style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
        clipsToBounds = true
    }

    /// SwifterSwift: Blurred version of an image view
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    /// - Returns: blurred version of self.
    func blurred(withStyle style: UIBlurEffect.Style = .light) -> UIImageView {
        let imgView = self
        imgView.blur(withStyle: style)
        return imgView
    }
}

class ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol!

    static let shared = ImageCache()

    private init() {
        // make sure to purge cache on memory pressure

        observer = NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil) { [weak self] notification in
            self?.cache.removeAllObjects()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(observer ?? (Any).self)
    }

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
#endif
