//  
// Copyright (c) 2019 Loverde Co.
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
@objc public protocol LCEssentialsPickerViewControllerDelegate {
    @objc func pickerViewController(_ picker: LCEssentialsPickerViewController, didSelectRow row: Int, inComponent component: Int)
    @objc func pickerViewController(didDone picker: LCEssentialsPickerViewController, didSelectRow row: Int, inComponent component: Int)
    @objc func pickerViewController(didCancel picker: LCEssentialsPickerViewController)
    @objc func pickerViewController(numberOfComponents inPicker: LCEssentialsPickerViewController) -> Int
    @objc func pickerViewController(_ picker: LCEssentialsPickerViewController, rowHeightForComponent component: Int) -> CGFloat
    @objc func pickerViewController(_ picker: LCEssentialsPickerViewController, numberOfRowsInComponent component: Int) -> Int
    @objc func pickerViewController(_ picker: LCEssentialsPickerViewController, titleForRow row: Int, forComponent component: Int) -> String?
    @objc optional func pickerViewController(_ picker: LCEssentialsPickerViewController, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
}

public class LCEssentialsPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet private var viewPicker: UIView!
    @IBOutlet weak var btConfirm: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var borderTop: UIView!
    @IBOutlet weak var borderBottom: UIView!
    
    public var setSelectedRowIndex: Int = 0
    public var setSelectedBGColor: UIColor = UIColor.white
    public var setFontName: String = "Helvetica"
    public var setFontSize: CGFloat = 24
    public var setFontColor: UIColor = .black
    private var lblPicker: UILabel = UILabel()
    public var setHeight: CGFloat = 214
    public var setWidth: CGFloat = 375
    public var setDistanceFromBottom: CGFloat = 0
    public var isHidden: Bool = true
    public var setBorderTopColor: UIColor = UIColor.darkGray
    public var setBarBackgroundColor: UIColor = UIColor(hex: "#D1D1D1")
    public var setBorderBottomColor: UIColor = UIColor.darkGray
    public var setConfirmTitleButton: String = "Done"
    public var setConfirmTitleColor: UIColor = UIColor.darkGray
    public var setCancelTitleButton: String = "Cancel"
    public var setCancelTitleColor: UIColor = UIColor.gray
    public var setColumFirstTitleStr: String?
    public var setColumSecTitleStr: String?
    public var setColumFirstFontName: String = "Helvetica"
    public var setColumFirstFontSize: CGFloat = 18
    public var setColumSecFontName: String = "Helvetica"
    public var setColumSecFontSize: CGFloat = 18
    
    public var delegate : LCEssentialsPickerViewControllerDelegate!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.selectRow(setSelectedRowIndex, inComponent: 0, animated: true)
        
    }
    
    static public func instantiate() -> LCEssentialsPickerViewController {
        return LCEssentialsPickerViewController.instantiate(storyBoard: "PickerViews", identifier: LCEssentialsPickerViewController.identifier)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    public func show(){
        //viewPicker.removeFromSuperview()
        borderTop.backgroundColor = setBorderTopColor
        borderBottom.backgroundColor = setBorderBottomColor
        barView.backgroundColor = setBarBackgroundColor
        btCancel.setTitle(setCancelTitleButton, for: .normal)
        btCancel.sizeToFit()
        btConfirm.setTitle(setConfirmTitleButton, for: .normal)
        btConfirm.sizeToFit()
        btConfirm.setTitleColor(setConfirmTitleColor, for: .normal)
        btCancel.setTitleColor(setCancelTitleColor, for: .normal)
        var controller: UIViewController!
        if delegate is UIViewController {
            controller = delegate as? UIViewController
            viewPicker.frame = CGRect(x: 0, y: ( controller.view.bounds.height - setDistanceFromBottom ), width: setWidth, height: setHeight)
            viewPicker.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleBottomMargin]
            viewPicker.autoresizesSubviews = true
            controller.modalPresentationStyle = .overCurrentContext
            controller.present(self, animated: true, completion: nil)
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear],
                           animations: {
                            self.viewPicker.center.y -= self.view.bounds.height
                            self.viewPicker.layoutIfNeeded()
            }, completion: { (completed) in
                self.isHidden = false
            })
        }else{
            fatalError("Ops! Missing delegate!")
        }
    }
    
    public func hidde(){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear],
                       animations: {
                        self.viewPicker.center.y += self.view.bounds.height
                        self.viewPicker.layoutIfNeeded()
        }, completion: { (completed) in
            self.isHidden = true
            //self.viewPicker.removeFromSuperview()
            let controller = self.delegate as? UIViewController
            controller?.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func done(_ sender: Any){
        hidde()
        delegate.pickerViewController(didDone: self, didSelectRow: self.pickerView.selectedRow(inComponent: 0), inComponent: 0)
    }
    
    @IBAction func cancel(_ sender: Any){
        hidde()
        delegate.pickerViewController(didCancel: self)
    }
    
    //MARK: - UIPickerView Delegate and DataSource
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return delegate.pickerViewController(self, numberOfRowsInComponent: component)
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate.pickerViewController(self, didSelectRow: row, inComponent: component)
        //pickerView.reloadAllComponents()
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return delegate.pickerViewController(self, titleForRow: row, forComponent: component)
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let delgado = delegate.pickerViewController?(self, viewForRow: row, forComponent: component, reusing: view) {
            return delgado
        }else{
            return UIView()
        }
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return delegate.pickerViewController(numberOfComponents: self)
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return delegate.pickerViewController(self, rowHeightForComponent: component)
    }
}
#endif
