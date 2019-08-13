//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Paul Forstner on 04.06.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var topTextField: UITextField!
    @IBOutlet private weak var bottomTextField: UITextField!
    
    // MARK: - Properties
    
    public var editingMeme: Meme?
    
    // MARK: - Life cyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setToolbarHidden(true, animated: false)
        removeObserver()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - ToolbarButtonActions
    
    @objc private func pickAnImageFromAlbum() {
        presentImagePicker(with: .photoLibrary)
    }
    
    @objc private func pickAnImageFromCamera() {
        presentImagePicker(with: .camera)
    }
    
    
    /// Create a ActivityViewController to share the Image
    @objc private func shareImage() {
        
        guard imageView.image != nil else {
            showAlert(Alerts.NoImageTitle, message: Alerts.NoImageToShareMessage)
            return
        }
        
        guard let memedImage = generateMemedImage() else {
            showAlert(Alerts.ErrorTitle, message: Alerts.ErrorMessage)
            return
        }
        
        let vc = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
        present(vc, animated: true)
        
        vc.completionWithItemsHandler = { [weak self] (activityType, completed, returnedItems, error) in
         
            guard let strongSelf = self, completed else {
                return
            }
            
            strongSelf.dismiss(animated: false, completion: nil)
            strongSelf.save(memedImage)
        }
    }
    
    @objc private func cancelMemeEditing() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - ConfigureUI
    
    private func configureUI() {
        
        // ImageViews
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .gray
        
        // TextFields
        configureTextField(topTextField, text: Constants.standartTopText)
        configureTextField(bottomTextField, text: Constants.standartBottomText)
        
        if let editingMeme = self.editingMeme {
            
            topTextField.text = editingMeme.topText
            bottomTextField.text = editingMeme.bottomText
            imageView.image = editingMeme.originalImage
            createBarItemsForEditing()
        } else {
            createBarItems()
            resetUI()
        }
    }
    
    private func configureTextField(_ textField: UITextField, text: String) {
        
        textField.text = text
        textField.delegate = self
        textField.defaultTextAttributes = [
            .font: UIFont(name: "impact", size: 40)!,
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor.black,
            .strokeWidth: -8.0
        ]
        textField.textAlignment = .center
        textField.borderStyle = .none
    }
    
    private func createBarItems() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelMemeEditing))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(pickAnImageFromCamera))
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        let albumButton = UIBarButtonItem(title: "Album", style: .plain, target: self, action: #selector(pickAnImageFromAlbum))
        albumButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        
        toolbarItems = [flexibleSpace, cameraButton, flexibleSpace, albumButton, flexibleSpace]
        
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    private func createBarItemsForEditing() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEditedMeme))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelMemeEditing))
    }
    
    private func resetUI() {
        
        topTextField.text = Constants.standartTopText
        bottomTextField.text = Constants.standartBottomText
    }
    
    // MARK: - Observer
    
    private func addObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeObserver() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Keyboard Helper
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        guard let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return 0.0
        }
        
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: - Helper
    
    /// Present a image picker
    ///
    /// - Parameter sourceType: the type of the image picker.
    private func presentImagePicker(with sourceType: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// Generates a image of the Screen without the Toolbars
    private func generateMemedImage() -> UIImage? {
        
        hideTopAndBottomBars(true)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        view.endEditing(true)
        var memedImage: UIImage? = nil
        
        if let screenImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            memedImage = screenImage
        }
        UIGraphicsEndImageContext()
        
        hideTopAndBottomBars(false)

        return memedImage
    }
    
    /// Save the memed image to the appdelegate
    ///
    /// - Parameter memedImage: image to save.
    private func save(_ memedImage: UIImage) {
        
        let meme = Meme(topText: self.topTextField.text ?? "",
                        bottomText: self.bottomTextField.text ?? "",
                        originalImage: self.imageView.image ?? UIImage(),
                        memedImage: memedImage)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            showAlert(Alerts.SaveErrorTitle, message: Alerts.SaveErrorMessage)
            return
        }
        appDelegate.memes.append(meme)
        resetUI()
        imageView.image = nil
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    /// Save the edited meme to the appdelegate
    @objc private func saveEditedMeme() {
        
        guard let memedImage = generateMemedImage() else {
            showAlert(Alerts.ErrorTitle, message: Alerts.ErrorMessage)
            return
        }
        save(memedImage)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            showAlert(Alerts.SaveErrorTitle, message: Alerts.SaveErrorMessage)
            return
        }
        appDelegate.memes.removeAll(where: {$0.memedImage == editingMeme?.memedImage})
        navigationController?.popToRootViewController(animated: true)
    }
    
    func hideTopAndBottomBars(_ hide: Bool) {
        
        navigationController?.setNavigationBarHidden(hide, animated: false)
        navigationController?.setToolbarHidden(hide, animated: false)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension MemeMeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageView.image = image
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
        
        dismiss(animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: false, completion: nil)
    }
}

// MARK: - UINavigationControllerDelegate

extension MemeMeViewController: UINavigationControllerDelegate {
    
}
