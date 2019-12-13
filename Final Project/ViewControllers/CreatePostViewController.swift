//
//  CreatePostViewController.swift
//  Final Project
//
//  Created by Josh DeMoss on 12/11/19.
//  Copyright © 2019 Josh DeMoss. All rights reserved.
//
 
import UIKit
import Firebase
 
class CreatePostViewController: UIViewController {
 
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    let requestRef = Database.database().reference(withPath: "posts/requests")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        titleTextField.delegate = self
        dateTextField.delegate = self
        timeTextField.delegate = self
        descriptionTextView.delegate = self
        // Do any additional setup after loading the view.
    }
 
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func submitRequestDidTouch(_ sender: Any) {
        if titleTextField.text!.count < 1 {
             presentAlert("Invalid Title", "Title cannot be empty")
            return
        }
        if dateTextField.text!.count < 1 {
             presentAlert("Invalid Date", "Date cannot be empty")
            return
        } else if dateTextField.text!.count != 8 {
            presentAlert("Invalid Date Input", "Expected format: mm/dd/year")
            return
        }
        if timeTextField.text!.count < 1 {
             presentAlert("Invalid Time", "Time cannot be empty")
            return
        }
        if descriptionTextView.text!.count < 1 {
             presentAlert("Invalid Input", "Description cannot be empty")
            return
        }
        
        let user = Auth.auth().currentUser!
        if user.isAnonymous {
            presentAlert("Post Request Error", "Anonymous Users Cannot Create Events")
            return
        }
        
        let post = Post(title: titleTextField.text!, date: dateTextField.text!, time: timeTextField.text!, description: descriptionTextView.text!, addedByUser: user.uid)
        let postRef = requestRef.child("\(user.uid)/\(post.title)")
        
        postRef.setValue(post.toAnyObject())
        presentAlert("Submited Request", "Please wait for the SAO's response")
        titleTextField.text = ""
        dateTextField.text = ""
        timeTextField.text = ""
        descriptionTextView.text = ""
        
        
    }
    
    func presentAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
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
    
    
    
