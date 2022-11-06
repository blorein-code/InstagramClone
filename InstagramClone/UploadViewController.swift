//
//  UploadViewController.swift
//  InstagramClone
//
//  Created by Berke Topcu on 4.11.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardClosed))
        view.addGestureRecognizer(gestureRecognizer)
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardClosed() {
        view.endEditing(true)
    }
    
    @IBAction func uploadClicked(_ sender: Any) {
        //Firebase kullanırken storage'a ulaşabilmemizi sağlayan yapı
        let storage = Storage.storage()
        //Storage için bir referans. Referanslar sayesinde nereye kaydedileceğini belirtiyoruz.
        let storageRef = storage.reference()
        //Media dosyasının referansı oluyor.
        let mediaFolder = storageRef.child("media")
        //data isminde bir değişken oluşturup kullanıcıdan alınan fotoğrafı data'ya çevirdik ve işlemlere devam ettik
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            //fotoğraf yüklenirken unique bir uzantısı olması için uuid oluşturduk ve bu şekilde bir isimde fotoğrafı kaydettik aksi takdirde her yüklenen fotoğraf aynı isimde eklenecekti ve bir öncekine override işlemi yapacağı için sadece bir fotoğraf olacaktı veritabanında.
            let uuid = UUID().uuidString
            let imageRef = mediaFolder.child("\(uuid).jpg")
            imageRef.putData(data, metadata: nil) { metadata, error in
                //Eğer resim yükleme sırasında hata varsa
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    //Yükleme sırasında hata yoksa absolutestring işlemi resmi stringe çevirmek için.
                    imageRef.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            //DATABASE Işlemleri
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreRef : DocumentReference? = nil
                            
                            //Bir dictionary oluşturduk String:Any, içerisinde bulunmasını istediğimiz değerleri ve bu değerlerin nereden geleceğini belirttik. Daha sonrasında bu oluşturduğumuz dictionary'yi firestoreDatabase.collection("Posts").addDocument'e ilettik.
                            let firestorePost = ["imageUrl" : imageUrl, "postedBy" : Auth.auth().currentUser?.email,"postDescription" : self.descriptionField.text!, "date" : FieldValue.serverTimestamp() , "likes" : 0] as [String : Any]
                            //Fieldvalue.servetimestamp kullanıcının bu işlemi yaptıgı andaki zamanı almamızı sağlıyor.
                            //Eğer database tarafında bir collection oluşturulmadıysa önceden kendiliğinden oluşuyor. Var ise de belirtilen collection içerisine ekleniyor.
                            firestoreRef = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    //Ekleme sırasında hata meydana gelirse
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    
                                    self.imageView.image = UIImage(named: "image.png")
                                    self.descriptionField.text = ""
                                    //işlem başarıyla tamamlandığında feed = 0 ekranına gitmek için. 1 upload,2 setting ekranları
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                            
                            
                        }
                    }
                }
            }
        }
    }
    
    // Tekrar tekrar alert oluşturmamak için alert func oluşturuldu.
    func makeAlert(titleInput:String,messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
