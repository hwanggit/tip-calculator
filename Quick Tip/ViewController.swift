//
//  ViewController.swift
//  Quick Tip
//
//  Created by Luhao Wang on 1/18/20.
//  Copyright © 2020 Luhao Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIApplicationDelegate {
    
    // IB Outlets
    @IBOutlet weak var priceInput: UITextField!
    @IBOutlet weak var tipInput: UITextField!
    @IBOutlet weak var equalsSign: UILabel!
    @IBOutlet weak var plusSign: UILabel!
    @IBOutlet weak var postTip: UILabel!
    @IBOutlet weak var tipMode: UISegmentedControl!
    @IBOutlet weak var tipView: UIView!
    
    // Global vars
    var tipModePercentage: String?
    let screenSize:CGRect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prevent dark mode
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        // Initialize input box style
        priceInput.keyboardType = .decimalPad
        priceInput.attributedPlaceholder = NSAttributedString(string: "$",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        // Initialize input box style
        tipInput.keyboardType = .decimalPad
        
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
        priceInput.addTarget(self, action: #selector(priceFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        tipInput.addTarget(self, action: #selector(tipFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        // Hide options display and calculations
        tipView.isHidden = true
        
        // Hide mode segment
        tipMode.isHidden = true
        
        // Register default settings, and listen for changes
        registerSettingsBundle()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        defaultsChanged()
        
        // Listen for app into background
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    // Set tip mode percentage when view appears
    override func viewDidAppear(_ animated: Bool) {
        // Open keyboard
        priceInput.becomeFirstResponder()

        // Set tip percentage
        switch tipMode.selectedSegmentIndex {
        case 0:
            tipModePercentage = "0"
        case 1:
            tipModePercentage = "10"
        case 2:
            tipModePercentage = "15"
        default:
            tipModePercentage = nil
        }
    }
    
    // Close keyboard when backgrounded
    @objc func appMovedToBackground() {
        revertView()
    }
    
    // Get settings defaults
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    // Detect when default values change
    @objc func defaultsChanged(){
        // Get current color theme
        guard let checkTheme = UserDefaults.standard.string(forKey: "color_themes") else {
            return
        }

        let colorPick = Int(UserDefaults.standard.string(forKey: "color_themes")!)!
        
        // Change color theme depending on settings
        switch colorPick {
        case 0:
            navigationController?.navigationBar.barTintColor = UIColor.systemRed
            tipMode.layer.backgroundColor = UIColor.systemRed.cgColor
            tipView.backgroundColor = UIColor.systemRed
            tipInput.backgroundColor = UIColor.systemRed
        case 2:
            navigationController?.navigationBar.barTintColor = UIColor.systemBlue
            tipMode.layer.backgroundColor = UIColor.systemBlue.cgColor
            tipView.backgroundColor = UIColor.systemBlue
            tipInput.backgroundColor = UIColor.systemBlue
        default:
            navigationController?.navigationBar.barTintColor = UIColor.systemYellow
            tipMode.layer.backgroundColor = UIColor.systemYellow.cgColor
            tipView.backgroundColor = UIColor.systemYellow
            tipInput.backgroundColor = UIColor.systemYellow
        }
    }
    
    // Deallocate from memory
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Change mode based on segment
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch tipMode.selectedSegmentIndex {
        case 0:
            tipModePercentage = "0"
            tipInput.isUserInteractionEnabled = false
            tipInput.attributedPlaceholder = NSAttributedString(string: "",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            priceInput.becomeFirstResponder()
        case 1:
            tipModePercentage = "10"
            tipInput.isUserInteractionEnabled = false
            tipInput.attributedPlaceholder = NSAttributedString(string: "",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            priceInput.becomeFirstResponder()
            
        case 2:
            tipModePercentage = "15"
            tipInput.isUserInteractionEnabled = false
            tipInput.attributedPlaceholder = NSAttributedString(string: "",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            priceInput.becomeFirstResponder()
            
        default:
            tipModePercentage = nil
            tipInput.isUserInteractionEnabled = true
            tipInput.becomeFirstResponder()
            tipInput.layer.cornerRadius = 10.0
            tipInput.attributedPlaceholder = NSAttributedString(string: "$",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            tipInput.text = ""
        }
        
        // Set tip and total after segment change
        setTipAndTotal()
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
    @objc func priceFieldDidChange(_ textField: UITextField) {
        // Check if text field empty or not
        guard let text = textField.text, !text.isEmpty, !text.starts(with: ".") else {
            tipMode.isHidden = true
            tipView.isHidden = true
            return
        }
        
        tipMode.isHidden = false
        tipView.isHidden = false
        setTipAndTotal()
    }
    
    // When textfield changes, hide/show options view
    @objc func tipFieldDidChange(_ textField: UITextField) {
        // Set custom tip and total
        setCustomTip(textField)
    }
    
    // set current price
    func setTipAndTotal() {
        // Get current price and calculate total
        if let price = priceInput.text {
            if let tipPercent = tipModePercentage {
                // Calculate total price from tip
                let total = (1.0 + Double(tipPercent)! / 100.0) * Double(price)!
                postTip.text = String(format: "%.2f", total)
                
                // Calculate tip
                let tip = (Double(tipPercent)! / 100.0) * Double(price)!
                tipInput.text = String(format: "%.2f", tip)
            }
            else {
                // Set total to current price if custom
                postTip.text = String(format: "%.2f", Double(price)!)
            }
        } else {
            postTip.text = "0.00"
        }
    }
    
    // Set custom tip
    func setCustomTip(_ customTipField: UITextField) {
        // Get current price and calculate total
        if let price = priceInput.text {
            // Check if text field empty or not
            guard let text = customTipField.text, !text.isEmpty, !text.starts(with: ".") else {
                // If custom tip is empty, revert to original price
                postTip.text = String(format: "%.2f", Double(price)!)
                return
            }
            
            // Get custom tip and set total
            let totalCustom = Double(text)! + Double(price)!
            postTip.text = String(format: "%.2f", totalCustom)
        } else {
            postTip.text = "0.00"
        }
    }
}

// Prevent screen rotate
extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }
}
