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
    @IBOutlet weak var pickerViewFirst: UIPickerView!
    @IBOutlet weak var pickerViewSec: UIPickerView!
    @IBOutlet weak var btConfirm: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var borderTop: UIView!
    @IBOutlet weak var borderBottom: UIView!
    @IBOutlet weak var lblFirstTitle: UILabel!
    @IBOutlet weak var lblSecTitle: UILabel!
    @IBOutlet weak var lblTitleConstraints: NSLayoutConstraint!
    
    public var arrayParamsFirst: [[String:Any]] = [[String:Any]]()
    public var arrayParamsSec: [[String:Any]] = [[String:Any]]()
    public var setSelectedRowFirst: Int = 0
    public var setSelectedRowSec: Int = 0
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
        if !arrayParamsFirst.isEmpty && !arrayParamsSec.isEmpty {
            self.pickerView.selectRow(setSelectedRowFirst, inComponent: 0, animated: true)
            self.setSelectedRowFirst = self.arrayParamsFirst[0]["row"] as! Int
            self.pickerView.selectRow(setSelectedRowSec, inComponent: 1, animated: true)
            self.setSelectedRowSec = self.arrayParamsSec[0]["row"] as! Int
        }else{
            self.pickerView.selectRow(setSelectedRowFirst, inComponent: 0, animated: true)
            self.setSelectedRowFirst = self.arrayParamsFirst[0]["row"] as! Int
        }
        if let colum02 = setColumSecTitleStr {
            lblTitleConstraints.constant = setColumFirstFontSize + 10
            self.lblFirstTitle.text = setColumFirstTitleStr
            self.lblSecTitle.text = colum02
            self.lblFirstTitle.font = UIFont(name: setColumFirstFontName, size: setColumFirstFontSize)
            self.lblSecTitle.font = UIFont(name: setColumSecFontName, size: setColumSecFontSize)
        }else{
            lblTitleConstraints.constant = 0
        }
        
    }
    
    static public func instantiate() -> LCEssentialsPickerViewController {
        let storyboard = UIStoryboard(name: "PickerViews", bundle: Bundle(for: LCEssentialsPickerViewController.self))
        let datePicker = storyboard.instantiateViewController(withIdentifier: LCEssentialsPickerViewController.identifier) as! LCEssentialsPickerViewController
        return datePicker
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    public func show(){
        view.removeFromSuperview()
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
            view.frame = CGRect(x: 0, y: ( controller.view.bounds.height - setDistanceFromBottom ), width: setWidth, height: setHeight)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleBottomMargin]
            view.autoresizesSubviews = true
            controller.view.addSubview(view)
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear],
                           animations: {
                            self.view.center.y -= self.view.bounds.height
                            self.view.layoutIfNeeded()
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
                        self.view.center.y += self.view.bounds.height
                        self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.isHidden = true
            self.view.removeFromSuperview()
        })
    }
    
    @IBAction func done(_ sender: Any){
        let rowFirst = pickerView.selectedRow(inComponent: 0)
        delegate.pickerViewController(self, didSelectRow: rowFirst, inComponent: 0)
        delegate.pickerViewController(didDone: self, didSelectRow: rowFirst, inComponent: 0)
        if !arrayParamsSec.isEmpty {
            let rowSec = pickerView.selectedRow(inComponent: 1)
            delegate.pickerViewController(self, didSelectRow: rowSec, inComponent: 1)
            delegate.pickerViewController(didDone: self, didSelectRow: rowSec, inComponent: 1)
        }
        hidde()
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
        }
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: setFontName, size: setFontSize)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = self.arrayParamsFirst[row]["title"] as? String
        pickerLabel?.textColor = setFontColor
        return pickerLabel!
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return delegate.pickerViewController(numberOfComponents: self)
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return delegate.pickerViewController(self, rowHeightForComponent: component)
    }
}
