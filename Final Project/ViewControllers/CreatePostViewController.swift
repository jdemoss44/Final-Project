//
//  CreatePostViewController.swift
//  Final Project
//
//  Created by user157827 on 12/12/19.
//  Copyright © 2019 Josh DeMoss. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
    
    
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        dateTextField.delegate = self
        timeTextField.delegate = self
        descriptionTextView.delegate = self
            
        

        // Do any additional setup after loading the view.
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
    

extension CreatePostViewController : UITextFieldDelegate{
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case titleTextField:
            titleTextField.resignFirstResponder()
        case dateTextField:
            dateTextField.resignFirstResponder()
        case timeTextField:
            timeTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}

extension CreatePostViewController : UITextViewDelegate{
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        descriptionTextView.resignFirstResponder()
    }
}
    
    
    
