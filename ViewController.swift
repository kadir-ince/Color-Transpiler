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

    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        keyboardDoneButton()
    }

    @IBAction func segmentClick(_ sender: UISegmentedControl) {}

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
        maxLength(textFieldName: redText, max2: 3)
        maxLength(textFieldName: greenText, max2: 3)
        maxLength(textFieldName: blueText, max2: 3)
    }

    func maxLength(textFieldName: UITextField, max2: Int) {
        let length = textFieldName.text?.count
        if length! > max2 {
            textFieldName.deleteBackward()
        }
    }

    @IBAction func rangeRGB(_ sender: Any) {
        isRange(textFieldName: redText)
        isRange(textFieldName: greenText)
        isRange(textFieldName: blueText)
    }

    func isRange(textFieldName: UITextField) {
        if textFieldName.text != "" {
            let range = Int(textFieldName.text ?? "0")
            print(String(range!))
            if range! < 0 || range! > 255 {
                textFieldName.text = ""
            }
        }
    }
}
