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
            for i in 0..<numberOfChoices {
                radioButtons[i].isSelected = newValue[i]
            }
        }
        get {
            return _selected
        }
    }
    
    // Store the choice string
    private var _choices = [String]()
    
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
                for i in 0..<numberOfChoices {
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
            for i in 0..<numberOfChoices {
                buttons[i].setTitleColor(textColor, for: .normal)
            }
        }
    }
    
    // The number of choices for the mutiple selections
    @IBInspectable
    public var numberOfChoices: Int = UIConstants.defaultChoicesCount {
        didSet {
            // Make sure the number of choices is between [2, 6]
            if numberOfChoices > UIConstants.maximumChoicesCount {
                numberOfChoices = UIConstants.maximumChoicesCount
            }
            if numberOfChoices < UIConstants.minimumChoicesCount {
                numberOfChoices = UIConstants.minimumChoicesCount
            }
            setNeedsDisplay()
        }
    }
    
    // The color for the button
    @IBInspectable
    public var buttonColor: UIColor = UIColor.cyan {
        didSet {
            for i in 0..<numberOfChoices {
                radioButtons[i].buttonColor = buttonColor
            }
        }
    }
    
    // The color for the border
    @IBInspectable
    public var borderColor: UIColor = UIColor.black {
        didSet {
            for i in 0..<numberOfChoices {
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
    private func setupVariables() {
        // Initialize all the selections variable with false
        // and set all the choice strings to empty
        for _ in 0..<numberOfChoices {
            _selected.append(false)
            _choices.append("aaaaaaaaaaaaaaaaaaaaaaaaaa")
        }
    }
    
    // Method to setup all the UI elements
    private func setupUI() {
        // Only add the UI elements in this method
        // and do not layout them
        for i in 0..<numberOfChoices {
            // Initialize a redio button, and set the tag for it
            let radioButton = WGRadioButton()
            radioButton.tag = i
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
        super.layoutSubviews()
        for i in 0..<numberOfChoices {
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
                for i in 0..<numberOfChoices {
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
