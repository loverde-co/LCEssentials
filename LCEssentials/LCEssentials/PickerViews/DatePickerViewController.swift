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

@objc public protocol DatePickerViewControllerDelegate {
    @objc func datePickerViewController(didConfirm picker: DatePickerViewController, withValue: String)
    @objc func datePickerViewController(didCancel picker: DatePickerViewController)
    @objc func datePickerViewController(didEndScrollPicker picker: DatePickerViewController, withValue: String)
}

public class DatePickerViewController: UIViewController {
    
    public var delegate: DatePickerViewControllerDelegate!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btConfirm: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var borderTop: UIView!
    @IBOutlet weak var borderBottom: UIView!
    
    public var setDatePickerMode: UIDatePickerMode = .date
    public var setLocale: String = "pt_BR"
    public var setFormat: String = "dd/MM/yyyy"
    public var setHeight: CGFloat = 214
    public var setWidth: CGFloat = 375
    public var setDistanceFromBottom: CGFloat = 0
    public var isHidden: Bool = true
    public var setBorderTopColor: UIColor = UIColor.darkGray
    public var setBorderBottomColor: UIColor = UIColor.darkGray
    public var setConfirmTitleButton: String = "Done"
    public var setCancelTitleButton: String = "Cancel"
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.locale = Locale(identifier: setLocale)
        datePicker.datePickerMode = setDatePickerMode
        btCancel.titleLabel?.text = setCancelTitleButton
        btConfirm.titleLabel?.text = setConfirmTitleButton
    }
    
    static public func instantiate() -> DatePickerViewController {
        let storyboard = UIStoryboard(name: "PickerViews", bundle: Bundle(for: DatePickerViewController.self))
        let datePicker = storyboard.instantiateViewController(withIdentifier: "idDatePickerViewController") as! DatePickerViewController
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
        if delegate is UIViewController {
            let controller = delegate as! UIViewController
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
        let formatter = DateFormatter()
        formatter.dateFormat = setFormat
        hidde()
        delegate.datePickerViewController(didConfirm: self, withValue: formatter.string(from: datePicker.date))
    }
    
    @IBAction func cancel(_ sender: Any){
        hidde()
        delegate.datePickerViewController(didCancel: self)
    }
    
    @IBAction func changed(_ sender: Any){
        let formatter = DateFormatter()
        formatter.dateFormat = setFormat
        delegate.datePickerViewController(didEndScrollPicker: self, withValue: formatter.string(from: datePicker.date))
    }
}
