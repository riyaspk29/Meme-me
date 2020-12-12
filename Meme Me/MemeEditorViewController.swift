//
//  ViewController.swift
//  Meme Me
//
//  Created by user on 11/12/2020.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    enum FeildType: Int {
        case top = 1, bottom = 2
    }
    
    enum PickerType: Int {
        case camera = 1, gallery = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToKeybordNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        restEditorView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeybordNotifications()
    }
    
    @IBAction func cancelEdit(_ sender: Any) {
        restEditorView()
    }
    
    func restEditorView(){
        configureTextField(topText)
        configureTextField(bottomText)
        imagePickerView.image = nil
        shareButton.isEnabled = false
    }
    
    func configureTextField(_ uITextField:UITextField!){
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -3
        ]
        
        uITextField.delegate = memeTextFieldDelegate
       
        uITextField.defaultTextAttributes = memeTextAttributes
        uITextField.textAlignment = .center
        uITextField.borderStyle = .none
        uITextField.autocapitalizationType = .allCharacters
        
        uITextField.text =  FeildType(rawValue: uITextField.tag)! == FeildType.top ? "TOP" : "BOTTOM"
        
        uITextField.isHidden = true
    }

    @IBAction func pickAnImage(_ sender: UIView) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        pickerController.sourceType = PickerType(rawValue: sender.tag)! == PickerType.camera ? .camera : .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        topText.isHidden = false
        bottomText.isHidden = false
        shareButton.isEnabled = true
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagePickerView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func subscribeToKeybordNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeybordNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keybordWillShow(_ notification:Notification){
        if(bottomText.isEditing){
            view.frame.origin.y = -getKeyBordHeight(notification);
        }
    }
    

    @objc func keybordWillHide(_ notification:Notification){
        view.frame.origin.y = 0;
    }
    
    func getKeyBordHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keybordSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keybordSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {
        
        hideTopAndBottomBars(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideTopAndBottomBars(false)

        return memedImage
    }
    
    func hideTopAndBottomBars(_ hide: Bool) {
        toolBar.isHidden = hide
        navigationBar.isHidden = hide
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let image:UIImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed && error == nil{
                self.save(memedImage: image)
            }
        }
        present(controller, animated: true, completion:nil)
    }
    
    func save(memedImage:UIImage) {
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image, memedImage: memedImage)
        print(meme)
    }
}

