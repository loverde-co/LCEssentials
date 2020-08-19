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

class ViewController: UIViewController {
    private var copyView: UIView!
    private var copyTextField: UITextField!
    private var copyButton: UIButton!
    @IBOutlet weak var accessoryView: UIView!
    @IBOutlet weak var txtAccessoryView: UITextField!{
        didSet{
            txtAccessoryView.addPaddingLeft(10)
            copyView = accessoryView.copyView()
            copyView.subviews.forEach { (text) in
                if text is UITextField || text is UIButton  {
                    text.borderWidth = 1
                    text.borderColor = UIColor.init(red: 118/255, green: 131/255, blue: 239/255, alpha: 1)
                    text.cornerRadius = text.height / 2
                    if text is UITextField {
                        copyTextField = (text as! UITextField)
                        copyTextField.addPaddingLeft(10)
                        copyTextField.delegate = self
                    }
                    if text is UIButton{
                        copyButton = (text as! UIButton)
                        copyButton.addTarget(self, action: #selector(sendMenssage), for: .touchUpInside)
                    }
                }
            }
            txtAccessoryView.inputAccessoryView = copyView
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    private var keyboardShowing: Bool = false
    lazy var content: [Int: String] = [0: "Open Picker Controller", 1: "Open Date Picker", 2: "Open Alert Message on bottom", 3: "Open Alert Message on TOP",
                                       4: "Open Notifications Runtime", 5: "Open Image Zoom", 6: "Open Second View With Singleton built in",
                                       7: "Image Picker Controller",
                                       /*8: "Image Picker Controller",
                                       9: "Image Picker Controller",
                                       10: "Image Picker Controller",
                                       11: "Image Picker Controller",
                                       12: "Image Picker Controller",
                                       13: "Image Picker Controller",
                                       14: "Image Picker Controller",
                                       15: "Image Picker Controller",
                                       16: "Image Picker Controller",
                                       17: "Image Picker Controller",
                                       18: "Image Picker Controller",
                                       19: "Image Picker Controller",
                                       20: "Image Picker Controller",
                                       21: "Image Picker Controller",
                                       22: "Image Picker Controller",
                                       23: "Image Picker Controller",
                                       24: "Image Picker Controller",
                                       25: "Image Picker Controller"*/]
    
    let pickerController: PickerViewController = PickerViewController.instantiate()
    lazy var pickerParams: [[String: Any]] = [["title": "First Choice", "row": 0], ["title": "Sec Choice", "row": 1], ["title": "Third Choice", "row": 2]]
    
    let datePickerController: DatePickerViewController = DatePickerViewController.instantiate()
    
    var delegate: LCESingletonDelegate? = nil
    
    var alreadyAnimatedIndexPath = [IndexPath]()
    var animationDuration: TimeInterval = 0.85
    var delay: TimeInterval = 0.05
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
        
        //LOOK AT DEBBUGER VIEW
        API.url = "https://api.github.com/users/{user}"
        API.request(["user": "loverde-co"] as [String:Any], .get) { (result) in
            switch result {
            case .failure(let error):
                printLog(title: "JSON ERROR", msg: error.localizedDescription)
                break
            case .success(let json):
                printLog(title: "JSON OUTPUT", msg: (json as! String), prettyPrint: true)
                break
            }
        }
        
        //MARK: - Set Picker Controller
        pickerController.setSelectedRowIndex = 0
        pickerController.delegate = self
        pickerController.setWidth = self.view.bounds.width
        pickerController.setDistanceFromBottom = 50
        pickerController.setFontSize = 20
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                pickerController.setFontColor = .black
            } else {
                pickerController.setFontColor = .gray
            }
        } else {
            pickerController.setFontColor = .black
        }
        pickerController.touchToClose = true
        pickerController.setFontSelectedBGColor = .darkGray
        pickerController.setFontSelectedColor = .white

        
        //MARK: - Set Date Picker Controller
        datePickerController.delegate = self
        datePickerController.setWidth = self.view.bounds.width
        datePickerController.setDistanceFromBottom = 50
        //datePickerController.minimumDate = Date()
        datePickerController.touchToClose = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
}

extension ViewController {
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // Do your thang here!
            self.view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            var bottomInset: UIEdgeInsets!
            if isKeyboardShowing {
                self.accessoryView.isHidden = true
                self.copyView.isHidden = false
                keyboardShowing = true
                copyTextField.becomeFirstResponder()
                bottomInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
            }else{
                keyboardShowing = false
                bottomInset = UIEdgeInsets.zero
            }

            if notification.name == UIResponder.keyboardDidHideNotification {
                self.accessoryView.isHidden = false
                self.copyView.isHidden = true
            }

            tableViewBottomConstraint.constant = isKeyboardShowing ? (keyboardFrame!.height - self.accessoryView.height) - self.tabBarController!.tabBar.height : 0
            self.tableView.contentInset = bottomInset

            UIView.animate(withDuration: animationDuration!, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if isKeyboardShowing && !self.content.isEmpty {
                    LCEssentials.backgroundThread(delay: 0.2) {
                        let indexPath = IndexPath(item: self.content.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
            })
        }
    }

    //MARK: - Open Picker Controller
    func openPickerController(){
        if pickerController.isHidden {
            pickerController.show()
        }
    }

    //MARK: - Open Date Picker Controller
    func openDatePickerController(){
        if datePickerController.isHidden {
            datePickerController.show()
        }
    }
    
    //MARK: - Set Picker Controller
    func openNotificationRuntime(){
        let notif = LCENotificationRunTime.instantiate()
        notif.delegate = self
        notif.anyData = nil //If you need grab any data to handler on Delegate
        notif.setDesc = "Description on received message"
        notif.setTitle = "Title on received message"
        notif.setHeight = LCEssentials.X_DEVICES ? 130 : 100
        notif.show()
    }
    
