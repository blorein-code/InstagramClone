//
//  SettingsViewController.swift
//  InstagramClone
//
//  Created by Berke Topcu on 4.11.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
       //Kullanıcıyı firebase tarafından da oturumu kapatmış gösterebilmek için bunu Auth ile gerçekleştirdik. Daha sonrasında yine perform segue yaparak view controller'a gittik. 2. Bir şekil olarak SceneDelegate üzerinde bir function oluşturup onu da buraya çekerek yapabilirdik. Ama böylesi şuan için yeterli.
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("error")
        }
       
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
