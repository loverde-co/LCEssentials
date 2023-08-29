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
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var shadowView: UIView!
    
    var md5String = "MD5 native encode"
    
    var delegate: LCESingletonDelegate? = nil
    
    //let message: LCEMessages? = LCEMessages.instantiate()
    
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
        //message?.removeObserverForKeyboard()
    }

    func setupView(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
//        message?.addObserverForKeyboard()
//        message?.delegate = self
//        message?.setDirection = .bottom
//        message?.setDuration = .fiveSecs
//        message?.tapToDismiss = true
//        message?.setBackgroundColor = .darkGray
    
        let md5Data = Data.MD5(string: md5String)
        let toHex = md5Data.toHexString()
        printLog(title: "MD5", msg: toHex)
        self.lblMD5.text = "Original message: \(md5String)\n\nMD5 output: "+toHex
        
//        LCEssentials.backgroundThread(delay: 10, completion:  {
//            let attrString = NSMutableAttributedString()
//            attrString.customize("First line title", size: 20, color: .blue)
//            attrString.customize("\nSecond line description", size: 14, color: .lightGray)
//            self.lblMD5.attributedText = attrString
//        })
        
        shadowView.cornerRadius(radius: 8)
        var color = UIColor.black
        var opacity: Float = 0.3
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle != .light {
                color = .yellow
                opacity = 1.0
            }
        }
        shadowView.applyShadow(color: color, offSet: CGSize(width: 0, height: 2), radius: 4, opacity: opacity)
    }
    @IBAction func close(){
        self.closeController{
            
        }
    }
    
    @IBAction func openAlert(){
        //message?.show(message: "Testing message BOTTOM with loading", withImage: nil, showLoading: true)
        LCEssentials.backgroundThread(delay: 1, completion: {
            self.txtField.becomeFirstResponder()
        })
        LCEssentials.backgroundThread(delay: 3, completion: {
            self.view.endEditing(true)
        })
    }
}

extension SecondVC: LCESingletonDelegate {
    func singleton(object: Any?, withData: Any) {
        printLog(title: "SEC VIEW", msg: "SET \(object ?? "") - \(withData)")
    }
}

//extension SecondVC: LCEMessagesDelegate {
//    
//}
