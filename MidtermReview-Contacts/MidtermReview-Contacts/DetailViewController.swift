//
//  DetailViewController.swift
//  MidtermReview-Contacts
//
//  Created by Annie Tung on 12/6/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var contacts: Contacts?
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var acitivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let validContact = contacts else { return }
        let updateBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(handleUpdateBarButton))
        navigationItem.rightBarButtonItem = updateBarButtonItem
        
        let nameComponents = validContact.name.components(separatedBy: " ")
        firstNameTextField.text = nameComponents[0]
        lastNameTextField.text = nameComponents[1]
        emailTextField.text = validContact.email
        
        APIRequestManager.manager.getRequest(endPoint: validContact.avatar_url) { (data: Data?) in
            guard let validData = data else { return }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: validData)
                self.imageView.layer.cornerRadius = 50
                self.imageView.layer.masksToBounds = true
            }
        }
    }
    
    // MARK: - Action
    func handleUpdateBarButton() {
        print(123)
    }

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        view.endEditing(true)
        self.acitivityIndicator.startAnimating()
    
        guard
            let firstNameString = firstNameTextField.text, firstNameString != "",
            let lastNameString = lastNameTextField.text, lastNameString != "",
            let emailString = emailTextField.text, emailString != "" else {
                // failed to have all the fields complated
                // show an alert view
                showAlertWith(title: "Error", message: "Please enter something for each field", preferenceStyle: .alert)
                return
        }
        
        // do a post request
        APIRequestManager.manager.postRequest(firstName: firstNameString, lastName: lastNameString, email: emailString) { (response) in
            if let validResponse = response {
                DispatchQueue.main.async {
                    self.acitivityIndicator.stopAnimating()
                    
                    switch validResponse.statusCode {
                    case 200...299:
                        print("succesfully posted")
                        self.showAlertWith(title: "Success!", message: "Your contact has been saved", preferenceStyle: .actionSheet)
                    default:
                        self.showAlertWith(title: "Failed", message: "Try again", preferenceStyle: .alert)
                    }
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Alert View
    func showAlertWith(title: String, message: String, preferenceStyle: UIAlertControllerStyle) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferenceStyle)
        let action = UIAlertAction(title: "Ok", style: .cancel) { (_) in
            if alert.title == "Success!" {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
