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
import AVFoundation
import Photos

public protocol ImagePickerControllerDelegate: class {
    func imagePicker(didSelect image: UIImage?)
}

public class ImagePickerController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var isAlertOpen: Bool = false
    private var imagePickerController: UIImagePickerController = UIImagePickerController()
    public var delegate: ImagePickerControllerDelegate?
    public var isEditable: Bool = false

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = isEditable
        self.imagePickerController.mediaTypes = ["public.image", "public.movie"]
    }

    
    public func openImagePicker(){
        var cameraPerm: Bool = false
        var albumPerm: Bool = false
        
        //Camera
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
            cameraPerm = true
        } else {
            cameraPerm = false
        }
        
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .authorized {
            albumPerm = true
        }else if photos == .notDetermined || photos == .denied || photos == .restricted {
            albumPerm = false
        }
        
        DispatchQueue.main.async {
            if let presentedController = (self.delegate as? UIViewController)?.presentedViewController, presentedController == self {
                self.openAlerts(forCamera: cameraPerm, forAlbum: albumPerm)
            }else{
                (self.delegate as? UIViewController)?.present(self, animated:false, completion: {
                    self.openAlerts(forCamera: cameraPerm, forAlbum: albumPerm)
                })
            }
        }
    }
    
    
    //MARK: - UIImagePicker Delegate
    @objc public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.delegate?.imagePicker(didSelect: nil)
        picker.dismiss(animated: true, completion: {
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    @objc public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //print("ESCOLHEU OU TIROU FOTO: \(info.debugDescription)")
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.delegate?.imagePicker(didSelect: image)
        }else if let image = info[ UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.delegate?.imagePicker(didSelect: image)
        }
        picker.dismiss(animated: true, completion: {
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    
    private func openAlerts(forCamera:Bool = true, forAlbum:Bool = true){
        let alert = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
        if forCamera {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCameraDevice()
            }))
        }else{
            alert.addAction(UIAlertAction(title: "Allow camera permission", style: .default, handler: { _ in
                self.openAppSettingsCamera()
            }))
        }
        
        if forAlbum {
            alert.addAction(UIAlertAction(title: "Camera roll", style: .default, handler: { _ in
                self.openAlbumDevice()
            }))
        }else{
            alert.addAction(UIAlertAction(title: "Allow camera roll permission", style: .default, handler: { _ in
                self.openAppSettingsPhoto()
            }))
        }
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: false, completion: nil)
        }))
        self.isAlertOpen = true
        DispatchQueue.main.async {
            self.modalPresentationStyle = .fullScreen
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func openCameraDevice(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            self.imagePickerController.sourceType = UIImagePickerController.SourceType.camera
            self.modalPresentationStyle = .fullScreen
            self.present(self.imagePickerController, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.modalPresentationStyle = .fullScreen
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func openAlbumDevice(){
        self.imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.modalPresentationStyle = .fullScreen
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    private func openAppSettingsPhoto(){
        PHPhotoLibrary.requestAuthorization({status in
            if status == .authorized{
                if self.isAlertOpen {
                    self.isAlertOpen = false
                    self.openImagePicker()
                }
            }else{
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl)  {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    }
                    else  {
                        UIApplication.shared.openURL(settingsUrl)
                    }
                }
            }
        })
    }
    
    private func openAppSettingsCamera(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
            if granted == true {
                if self.isAlertOpen {
                    self.isAlertOpen = false
                    self.openImagePicker()
                }
            } else {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl)  {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    }
                    else  {
                        UIApplication.shared.openURL(settingsUrl)
                    }
                }
            }
        })
    }
}
