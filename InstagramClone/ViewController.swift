//
//  ViewController.swift
//  InstagramClone
//
//  Created by Berke Topcu on 4.11.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardClosed))
        view.addGestureRecognizer(gestureRecognizer)
    }


    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                //Error mesajı var mı kontrolü yaptık eğer yoksa yani kullanıcı veritabanında kayıtlı ve bilgiler doğruysa giriş yapacak değilse Error dönecek.
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
        }
        
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        //Auth sınıfından auth objesi oluşturmak gibi. Bunun sayesinde kullanıcı oluşturuyoruz.
        //Üyelik işlemlerinden önce kullanıcı adı ve şifre alanları boş mu kontrolü yaptık
        if emailText.text != "" && passwordText.text != "" {
            //Kullanıcı adı ve şifre inputları boş değilse veritabanında böyle bir k
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                //Hata var mı kontrolü yaptık.
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    //Eğer hata yoksa kullanıcıyı uygulamaya giriş yaptıracağımız için perform segue yaptık
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            //Üyelik işlemlerinden önce kullanıcı adı ve şifre bölümü boş ise kullanıcıya bir alert gösterdik.
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
            
        }
        
        
    }
    
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        self.present(alert, animated: true, completion: nil)
        alert.addAction(button)
    }
    
    @objc func keyboardClosed() {
        view.endEditing(true)
    }
}

