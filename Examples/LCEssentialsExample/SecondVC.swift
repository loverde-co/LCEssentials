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
import LCEssentials

class SecondVC: UIViewController {

    @IBOutlet weak var lblMD5: UILabel!
    var md5String = "MD5 native encode"
    
    var delegate: LCESingletonDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.singleton?(get: "Object", withData: "Sending Back Data")
    }

    func setupView(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let stringo = Data.MD5(string: md5String)
        let toHex = stringo.toHexString()
        printLog(title: "MD5", msg: toHex)
        self.lblMD5.text = "Original message: \(md5String)\n\nMD5 output: "+toHex
        
    }
}

extension SecondVC: LCESingletonDelegate {
    func singleton(set object: Any, withData: Any) {
        printLog(title: "SEC VIEW", msg: "SET \(object) - \(withData)")
    }
}
