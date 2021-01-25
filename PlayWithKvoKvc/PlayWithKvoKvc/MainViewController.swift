//
//  MainViewController.swift
//  PlayWithKvoKvc
//
//  Created by denis2 on 11.01.2021.
//

import UIKit

class Person: NSObject {
    @objc dynamic var inputText: String = ""
    
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myTextField: UITextField!
    
    @objc let person: Person = Person()
    var textFieldObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textFieldObservation = observe(\MainViewController.person.inputText, options: [.new, .old]) { (vc, change) in
            guard let newValue = change.newValue else {return}
            
            vc.myLabel.text = newValue
            
        }
    }
    
    @IBAction func textFieldEditChange(_ sender: Any) {
        print("text field edit")
        person.inputText = myTextField.text ?? ""
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
