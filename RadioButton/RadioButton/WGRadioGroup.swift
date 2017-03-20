//
//  WGRadioButton.swift
//  RadioButton
//
//  Created by Siyang Liu on 17/3/16.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

import UIKit

@IBDesignable
class WGRadioGroup: UIView {
    
    // Constants for the drawing relations
    private struct UIConstants {
        // The margin for width and height
        static let marginWidthHeight: CGFloat = 5
        // The width and height for radio button
        static let radioButtonWidthHeight: CGFloat = 20
        // The preferred body font
        static let preferredBodyFont = UIFont.preferredFont(forTextStyle: .body)
        // The minimum number of choices
        static let minimumChoicesCount = 2
        // The maximum number of choices
        static let maximumChoicesCount = 6
        // The default value for the number of choices
        static let defaultChoicesCount = 4
    }
    
    // Array to record which buttons are selected
    private var _selected = [Bool]()
    
    // The external access of the _selected
    public var selected: [Bool] {
        set {
            _selected = newValue
            // Change the selected status of the radio button
            for i in 0..<_numberOfChoices {
                radioButtons[i].isSelected = newValue[i]
            }
        }
        get {
            return _selected
        }
    }
        
    // Store the choice string
    private var _choices = [String]()
    
    // The external access of the _choices
    public var choices: [String] {
        set {
            // Resetup the variables
            setupVariables(withChoices: newValue)
            // Resetup the UI
            setupUI()
            // Relayout the UI
            // 很神奇，他会自动帮你调用
//            setNeedsLayout()
        }
        get {
            return _choices
        }
    }

    // Store the radio buttons
    private var radioButtons = [WGRadioButton]()
    
    // Store the buttons that contain the text
    private var buttons = [UIButton]()
    
    // Whether or not the multiple selection is allowed
    @IBInspectable
    public var allowsMutipleSelection: Bool = false {
        didSet {
            if !allowsMutipleSelection {
                // If it does not support multiple selections,
                // just delect all of it except the first selection
                var firstSelectionFound = false
                var tempSelected = _selected
                for i in 0..<_numberOfChoices {
                    if tempSelected[i] {
                        if !firstSelectionFound {
                            // This one ramins true, and just set the flag to true
                            firstSelectionFound = true
                        } else {
                            // Set any else true to false
                            tempSelected[i] = false
                        }
                    }
                }
                // Let the selected property to handle the rest of it
                selected = tempSelected
            }
        }
    }
    
    // The color for the text
    @IBInspectable
    public var textColor: UIColor = UIColor.black {
        didSet {
            for i in 0..<_numberOfChoices {
                buttons[i].setTitleColor(textColor, for: .normal)
            }
        }
    }
    
    // The number of choices for the mutiple selections
    private var _numberOfChoices: Int = UIConstants.defaultChoicesCount
    
    // The external access of the _numberOfChoices
    @IBInspectable
    public var numberOfChoices: Int {
        set {
            let oldValue = _numberOfChoices
            // Make sure the number of choices is between [min, max]
            if newValue > UIConstants.maximumChoicesCount {
                _numberOfChoices = UIConstants.maximumChoicesCount
            } else if newValue < UIConstants.minimumChoicesCount {
                _numberOfChoices = UIConstants.minimumChoicesCount
            } else {
                _numberOfChoices = newValue
            }
            // Adjust the UI and other properties for the according to the choice count change
            if _numberOfChoices > oldValue {
                addChoices(by: _numberOfChoices - oldValue)
                // Resetup the UI
                setupUI()
                // Relayout the UI
                // 很神奇，他会自动帮你调用
//                setNeedsLayout()
            }
            if _numberOfChoices < oldValue {
                reduceChoices(by: oldValue - _numberOfChoices)
                // Resetup the UI
                setupUI()
                // Relayout the UI
                // 很神奇，他会自动帮你调用
//                setNeedsLayout()
            }
        }
        get {
            return _numberOfChoices
        }
    }
    
    // The color for the button
    @IBInspectable
    public var buttonColor: UIColor = UIColor.cyan {
        didSet {
            for i in 0..<_numberOfChoices {
                radioButtons[i].buttonColor = buttonColor
            }
        }
    }
    
    // The color for the border
    @IBInspectable
    public var borderColor: UIColor = UIColor.black {
        didSet {
            for i in 0..<_numberOfChoices {
                radioButtons[i].borderColor = borderColor
            }
        }
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setupVariables()
//        setupUI()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVariables()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupVariables()
        setupUI()
    }
    
    // Method to initialize all the variables
    // This is called when the radio group is first created
    private func setupVariables() {
        // Initialize all the selections variable with false
        // and set all the choice strings to empty
        for _ in 0..<_numberOfChoices {
            _selected.append(false)
            _choices.append("")
        }
    }
    
    // Method to add the choice count
    private func addChoices(by number: Int) {
        for _ in 0..<number {
            _selected.append(false)
            _choices.append("")
        }
    }
    
