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
 

import UIKit
import LCEssentials
//
class SecondVC: UIViewController {

    lazy var lblMD5: UILabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.text = nil
        $0.backgroundColor = UIColor.clear
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.textAlignment = .center
        $0.isOpaque = true
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    var md5String = "MD5 native encode"
    
    var delegate: LCESingletonDelegate? = nil
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LCEssentials.delay(milliseconds: 3) {
            self.delegate?.singleton?(object: "Object", withData: "Sending Back Data")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func setupView(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        view.addSubviews([lblMD5])
        
        lblMD5
            .setConstraintsTo(view, .top, 20, true)
            .setConstraints(.leading, 20)
            .setConstraints(.trailing, -20)
    
        let md5Data = Data.MD5(string: md5String)
        let toHex = md5Data.toHexString
        printLog(title: "MD5", msg: toHex)
        self.lblMD5.text = "Original message: \(md5String)\n\nMD5 output: "+toHex
        
        LCEssentials.backgroundThread(delay: 10, completion:  {
            let attrString = NSMutableAttributedString()
            attrString.customize("First line title", withFont: .systemFont(ofSize: 20), color: .blue)
            attrString.customize("\nSecond line description", withFont: .systemFont(ofSize: 20), color: .lightGray)
            self.lblMD5.attributedText = attrString
        })
    }
    @objc
    func close(){
        self.closeController{
            
        }
    }
}

extension SecondVC: LCESingletonDelegate {
    func singleton(object: Any?, withData: Any) {
        printLog(title: "SEC VIEW", msg: "SET \(object ?? "") - \(withData)")
    }
}
