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
 

//import UIKit
//import LCEssentials
//
//class ViewController: UIViewController {
//    
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var txtSearch: UITextField!{
//        didSet{
//            txtSearch.borderWidth = 1
//            txtSearch.borderColor = .darkGray
//            txtSearch.cornerRadius = txtSearch.frame.height / 2
//        }
//    }
//    lazy var content: [Int: String] = [0: "Open Picker Controller", 1: "Open Date Picker", 2: "Open Alert Message on bottom", 3: "Open Alert Message on TOP",
//                                       4: "Open Notifications Runtime", 5: "Open Image Zoom", 6: "Open Second View With Singleton built in",
//                                       7: "Image Picker Controller", 8: "Show loading screen and then, alert Controller"]
//    
////    let pickerController: PickerViewController = PickerViewController.instantiate()
////    lazy var pickerParams: [[String: Any]] = [["title": "First Choice", "row": 0], ["title": "Sec Choice", "row": 1], ["title": "Third Choice", "row": 2]]
//    
////    let datePickerController: DatePickerViewController = DatePickerViewController.instantiate()
//    
//    var delegate: LCESingletonDelegate? = nil
//    
//    var alreadyAnimatedIndexPath = [IndexPath]()
//    var animationDuration: TimeInterval = 0.85
//    var delay: TimeInterval = 0.05
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
//        tableView.tableFooterView = UIView()
//        tableView.estimatedRowHeight = 60
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.reloadData()
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissSystemKeyboard(_:))))
//        
//        //LOOK AT DEBBUGER CONSOLE
//        API.url = "https://api.github.com/users/{user}"
//        API.request(["user": "loverde-co"] as [String: Any], .get) { (result) in
//            switch result {
//            case .failure(let error):
//                printLog(title: "JSON ERROR", msg: error.localizedDescription)
//                break
//            case .success(let json):
//                printLog(title: "JSON OUTPUT", msg: (json as! String), prettyPrint: true)
//                break
//            }
//        }
//        
//        //MARK: - Set Picker Controller
////        pickerController.setSelectedRowIndex = 0
////        pickerController.delegate = self
////        pickerController.setWidth = self.view.bounds.width
////        pickerController.setDistanceFromBottom = 50
////        pickerController.setFontSize = 20
////        if #available(iOS 12.0, *) {
////            if traitCollection.userInterfaceStyle == .light {
////                pickerController.setFontColor = .black
////            } else {
////                pickerController.setFontColor = .gray
////            }
////        } else {
////            pickerController.setFontColor = .black
////        }
////        pickerController.touchToClose = true
////        pickerController.setFontSelectedBGColor = .darkGray
////        pickerController.setFontSelectedColor = .white
//
//        
//        //MARK: - Set Date Picker Controller
////        datePickerController.delegate = self
////        datePickerController.setWidth = self.view.bounds.width
////        datePickerController.setDistanceFromBottom = 50
////        //datePickerController.minimumDate = Date()
////        datePickerController.touchToClose = true
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//}
//
//extension ViewController {
//
//    //MARK: - Open Picker Controller
//    func openPickerController(){
////        if pickerController.isHidden {
////            pickerController.show()
////        }
//    }
//
//    //MARK: - Open Date Picker Controller
//    func openDatePickerController(){
////        if datePickerController.isHidden {
////            datePickerController.show()
////        }
//    }
//    
//    //MARK: - Notification Runtime Controller
//    func openNotificationRuntime(){
////        let notif = LCENotificationRunTime.instantiate()
////        notif.delegate = self
////        notif.anyData = nil //If you need grab any data to handler on Delegate
////        notif.setDesc = "Description on received message"
////        notif.setTitle = "Title on received message"
////        notif.setImage = nil //If you need to set a image on left
////        notif.setHeight = UIDevice.bottomNotch >= 20 ? 130 : 100
////        notif.show()
//    }
//    
//    //MARK: - Messages Alert Bottom
//    func openMessageAlert(){
////        let message = LCEMessages()
////        message.delegate = self
////        message.addObserverForKeyboard()
////        message.direction = .bottom
////        message.duration = .fiveSecs
////        message.tapToDismiss = true
////        message.backgroundColor = .darkGray
////        message.descriptionLabelString = "Testing message bottom with loading"
////        message.show(loading: true)
//    }
//    
//    //MARK: - Messages Alert TOP
//    func openMessageAlertTop(){
////        let message = LCEMessages()
////        message.delegate = self
////        message.direction = .top
////        message.duration = .fiveSecs
////        message.tapToDismiss = true
////        message.backgroundColor = .darkGray
////        message.descriptionLabelString = "Testing message TOP with loading"
////        message.show(loading: true)
//    }
//    
//    //MARK: - Image Zoom
//    func openImageZoom(){
//        guard let image = UIImage(named: "loverde_company_logo_full") else { return }
//        let imageZoomController: ImageZoomController = ImageZoomController(image)
//        imageZoomController.delegate = self
//        imageZoomController.present()
//    }
//    
//    //MARK: - Singleton usage example
//    func openSecViewController(){
//        let controller:SecondVC = SecondVC.instantiate(storyBoard: "Main")
//        controller.delegate = self
//        self.delegate = controller
//        self.delegate?.singleton?(object: "Object", withData: "Transfering Data")
//        self.navigationController?.pushViewController(controller, animated: true)
//        //self.present(controller, animated: true, completion: nil)
//    }
//    
//    //MARK: - Picker Controller
//    func openImagePicker(){
//        let camera = ImagePickerController()
//        camera.delegate = self
//        camera.isEditable = false
//        camera.openImagePicker()
//    }
//    
//    func openAlert(){
//        let controller: HUDAlertViewController = HUDAlertViewController()
//        controller.delegate = self
//        controller.isLoadingAlert = true
//        controller.setTitle(color: .blue)
//        controller.configureAlertWith(title: "Loading...")
//        controller.showAlert()
//        LCEssentials.backgroundThread(delay: 8, completion:  {
//            controller.isLoadingAlert = false
//            let actionContinue = HUDAlertAction(title: "Normal Style", type: .normal) {
//                print("Normal Style")
//            }
//            let actionGrey = HUDAlertAction(title: "Discrete Style", type: .discrete) {
//                print("Discrete Style")
//            }
//            let actionCancel = HUDAlertAction(title: "Cancel Style", type: .cancel) {
//                print("Cancel Style")
//            }
//            let actionDestructive = HUDAlertAction(title: "Destrctive Style", type: .destructive) {
//                print("Destrctive Style")
//            }
//            let actionGreen = HUDAlertAction(title: "Green Style", type: .green) {
//                print("Green Style")
//            }
//            controller.setTitle(font: .systemFont(ofSize: 12), color: .red)
//            controller.configureAlertWith(title: "This is a complete alert",
//                                          description: "With all type of buttons",
//                                          actionButtons: [actionContinue, actionGrey, actionDestructive, actionGreen, actionCancel])
//        })
//    }
//}
//
////MARK: - Messages Delegate
////extension ViewController: LCEMessagesDelegate {
////    func messages(didTapOnMessage: LCEMessages) {
////        
////    }
////}
//
////MARK: - Notification Runtime Delegate
////extension ViewController: LCENotifiactionRunTimeDelegate {
////    func messages(didTapOnMessage: LCENotificationRunTime, withData: Any?) {
////        printInfo(title: "TAPPED ON NOTIFICATION RUNTIME", msg: "")
////    }
////    func messages(didSwipeOnMessage: LCENotificationRunTime, withData: Any?) {
////        printInfo(title: "SWIPPED NOTIFICATION RUNTIME", msg: "")
////    }
////}
//
//
////MARK: - TableView Delegate
//extension ViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 1:
//            openDatePickerController()
//        case 2:
//            openMessageAlert()
//        case 3:
//            openMessageAlertTop()
//        case 4:
//            openNotificationRuntime()
//        case 5:
//            openImageZoom()
//        case 6:
//            openSecViewController()
//        case 7:
//            openImagePicker()
//        case 8:
//            openAlert()
//        default:
//            openPickerController()
//            break;
//        }
//        return
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if alreadyAnimatedIndexPath.contains(indexPath) {
//            return
//        }
//
//        let animation = tableView.makeMoveUpWithFadeAnimation(rowHeight: tableView.cellForRow(at: indexPath)?.frame.height ?? 60, duration: animationDuration, delayFactor: delay)
//        let animator = UITableViewAnimator(animation: animation)
//        animator.animate(cell: cell, at: indexPath, in: tableView)
//        alreadyAnimatedIndexPath.append(indexPath)
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.content.count
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let cell = tableView.cellForRow(at: indexPath) else{
//            return UITableView.automaticDimension
//        }
//        return cell.bounds.height < 60.0 ? 60.0 : UITableView.automaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
//        cell.textLabel?.numberOfLines = 0
//        cell.textLabel?.text = self.content[indexPath.row]
//        return cell
//    }
//}
//
////MARK: - Picker Controller Delegate
////extension ViewController: PickerViewControllerDelegate {
////    func pickerViewController(_ picker: PickerViewController, didSelectRow row: Int, inComponent component: Int) {
////
////    }
////
////    func pickerViewController(didDone picker: PickerViewController, didSelectRow row: Int, inComponent component: Int) {
////        printInfo(title: "PICKER", msg: pickerParams[row]["title"] as! String)
////    }
////
////    func pickerViewController(didCancel picker: PickerViewController) {
////
////    }
////
////    func pickerViewController(numberOfComponents inPicker: PickerViewController) -> Int {
////        return 1
////    }
////
////    func pickerViewController(_ picker: PickerViewController, rowHeightForComponent component: Int) -> CGFloat {
////        return 40
////    }
////
////    func pickerViewController(_ picker: PickerViewController, numberOfRowsInComponent component: Int) -> Int {
////        return pickerParams.count
////    }
////
////    func pickerViewController(_ picker: PickerViewController, titleForRow row: Int, forComponent component: Int) -> String? {
////        return pickerParams[row]["title"] as? String
////    }
////
////}
//
////MARK: - Date Picker Controller Delegate
////extension ViewController: DatePickerViewControllerDelegate {
////    func datePickerViewController(didConfirm picker: DatePickerViewController, withValue: String) {
////        printInfo(title: "Date Picker", msg: withValue)
////    }
////
////    func datePickerViewController(didCancel picker: DatePickerViewController) {
////        printInfo(title: "Date Picker", msg: "CANCEL")
////    }
////
////    func datePickerViewController(didEndScrollPicker picker: DatePickerViewController, withValue: String) {
////        printInfo(title: "Date Picker - Scroll to date", msg: withValue)
////    }
////}
//
////MARK: - Image Zoom Controller Delegate
//extension ViewController: ImageZoomControllerDelegate {
//    
//}
//
//// MARK: - HUDAlert Delegate
//extension ViewController: HUDAlertViewControllerDelegate {
//    
//}
//
////MARK: - Singleton Delegate
//extension ViewController: LCESingletonDelegate {
//    func singleton(object: Any?, withData: Any) {
//        printLog(title: "MAIN VIEW", msg: "GET \(object ?? "") - \(withData)")
//    }
//}
//
////MARK: - Image Picker Controller Delegate
//extension ViewController: ImagePickerControllerDelegate {
//    func imagePicker(didSelect image: UIImage?) {
//        if let image = image {
//            printInfo(title: "IMAGE SELECTED", msg: image.debugDescription)
//        }else{
//            printInfo(title: "IMAGE SELECTED", msg: "NOTHING")
//        }
//    }
//}
//
////MARK: - TextField Delegate mask example
//extension ViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////        let texto: String? = String().applyMask(inputMask: "#####-###", maxLenght: 9, range: range, textFieldString: textField.text ?? "", replacementString: string, charactersRestriction: nil)
////        if let output = texto {
////            textField.text = output
////        }
////        return false
//        return true
//    }
//}
