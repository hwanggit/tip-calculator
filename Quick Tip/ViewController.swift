//
//  ViewController.swift
//  Quick Tip
//
//  Created by Luhao Wang on 1/18/20.
//  Copyright © 2020 Luhao Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIApplicationDelegate {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var priceInput: UITextField!
    @IBOutlet weak var tipInput: UITextField!
    @IBOutlet weak var equalsSign: UILabel!
    @IBOutlet weak var plusSign: UILabel!
    @IBOutlet weak var postTip: UILabel!
    @IBOutlet weak var tipMode: UISegmentedControl!
    @IBOutlet weak var tipView: UIView!
    
    var tipModePercentage: NSNumber?
    let screenSize:CGRect = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        // Prevent dark mode
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        appDelegate.blockRotation = true

        // Initialize input box style
        priceInput.keyboardType = .numberPad
        priceInput.attributedPlaceholder = NSAttributedString(string: "$",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        // Initialize input box style
        tipInput.keyboardType = .numberPad

        // Put view offset on right
        let rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: tipInput.frame.height))
        tipInput.rightView  = rightView
        tipInput.rightViewMode = .always

        // Disable user interaction if not custom
        if tipMode.selectedSegmentIndex != 3 {
            tipInput.isUserInteractionEnabled = false
        }

        // Initialize tap recognizer, and add to view
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(didTapScreen(sender:)))
        
        let tapPrice = UITapGestureRecognizer(target: self, action: #selector(didTapPrice(sender:)))
        
        let tapTip = UITapGestureRecognizer(target: self, action: #selector(didTapTip(sender:)))
        
        // Add tap handlers to view
        view.addGestureRecognizer(tapScreen)
        priceInput.addGestureRecognizer(tapPrice)
        tipInput.addGestureRecognizer(tapTip)
        
        // Listen to keyboard open
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        // Listen for text field input change
        priceInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        // Hide options display and calculations
        tipView.isHidden = true
        
        // Hide mode segment
        tipMode.isHidden = true
    }
    
    // Change mode based on segment
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch tipMode.selectedSegmentIndex {
        case 0:
            tipModePercentage = 0
            tipInput.isUserInteractionEnabled = false
            tipInput.attributedPlaceholder = NSAttributedString(string: "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            revertView()
            
        case 1:
            tipModePercentage = 10
            tipInput.isUserInteractionEnabled = false
            tipInput.attributedPlaceholder = NSAttributedString(string: "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            revertView()
            
        case 2:
            tipModePercentage = 15
            tipInput.isUserInteractionEnabled = false
            tipInput.attributedPlaceholder = NSAttributedString(string: "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            revertView()

        default:
            tipModePercentage = nil
            tipInput.isUserInteractionEnabled = true
            tipInput.becomeFirstResponder()
            tipInput.layer.cornerRadius = 10.0
            tipInput.attributedPlaceholder = NSAttributedString(string: "$",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        }
    }
    
    // Close keyboard on tap
    @objc func didTapScreen(sender: UITapGestureRecognizer) {
        revertView()
    }
    
    // Revert view to normal
    func revertView() {
        view.endEditing(true)
        
        // Make view return to normal
        view.frame = CGRect(x:0, y:0, width: screenSize.width, height: screenSize.height)
    }
    
    // Make view height shrink on tap
    @objc func didTapPrice(sender: UITapGestureRecognizer) {
        // Open keyboard
        priceInput.becomeFirstResponder()
    }
    
    // Make view height shrink on tap
    @objc func didTapTip(sender: UITapGestureRecognizer) {
        // Open keyboard
        tipInput.becomeFirstResponder()
    }
    
    // Set the shouldAutorotate to False
    override open var shouldAutorotate: Bool {
       return false
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
    }
    
    // Handle keyboard showing method
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            // Adjust view size
            view.frame = CGRect(x:0, y:0, width: screenSize.width, height: screenSize.height - keyboardHeight)
        }
    }
    
    // When textfield changes, hide/show options view
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Check if text field empty or not
        guard let text = textField.text, !text.isEmpty else {
            tipMode.isHidden = true
            tipView.isHidden = true
            return
        }
        
        tipMode.isHidden = false
        tipView.isHidden = false
        
        // Move textField up
        priceInput.frame.origin.y -= 100.0
    }
}

