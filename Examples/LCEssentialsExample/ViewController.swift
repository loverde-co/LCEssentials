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

    @IBOutlet weak var tableView: UITableView!
    lazy var content: [Int: String] = [0: "Open Picker Controller", 1: "Open Date Picker", 2: "Open Alert Message on bottom", 3: "Open Notifications Runtime", 4: "Open Image Zoom"]
    
    let pickerController: PickerViewController = PickerViewController.instantiate()
    lazy var pickerParams: [[String: Any]] = [["title": "First Choice", "row": 0], ["title": "Sec Choice", "row": 1], ["title": "Third Choice", "row": 2]]
    
    let datePickerController: DatePickerViewController = DatePickerViewController.instantiate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.reloadData()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))

        
        API.url = "https://api.github.com/users/{user}"
        API.request(["user": "loverde-co"] as [String:Any], .get) { (result) in
            switch result {
            case .failure(let error):
                printLog(title: "JSON ERROR", msg: error.localizedDescription)
                break
            case .success(let json):
                printLog(title: "JSON OUTPUT", msg: json as! String, prettyPrint: true)
                break
            }
        }
        
        //MARK: - Set Picker Controller
        pickerController.setSelectedRowIndex = 0
        pickerController.delegate = self
        pickerController.setWidth = self.view.bounds.width
        pickerController.setDistanceFromBottom = 50
        pickerController.setFontSize = 20
        pickerController.setFontColor = .black
        pickerController.touchToClose = true

        
        //MARK: - Set Date Picker Controller
        datePickerController.delegate = self
        datePickerController.setWidth = self.view.bounds.width
        datePickerController.setDistanceFromBottom = 50
        //datePickerController.minimumDate = Date()
        datePickerController.touchToClose = true
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
    
    //MARK: - Messages Alert
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
    
    //MARK: - Image Zoom
    func openImageZoom(){
        let imageZoomController: ImageZoomController = ImageZoomController.instantiate()
        imageZoomController.delegate = self
        imageZoomController.setImage = #imageLiteral(resourceName: "office_example_image_zoom")
        self.present(imageZoomController, animated: true, completion: nil)
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
            openNotificationRuntime()
        case 4:
            openImageZoom()
        default:
            openPickerController()
            break;
        }
        return
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
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
        return 30
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
