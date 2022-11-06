//
//  FeedCell.swift
//  InstagramClone
//
//  Created by Berke Topcu on 5.11.2022.
//

import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var documentIdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func likeButtonClicked(_ sender: Any) {
        //firestore instance oluşturduk
        let fireStoreDatabase = Firestore.firestore()
    
        if let likeCount =  Int(likeLabel.text!) {
            //bir dictionary yapısı kurduk ve string any olarak casting yaptık
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            //Firestore'dan posts collection'ına ulaştık ve burdan oluşturduğumuz label'ımıza +1 değer eklettik. Merge işlemi ise diğer özelliklere dokunmadan sadece like işlemiyle çalışabilmemiz için bir güvenlik şekli diyebiliriz.
            fireStoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
        }
        
        
        
    }
    
}
