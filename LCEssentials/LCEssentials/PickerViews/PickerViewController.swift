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


import UIKit

#if os(iOS) || os(macOS)
@objc public protocol PickerViewControllerDelegate {
    @objc func pickerViewController(_ picker: PickerViewController, didConfirm selectedString: String, selectedValue: Int)
    @objc func pickerViewController(didCancel picker: PickerViewController)
    @objc func pickerViewController(_ picker: PickerViewController, didEndScrollPicker SelectedString: String, SelectedValue: Int)
}

public class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var btConfirm: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var borderTop: UIView!
    @IBOutlet weak var borderBottom: UIView!
    
    public var arrayParams: [[String:Any]] = [[String:Any]]()
    public var setSelectedRow: Int = 0
    public var setSelectedBGColor: UIColor = UIColor.white
    public var setFontName: String = "Helvetica"
    public var setFontSize: CGFloat = 24
    public var setHeight: CGFloat = 214
    public var setWidth: CGFloat = 375
    public var setDistanceFromBottom: CGFloat = 0
    public var isHidden: Bool = true
    public var setBorderTopColor: UIColor = UIColor.darkGray
    public var setBorderBottomColor: UIColor = UIColor.darkGray
    public var setConfirmTitleButton: String = "Done"
    public var setConfirmButtonTitleColor: UIColor = .white
    //UIColor.init(red: 88/255, green: 88/255, blue: 90/255, alpha: 1)
    public var setCancelTitleButton: String = "Cancel"
    public var setCancelButtonTitleColor: UIColor = .white
    //UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
    
    public var delegate : PickerViewControllerDelegate!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.selectRow(self.setSelectedRow, inComponent: 0, animated: true)
        self.setSelectedRow = self.arrayParams[0]["row"] as! Int
    }
    
    static public func instantiate() -> PickerViewController {
        let storyboard = UIStoryboard(name: "PickerViews", bundle: Bundle(for: PickerViewController.self))
        let datePicker = storyboard.instantiateViewController(withIdentifier: "idPickerViewController") as! PickerViewController
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
        btCancel.setTitle(setCancelTitleButton, for: .normal)
        btCancel.sizeToFit()
        btConfirm.setTitle(setConfirmTitleButton, for: .normal)
        btConfirm.sizeToFit()
        //btConfirm.setTitleColor(setConfirmButtonTitleColor, for: .normal)
        //btCancel.setTitleColor(setCancelButtonTitleColor, for: .normal)
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
        let row = pickerView.selectedRow(inComponent: 0)
        hidde()
        delegate.pickerViewController(self, didConfirm: (arrayParams[row]["title"] as? String)!, selectedValue: (arrayParams[row]["row"] as? Int)!)
    }
    
    @IBAction func cancel(_ sender: Any){
        hidde()
        delegate.pickerViewController(didCancel: self)
    }
    
    //MARK: - UIPickerView Delegate and DataSource
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayParams.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate.pickerViewController(self, didEndScrollPicker: (arrayParams[row]["title"] as? String)!, SelectedValue: (arrayParams[row]["row"] as? Int)!)
        pickerView.reloadAllComponents()
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayParams[row]["title"] as? String
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        var titleData : String = String()
        
        if pickerView == pickerView {
            titleData = (arrayParams[row]["title"] as? String)!
        }
        pickerLabel.text = titleData
        pickerLabel.font = UIFont(name: setFontName, size: setFontSize)
        //pickerLabel.textColor = UIColor.black
        
        if pickerView.selectedRow(inComponent: component) == row && (arrayParams[row]["title"] as? String)! == titleData {
            pickerLabel.backgroundColor = setSelectedBGColor
        }else{
            pickerLabel.backgroundColor = UIColor.clear
        }
        pickerLabel.textAlignment = .center
        
        return pickerLabel
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 34
    }
}
#endif
