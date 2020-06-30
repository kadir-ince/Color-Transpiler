//
//  ViewController.swift
//  Color Transpiler
//
//  Created by kadir ince on 29.06.2020.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var redText: UITextField!
    @IBOutlet var greenText: UITextField!
    @IBOutlet var blueText: UITextField!
    @IBOutlet var showColor: UIView!
    @IBOutlet var showResultText: UILabel!
    @IBOutlet var convertButton: UIButton!
    @IBOutlet var buttonContainer: UIView!

    var currentIndex: Int8 = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        keyboardDoneButton()
        convertButtonShadow()
    }

    @IBAction func segmentSelect(_ sender: UISegmentedControl) {
        currentIndex = Int8(sender.selectedSegmentIndex)
        showColor.backgroundColor = .white
        showResultText.text = ""
        view.endEditing(true)

        if currentIndex == 0 {
            redText.text?.removeAll()
            redText.isHidden = false

            greenText.text?.removeAll()
            greenText.placeholder = "Green"
            greenText.keyboardType = .numberPad

            blueText.text?.removeAll()
            blueText.isHidden = false

        } else {
            redText.text?.removeAll()
            redText.isHidden = true

            greenText.text?.removeAll()
            greenText.placeholder = "HEX Code"

            blueText.text?.removeAll()
            blueText.isHidden = true

            greenText.keyboardType = .default
        }
    }

    private func keyboardDoneButton() {
        let numberPad: UIToolbar = UIToolbar()
        numberPad.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneClick))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(doneClick))
        let barSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        numberPad.items = [cancelButton, barSpace, doneButton]

        redText.inputAccessoryView = numberPad
        greenText.inputAccessoryView = numberPad
        blueText.inputAccessoryView = numberPad
    }

    @objc func doneClick() {
        view.endEditing(true)
    }

    @IBAction func editingTextField(_ sender: Any) {
        if currentIndex == 0 {
            maxLength(textFieldName: redText, max2: 3)
            maxLength(textFieldName: greenText, max2: 3)
            maxLength(textFieldName: blueText, max2: 3)
        } else {
            maxLength(textFieldName: redText, max2: 0)
            maxLength(textFieldName: greenText, max2: 6)
            maxLength(textFieldName: blueText, max2: 0)
        }
    }

    @IBAction func clickConvertButton(_ sender: Any) {
        if currentIndex == 0 {
            convertRgb2Hex()
        } else if currentIndex == 1 {
            if greenText.text!.count > 0 {
                ConvertHex2Rgb()
            }
        }
    }

    func maxLength(textFieldName: UITextField, max2: Int) {
        let length = textFieldName.text?.count
        if length! > max2 {
            textFieldName.deleteBackward()
        }
    }

    func convertRgb2Hex() {
        guard let redValue = UInt8(redText.text!) else { return }
        guard let greenValue = UInt8(greenText.text!) else { return }
        guard let blueValue = UInt8(blueText.text!) else { return }
        let redHex = String(format: "%2X", redValue)
        let greenHex = String(format: "%2X", greenValue)
        let blueHex = String(format: "%2X", blueValue)

        showColor.backgroundColor = UIColor(red: CGFloat(redValue) / 255, green: CGFloat(greenValue) / 255, blue: CGFloat(blueValue) / 255, alpha: 1)
        showResultText.text = "#\(redHex)\(greenHex)\(blueHex)"
    }

//    This function is get from StackoverFlow (hexStringToUIColor)
//    https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values
    func hexStringToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.count != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

       

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    func isHex(hex: String) -> Bool {
        var limit = 0
        let hexArray: [Character] = Array(greenText.text!)
        let charArray: [Character] = ["a", "b", "c", "d", "e", "f", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        for hex in hexArray {
            limit = 0

            for chars in charArray {
                if hex == chars {
                    break
                } else {
                    limit += 1
                    if limit == 16 {
                        return false
                    }
                    continue
                }
            }
        }

        if limit <= 16 {
            return true
        }
        return false
    }

    func ConvertHex2Rgb() {
        if isHex(hex: greenText.text!) {
            let start = String(Array(greenText.text!)[0...1])
            let mid = String(Array(greenText.text!)[2...3])
            let finish = String(Array(greenText.text!)[4...5])

            if let start2Hex = Int(start, radix: 16) {
                if let mid2Hex = Int(mid, radix: 16) {
                    if let finish2Hex = Int(finish, radix: 16) {
                        let color = hexStringToUIColor(hex: greenText.text!)
                        showColor.backgroundColor = color
                        showResultText.text = " RGB(\(start2Hex),\(mid2Hex),\(finish2Hex))"
                    }
                }
            }
        } else {
            showColor.backgroundColor = .white
            showResultText.text = "Please Enter Correct Format"
            greenText.text = ""
        }


    }

    @IBAction func rangeRGB(_ sender: Any) {
        isRange(textFieldName: redText)
        isRange(textFieldName: greenText)
        isRange(textFieldName: blueText)
    }

    func isRange(textFieldName: UITextField) {
        if currentIndex == 0 {
            if textFieldName.text != "" {
                let range = Int(textFieldName.text ?? "0")
                if range! < 0 || range! > 255 {
                    textFieldName.text = ""
                }
            }
        }
    }

    private func convertButtonShadow() {
        convertButton.layer.cornerRadius = 15.0
        convertButton.clipsToBounds = true
        buttonContainer.layer.shadowColor = UIColor(red: 0.37, green: 0.77, blue: 0.98, alpha: 0.85).cgColor
        buttonContainer.layer.shadowOpacity = 0.9
        buttonContainer.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        buttonContainer.layer.shadowRadius = 25.0
    }
}



extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
