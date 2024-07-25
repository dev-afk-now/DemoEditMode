//
//  PhotoPickerViewController.swift
//  DemoEditMode
//
//  Created by Nik Dub on 25.07.2024.
//

import UIKit
import Photos

class PhotoPickerViewController: UIViewController {
    
    var onSelect: ((Data) -> ())?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pickPhoto()
    }
    
    @objc func pickPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            // Check the image size
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                let imageSize = Double(imageData.count) / 1024.0 / 1024.0 // size in MB
                if imageSize < 2 {
                    onSelect?(imageData)
                    dismiss(animated: true)
                } else {
                    // Show an alert if the image is too large
                    let alert = UIAlertController(
                        title: "Error",
                        message: "The selected image is larger than 2MB.",
                        preferredStyle: .alert
                    )
                    alert.addAction(
                        UIAlertAction(
                            title: "OK",
                            style: .default,
                            handler: nil
                        )
                    )
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
