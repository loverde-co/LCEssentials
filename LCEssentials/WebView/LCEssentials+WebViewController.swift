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
 
#if os(iOS) || os(macOS)
import UIKit
import WebKit

class LCEWebViewController : UIViewController, WKNavigationDelegate {
    
    var url : String!
    @IBOutlet var webView : WKWebView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var loadingView : UIActivityIndicatorView!
    var presentation: UIModalPresentationStyle = .currentContext //.overFullScreen
    
    override func viewDidLoad() {
        if let _ = self.navigationController {
            fatalError("Ops! This controller allow only present style")
        }
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            loadingView.startAnimating()
            webView.isHidden = true
            webView.load(request)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.stopAnimating()
        webView.isHidden = false
        webView.evaluateJavaScript("document.title") { (anyresult, error) in
            if let string = anyresult as? String {
                self.navBar.topItem?.title = string
            }
        }
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingView.stopAnimating()
        webView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingView.startAnimating()
        webView.isHidden = true
    }
    
    @IBAction func close(){
       self.dismiss(animated: true, completion: nil)
    }
}
#endif