    // Method to reduce the choice count
    private func reduceChoices(by number: Int) {
        for _ in 0..<number {
            _selected.removeLast()
            _choices.removeLast()
        }
    }
    
    // Method to initialize all the variables
    // This is called when the chioices has been changed
    private func setupVariables(withChoices choices: [String]) {
        print(#function)
        _choices = choices
        // Make sure the number of choices is between [min, max]
        // If it is smaller than the minimum value, just append empty string at last
        if _choices.count < UIConstants.minimumChoicesCount {
            for _ in _choices.count..<UIConstants.minimumChoicesCount {
                _choices.append("")
            }
        }
        // If it is greater than the maximum value, just remove the extra choices from the end
        if _choices.count > UIConstants.maximumChoicesCount {
            for _ in UIConstants.maximumChoicesCount..<_choices.count {
                _choices.removeLast()
            }
        }
        // Get the current number of choices
        _numberOfChoices = _choices.count
        // Reset all the selections variable with false
        _selected.removeAll()
        for _ in 0..<_numberOfChoices {
            _selected.append(false)
        }
    }
    
    // Method to setup all the UI elements
    private func setupUI() {
        print(#function)
        // Clearn the subviews from the super view
        for button in radioButtons {
            button.removeFromSuperview()
        }
        for button in buttons {
            button.removeFromSuperview()
        }
        // Clear all the radio buttons and buttons
        radioButtons.removeAll()
        buttons.removeAll()

        // Only add the UI elements in this method
        // and do not layout them
        for i in 0..<_numberOfChoices {
            // Initialize a redio button, and set the tag for it
            let radioButton = WGRadioButton()
            radioButton.tag = i
            // Set if the radio button is selected
            radioButton.isSelected = _selected[i]
            // Set the inner and outer color for the radio button
            radioButton.borderColor = borderColor
            radioButton.buttonColor = buttonColor
            // Add the target action for the radio button
            radioButton.addTarget(self, action: #selector(handleSelection(button:)), for: .touchUpInside)
            // Store the radio button in the array
            radioButtons.append(radioButton)
            // Then add it to the view
            addSubview(radioButton)
            // Initialize a button, and set the tag for it
            let button = UIButton(type: .custom)
            // Set the title and font for the button
            button.setTitle(_choices[i], for: .normal)
            button.titleLabel?.font = UIConstants.preferredBodyFont
            // Set the text color for the button
            button.setTitleColor(textColor, for: .normal)
            // Set the button to show multiple lines
            button.titleLabel?.numberOfLines = 0
            button.tag = i
            // Add the target action for the button
            button.addTarget(self, action: #selector(handleSelection(button:)), for: .touchUpInside)
            buttons.append(button)
            // Then add it to the view
            addSubview(button)
        }
    }
    
    override func layoutSubviews() {
        print(#function)
        super.layoutSubviews()
        for i in 0..<_numberOfChoices {
            // Calculate the frame for the button
            // The origin x for the button
            let buttonX = UIConstants.marginWidthHeight * 2 + UIConstants.radioButtonWidthHeight
            // The origin y for the button
            let buttonY = i == 0 ? UIConstants.marginWidthHeight : buttons[i - 1].frame.origin.y + buttons[i - 1].frame.size.height + UIConstants.marginWidthHeight
            // The width for the button
            let width = frame.width - buttonX - UIConstants.marginWidthHeight
            // The height for the button
            let attributeDictionary = [NSFontAttributeName: UIConstants.preferredBodyFont]
            let height = (_choices[i] as NSString).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: attributeDictionary, context: nil).height
            buttons[i].frame = CGRect(x: buttonX, y: buttonY, width: width, height: height)
            // Calculate the frame for the radio button
            // the center Y of it should be the same as the corresponding button
            let radioButtonX = UIConstants.marginWidthHeight
            let radioButtonY = buttons[i].center.y - UIConstants.radioButtonWidthHeight / 2
//            let origin = CGPoint(x: UIConstants.marginWidthHeight, y: (UIConstants.marginWidthHeight + UIConstants.radioButtonWidthHeight) * CGFloat(i) + UIConstants.marginWidthHeight)
            let size = CGSize(width: UIConstants.radioButtonWidthHeight, height: UIConstants.radioButtonWidthHeight)
            radioButtons[i].frame = CGRect(origin: CGPoint(x: radioButtonX, y: radioButtonY), size: size)
        }
    }
    
    // Method to hand the selection for the radio buttons and buttons
    @objc private func handleSelection(button: Any?) {
        // Check to see if the button is clicked
        if let button = button as? UIControl {
            let selectedIndex = button.tag
            // Change the value of selction recorder
            if allowsMutipleSelection {
                selected[selectedIndex] = !selected[selectedIndex]
            } else {
                var tempSelected = _selected
                // Just allow one to be selected
                // and check for the index to be the selected index
                for i in 0..<_numberOfChoices {
                    if i == selectedIndex {
                        tempSelected[i] = true
                    } else {
                        tempSelected[i] = false
                    }
                }
                selected = tempSelected
            }
        }
    }
    

}
