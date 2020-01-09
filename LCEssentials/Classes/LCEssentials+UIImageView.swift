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
extension UIImageView {

    public func changeColorOfImage( _ color: UIColor, image: NSString ) -> UIImageView {

        let origImage   = UIImage(named: image as String);
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.image      = tintedImage
        self.tintColor  = color
        return self
    }

    public func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, completion:@escaping (Bool?)->()) -> () {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { completion(false); return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                completion(true)
            }
            }.resume()
    }
    // EXAMPLE USAGE
    // imageView.downloadedFrom(link: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png")

    public func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, completion:@escaping (Bool?)->()) -> () {
        guard let url = URL(string: link) else { completion(false); return }
        downloadedFrom(url: url, contentMode: mode) { (success) in
            completion(true)
        }
    }

    @IBInspectable open var imageColor: UIColor! {
        set {
            super.tintColor = newValue
        }
        get {
            return super.tintColor
        }
    }
}
#endif
