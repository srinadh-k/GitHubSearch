//
//  LoginVC.swift
//  T-Mobile
//
//  Created by Srinadh on 4/10/20.
//  Copyright © 2020 Srinadh. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var passwordTxtFld: UITextField?
    @IBOutlet weak var emailTxtFld: UITextField?
    @IBOutlet weak var spinner: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        //logoImgVW.layer.masksToBounds = true
           // logoImgVW.layer.cornerRadius = logoImgVW.bounds.width / 2
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
                self.navigationController?.navigationBar.isHidden = true
        emailTxtFld?.text = ""
        passwordTxtFld?.text = ""
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        guard let email = emailTxtFld?.text, !email.isEmpty else {
            self.showAlert(message: "Please enter your Email")
            return
        }
        guard let password = passwordTxtFld?.text, !password.isEmpty else{
            self.showAlert(message: "Please enter your Password")
            return
        }
        spinner?.startAnimating()
        emailTxtFld?.isEnabled = false
        passwordTxtFld?.isEnabled = false
    
        UserAuth.shared.userEmail = email
        UserAuth.shared.userPassword = password
        APIClient.shared.fetchData(urlStr: "https://api.github.com/authorizations") { (result) in
            self.emailTxtFld?.isEnabled = true
            self.passwordTxtFld?.isEnabled = true
            self.spinner?.stopAnimating()
            switch result{
            case .failure (let msg):
                self.showAlert(message: msg.localizedDescription)
                break
            case .success(let data) :
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let _ = json as? [Any]{
                        self.navigationController?.navigationBar.isHidden = false 
                        self.performSegue(withIdentifier: "userSegue", sender: nil)
                    }
                    else if let dict = json as? [String: Any], let msg = dict["message"] as? String{
                        self.showAlert(message: msg)
                    }
                    
                }
                catch{
                }
                
            }
        }
        
    }
    
    func alertDisplay(alertMessage:String?){
        let alert = UIAlertController(title: "GitHub", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    // MARK: - TextField Delegate Methods
    
  
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LoginVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          if textField == emailTxtFld{
            passwordTxtFld?.becomeFirstResponder()
          }else if textField == passwordTxtFld{
              loginButtonAction("")
          }
          return true
      }
}
