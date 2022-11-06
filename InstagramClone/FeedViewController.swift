//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by Berke Topcu on 4.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
        var userEmailArray = [String]()
        var userDescriptionArray = [String]()
        var likeArray = [Int]()
        var userImageArray = [String]()
        var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Cocoa Touch olarak oluşturduğumuz UITableViewCell'i Table View üzerinde göstermek için dequeueReusableCell fonksiyonunu kullanaraktan Cell'e vermiş olduğumuz id'yi veriyoruz ve bunun dosyasının FeedCell dosyası olacagını casting işlemi ile belirtiyoruz.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.descriptionLabel.text = userDescriptionArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        //Kullanıcının görmeyeceği hidden şekilde bir label tanımlayıp feed cell üzerine koyduğumuz label'a buradan ulaşıp like sayısını arttıracağız. Bu işlemi hangi like butonuna tıklandığını anlayabilmek için yaptık.
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    
    
    func getDataFromFirestore() {
            //firesore instance oluşturduk.
            let fireStoreDatabase = Firestore.firestore()
            //oluşturduğumuz instance ile veritabanında bulunan Posts kategorisine ulaştık ve bu kategoriyle iletişim kurabilmemiz için bir addSnapshotListener ekledik. addSnapshotListener bize snapshot ve error döndü.
                //orderby date : tarihe göre sıralamak için, descending de azalan şekilde sıralamayı sağlıyor .  
            fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
                if error != nil {
                    //Eğer hata varsa sistem hata mesajı döndük.
                    print(error?.localizedDescription)
                } else {
                    //Eğer hata yoksa snapshot'tan veri gelmiş mi kontrolü yaptık
                    if snapshot?.isEmpty != true && snapshot != nil {
                        
                        //Oluşturmuş olduğumuz arraylerin içini boşalttık bu sayede anasayfa sürekli yeni verilerle güncellenirken eski veriler çift çift tekrar ekrana gelmesin.
                        self.userImageArray.removeAll(keepingCapacity: false)
                        self.userEmailArray.removeAll(keepingCapacity: false)
                        self.userDescriptionArray.removeAll(keepingCapacity: false)
                        self.likeArray.removeAll(keepingCapacity: false)
                        self.documentIdArray.removeAll(keepingCapacity: false)
                        
                        
                        //Snapshot'ı bir loop'a aldık ve verileri yazdırdık.
                        for document in snapshot!.documents {
                            let documentID = document.documentID
                            //paylaşımlara documentID eklendi.
                            self.documentIdArray.append(documentID)
                            
                            if let postedBy = document.get("postedBy") as? String {
                                self.userEmailArray.append(postedBy)
                            }
                            
                            if let postComment = document.get("postDescription") as? String {
                                self.userDescriptionArray.append(postComment)
                            }
                            
                            if let likes = document.get("likes") as? Int {
                                self.likeArray.append(likes)
                            }
                            
                            if let imageUrl = document.get("imageUrl") as? String {
                                self.userImageArray.append(imageUrl)
                            }
                            
                            
                        }
                        //TableView'u güncelledik.
                        self.tableView.reloadData()
                        
                    }
                    
                    
                }
            }
            
            
            
            
        }
    
    
   

}
