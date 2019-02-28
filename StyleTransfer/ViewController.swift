//
//  ViewController.swift
//  StyleTransfer
//
//  Created by Skafos.ai on 1/9/19.
//  Copyright © 2019 Metis Machine, LLC. All rights reserved.
//

import Foundation
import UIKit
import Skafos
import CoreML
import SnapKit


class ViewController: UIViewController {
  
  lazy var label:UILabel = {
    let label           = UILabel()
    label.text          = "Stylize Image"
    label.font          = label.font.withSize(30)
    label.textAlignment = .center
    self.view.addSubview(label)
    return label
  }()
  
  lazy var about:UILabel = {
    let label           = UILabel()
    label.text          = "This model allows you to select a style from the style transfer model and apply it to your image.  The model was built using https://github.com/skafos/TuriStyleTransfer"
    label.textAlignment = .center
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 4
    label.font          = label.font.withSize(13)
    label.adjustsFontSizeToFitWidth = true
    label.adjustsFontForContentSizeCategory = true
    self.view.addSubview(label)
    return label
  }()
  
  lazy var button:UIButton = {
    let button        = UIButton(type: .custom)
    button.backgroundColor = .blue
    
    button.setTitle("Select Image", for: .normal)
    button.setTitleColor(.white, for: .normal)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(button)
    return button
  }()
  
  lazy var cameraButton:UIButton = {
    let button        = UIButton(type: .custom)
    button.backgroundColor = .blue
    
    button.setTitle("Take Picture", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(button)
    return button
  }()
  
  lazy var imageView:UIImageView = {
    let imageView           = UIImageView()
    imageView.contentMode = .scaleAspectFit
    self.view.addSubview(imageView)
    return imageView
  }()
  
  lazy var errLabel:UILabel = {
    let label           = UILabel()
    label.textAlignment = .center
    label.textColor     = .red
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    
    self.view.addSubview(label)
    return label
  }()
  
  
  lazy var chooseLabel:UILabel = {
    let label           = UILabel()
    label.textAlignment = .center
    label.textColor     = .black
    label.text          = "Selected Style"
    
    self.view.addSubview(label)
    return label
  }()
  
  lazy var stylePicker: UIPickerView = {
    let picker = UIPickerView()
    picker.showsSelectionIndicator = true
    self.view.addSubview(picker)
    return picker
  }()


  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
  }
  
  override func viewDidLayoutSubviews() {

    label.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(30)
      make.right.left.equalToSuperview().inset(10)
      make.height.equalTo(35)
    }

    about.snp.makeConstraints { make in
      make.top.equalTo(label.snp.bottom).offset(20)
      make.right.left.equalToSuperview().inset(10)
    }
    
    button.snp.makeConstraints { make in
      make.top.equalTo(about.snp.bottom).offset(10)
      make.left.equalTo(label)
      make.right.equalTo(self.view.snp.centerX)
      make.height.equalTo(40)
    }
    
    cameraButton.snp.makeConstraints { make in
      make.top.equalTo(about.snp.bottom).offset(10)
      make.left.equalTo(button.snp.right).offset(10)
      make.right.equalTo(label)
      make.height.equalTo(40)
    }
    
    imageView.snp.makeConstraints { make in
      make.top.equalTo(button.snp.bottom).offset(10)
      make.right.left.equalToSuperview().inset(10)
      make.bottom.lessThanOrEqualTo(chooseLabel.snp.top)
    }

    stylePicker.snp.makeConstraints { make in
      make.bottom.equalToSuperview().inset(10)
      make.right.left.equalTo(label)
      make.height.equalTo(100)
    }
    
    chooseLabel.snp.makeConstraints { make in
      make.bottom.equalTo(stylePicker.snp.top).offset(5)
      make.right.left.equalTo(label)
    }
    
    errLabel.snp.makeConstraints { make in
      make.top.equalTo(chooseLabel.snp.bottom).offset(10)
      make.right.left.equalTo(label)
    }
    

  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
