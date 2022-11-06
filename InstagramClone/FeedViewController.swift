//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by Berke Topcu on 4.11.2022.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Cocoa Touch olarak oluşturduğumuz UITableViewCell'i Table View üzerinde göstermek için dequeueReusableCell fonksiyonunu kullanaraktan Cell'e vermiş olduğumuz id'yi veriyoruz ve bunun dosyasının FeedCell dosyası olacagını casting işlemi ile belirtiyoruz.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.userEmailLabel.text = "user@email.com"
        cell.likeLabel.text = "0"
        cell.descriptionLabel.text = "Description"
        cell.userImageView.image = UIImage(named: "image.png")
        return cell
    }
   

}
