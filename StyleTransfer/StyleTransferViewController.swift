//
//  StyleTransferViewController.swift
//  StyleTransfer
//
//  Created by Skafos.ai on 1/9/19.
//  Copyright © 2019 Metis Machine, LLC. All rights reserved.
//

import UIKit
import Skafos
import CoreML

class StyleTransferViewController: ViewController {
  
    private let assetName:String = "StyleTransfer"
    private var myStyleTransfer:StyleTransfer! = StyleTransfer()
    private var selectedImage: UIImage! = nil
  
    var numberOfStyles:Int = 0

    override func viewDidLoad() {
      super.viewDidLoad()
        
        // Skafos load cached asset
        // If you pass in a tag, Skafos will make a network request to fetch the asset with that tag
        Skafos.load(asset: assetName, tag: "latest") { (error, asset) in
            // Log the asset in the console
            console.info(asset)
            guard error == nil else {
                console.error("Skafos load asset error: \(String(describing: error))")
                return
            }
            guard let model = asset.model else {
                console.info("No model available in the asset")
                return
            }
            // Assign model to the myStyleTransfer class
            self.myStyleTransfer.model = model
        }
        
      if let metadata = self.myStyleTransfer.model.modelDescription.metadata[MLModelMetadataKey.creatorDefinedKey] as? [String: Any] {
        if let styles = metadata["num_styles"] as? String {
          self.numberOfStyles = Int(styles) ?? 0
        }
      }
      
      self.stylePicker.delegate = self
      self.stylePicker.dataSource = self
      self.button.addTarget(self, action: #selector(selectImageAction(_:)), for: .touchUpInside)
      self.cameraButton.addTarget(self, action: #selector(takePictureAction(_:)), for: .touchUpInside)

        /***
          Listen for changes in an asset with the given name. A notification is triggered anytime an
          asset is downloaded from the servers. This can happen in response to a push notification
          or when you manually call Skafos.load with a tag like above.         
         ***/
        NotificationCenter.default.addObserver(self, selector: #selector(StyleTransferViewController.reloadModel(_:)), name: Skafos.Notifications.assetUpdateNotification(assetName), object: nil)
    }


    @objc func reloadModel(_ notification:Notification) {
        Skafos.load(asset: assetName) { (error, asset) in
            // Log the asset in the console
            console.info(asset)
            guard error == nil else {
                console.error("Skafos load asset error: \(String(describing: error))")
                return
            }
            guard let model = asset.model else {
                console.info("No model available in the asset")
                return
            }
            // Assign model to the myStyleTransfer class
            self.myStyleTransfer.model = model
        }
    }
  
  @objc func selectImageAction(_ sender:Any? = nil) {
    let myPickerController = UIImagePickerController()
    myPickerController.delegate = self;
    myPickerController.sourceType = .photoLibrary
    self.present(myPickerController, animated: true, completion: nil)
  }
  
  @objc func takePictureAction(_ sender:Any? = nil) {
    let myPickerController = UIImagePickerController()
    myPickerController.delegate = self;
    myPickerController.sourceType = .camera
    self.present(myPickerController, animated: true, completion: nil)
  }
  
  func transferStyle(image: UIImage, styleIndex: Int) {
    
    let styleArray = try? MLMultiArray(shape: [self.numberOfStyles] as [NSNumber], dataType: MLMultiArrayDataType.double)
    
    for i in 0...((styleArray?.count)!-1) {
      styleArray?[i] = 0.0
    }
    styleArray?[styleIndex] = 1.0

    if let pixelBuffer = image.imageWithSize(scaledToSize: CGSize(width: self.imageView.frame.width, height: self.imageView.frame.height)).pixelBuffer() {
      do {
        let predictionOutput = try self.myStyleTransfer.prediction(image: pixelBuffer, index: styleArray!)
        self.imageView.image = UIImage(pixelBuffer: predictionOutput.stylizedImage)

      } catch let error as NSError {
        print("CoreML Model Error: \(error)")
      }
    }
  }
}


extension StyleTransferViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      self.selectedImage = image
      self.imageView.image = image
      let selectedStyle = self.stylePicker.selectedRow(inComponent: 0)
      if (selectedStyle > 0) {
        self.transferStyle(image: image, styleIndex: selectedStyle - 1)
      }
    }else{
      print("Something went wrong")
    }
    self.dismiss(animated: true, completion: nil)
  }
}


extension StyleTransferViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.numberOfStyles + 1
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if let image = selectedImage {
      if row == 0 {
        self.imageView.image = selectedImage
      } else {
        self.transferStyle(image: image, styleIndex: row-1)
      }
    }
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if row == 0 {
      return "Original Image"
    }
    return "Style \(row)"
  }
  
}