    //MARK: - Messages Alert Bottom
    func openMessageAlert(){
        let message = LCEMessages.instantiate()
        message.viewWillAppear(true)
        message.delegate = self
        message.addObserverForKeyboard()
        message.setDirection = .bottom
        message.setDuration = .fiveSecs
        message.tapToDismiss = true
        message.setBackgroundColor = .darkGray
        message.show(message: "Testing message bottom with loading", withImage: nil, showLoading: true)
    }
    
    //MARK: - Messages Alert TOP
    func openMessageAlertTop(){
        let message = LCEMessages.instantiate()
        message.viewWillAppear(true)
        message.delegate = self
        message.setDirection = .top
        message.setDuration = .fiveSecs
        message.tapToDismiss = true
        message.setBackgroundColor = .darkGray
        message.show(message: "Testing message TOP with loading", withImage: nil, showLoading: true)
    }
    
    //MARK: - Image Zoom
    func openImageZoom(){
        let imageZoomController: ImageZoomController = ImageZoomController.instantiate()
        imageZoomController.delegate = self
        imageZoomController.setImage = #imageLiteral(resourceName: "office_example_image_zoom.jpg")
        self.present(imageZoomController, animated: true, completion: nil)
    }
    
    //MARK: - Singleton usage example
    func openSecViewController(){
        let controller:SecondVC = SecondVC.instantiate(storyBoard: "Main")
        controller.delegate = self
        self.delegate = controller
        self.delegate?.singleton?(set: "Object", withData: "Transfering Data")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Picker Controller
    func openImagePicker(){
        let camera = ImagePickerController()
        camera.delegate = self
        camera.isEditable = false
        camera.openImagePicker()
    }
    
    @IBAction func sendMenssage(){
        txtAccessoryView.text = copyTextField.text != "" ? copyTextField.text : txtAccessoryView.text
        printInfo(title: "Chat Bar", msg: txtAccessoryView.text ?? "")
        txtAccessoryView.text = nil
        copyTextField.text = nil
    }
}

//MARK: - Messages Delegate
extension ViewController: LCEMessagesDelegate {
    func messages(didTapOnMessage: LCEMessages) {
        
    }
}

//MARK: - Notification Runtime Delegate
extension ViewController: LCENotifiactionRunTimeDelegate {
    func messages(didTapOnMessage: LCENotificationRunTime, withData: Any?) {
        printInfo(title: "TAPPED ON NOTIFICATION RUNTIME", msg: "")
    }
    func messages(didSwipeOnMessage: LCENotificationRunTime, withData: Any?) {
        printInfo(title: "SWIPPED NOTIFICATION RUNTIME", msg: "")
    }
}


//MARK: - TableView Delegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            openDatePickerController()
        case 2:
            openMessageAlert()
        case 3:
            openMessageAlertTop()
        case 4:
            openNotificationRuntime()
        case 5:
            openImageZoom()
        case 6:
            openSecViewController()
        case 7:
            openImagePicker()
        default:
            openPickerController()
            break;
        }
        return
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if alreadyAnimatedIndexPath.contains(indexPath) {
            return
        }

        let animation = tableView.makeMoveUpWithFadeAnimation(rowHeight: tableView.cellForRow(at: indexPath)?.height ?? 60, duration: 0.85, delayFactor: 0.05)
        let animator = UITableViewAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
        alreadyAnimatedIndexPath.append(indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.cellForRow(at: indexPath) else{
            return UITableView.automaticDimension
        }
        return cell.bounds.height < 60.0 ? 60.0 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = self.content[indexPath.row]
        return cell
    }
}

//MARK: - Picker Controller Delegate
extension ViewController: PickerViewControllerDelegate {
    func pickerViewController(_ picker: PickerViewController, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerViewController(didDone picker: PickerViewController, didSelectRow row: Int, inComponent component: Int) {
        printInfo(title: "PICKER", msg: pickerParams[row]["title"] as! String)
    }
    
    func pickerViewController(didCancel picker: PickerViewController) {
        
    }
    
    func pickerViewController(numberOfComponents inPicker: PickerViewController) -> Int {
        return 1
    }
    
    func pickerViewController(_ picker: PickerViewController, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerViewController(_ picker: PickerViewController, numberOfRowsInComponent component: Int) -> Int {
        return pickerParams.count
    }
    
    func pickerViewController(_ picker: PickerViewController, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerParams[row]["title"] as? String
    }
}

//MARK: - Date Picker Controller Delegate
extension ViewController: DatePickerViewControllerDelegate {
    func datePickerViewController(didConfirm picker: DatePickerViewController, withValue: String) {
        printInfo(title: "Date Picker", msg: withValue)
    }
    
    func datePickerViewController(didCancel picker: DatePickerViewController) {
        printInfo(title: "Date Picker", msg: "CANCEL")
    }
    
    func datePickerViewController(didEndScrollPicker picker: DatePickerViewController, withValue: String) {
        printInfo(title: "Date Picker - Scroll to date", msg: withValue)
    }
}

//MARK: - Image Zoom Controller Delegate
extension ViewController: ImageZoomControllerDelegate {
    
}

//MARK: - Singleton Delegate
extension ViewController: LCESingletonDelegate {
    func singleton(get object: Any, withData: Any) {
        printLog(title: "MAIN VIEW", msg: "GET \(object) - \(withData)")
    }
}

extension ViewController: ImagePickerControllerDelegate {
    func imagePicker(didSelect image: UIImage?) {
        if let image = image {
            printInfo(title: "IMAGE SELECTED", msg: image.debugDescription)
        }else{
            printInfo(title: "IMAGE SELECTED", msg: "NOTHING")
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtAccessoryView.text = textField.text
    }
}
