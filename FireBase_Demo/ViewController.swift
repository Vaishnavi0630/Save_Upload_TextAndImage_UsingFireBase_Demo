//
//  ViewController.swift
//  FireBase_Demo
//
//  Created by Vaishnavi Sasane on 28/06/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtText: UITextField!
    
    @IBOutlet weak var imgView: UIImageView!
    
    let uiImagePicker = UIImagePickerController()
    
    var ref = DatabaseReference.init()
    
    var arrData = [chatModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        
        
        //Added geesture to img clicked
        
        let tapGuesture = UITapGestureRecognizer()
        imgView.isUserInteractionEnabled = true
        tapGuesture.addTarget(self, action: #selector(openGallery(tap:)))
        imgView.addGestureRecognizer(tapGuesture)
        
        // Do any additional setup after loading the view.
        
        self.getFIRData()
    }
    
    //MARK: open gallery method
    @objc func openGallery(tap: UITapGestureRecognizer){
        
        self.setImageToImagePicker()
    }

    //MARK: save text and Image to firbase method

    func saveFIRData()  {
        
        self.uploadImage(self.imgView.image!) { url in
            
            self.saveImage(name: self.txtText.text!, profileURL: url!, completion: { sucess in
                if sucess != nil{
                    
                    print("yeah, yes")
                }
            })
            
        }
        
    }
    
    //MARK: Get all data from firebase Storage
    
    func getFIRData()  {
        self.ref.child("chat").queryOrderedByKey().observe(.value) {snapshot in
            
            self.arrData.removeAll()
            
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapShot{
                    
                    if let mainDict = snap.value as? [String: AnyObject]{
                        
                        let  name = mainDict["name"] as? String
                        
                        let text = mainDict["text"] as? String
                        
                        if  let profileURL = mainDict["profieURL"] as? String{
                            
                            self.arrData.append(chatModel(name: name!, text: text!, profileURL: profileURL))

                        }else{
                            self.arrData.append(chatModel(name: name!, text: text!, profileURL: "profileURL"))
                        }
                        
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        
        self.saveFIRData()

        self.getFIRData()
        
    }
    
    
}

//MARK: UIImagePickerControllerDelegate Methods

extension ViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func setImageToImagePicker ()  {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            
            uiImagePicker.sourceType = .savedPhotosAlbum
            uiImagePicker.delegate = self
            uiImagePicker.isEditing = true
            self.present(uiImagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imgView.image = image
        
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK: upload image and saveImage methods

extension ViewController{
    
    func uploadImage(_ image: UIImage,completion: @escaping  ((_  url: URL?) -> ())) {
        
        let storageRef = Storage.storage().reference().child("myimage.png")
        
        let imgData = imgView.image?.pngData()
        
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/png"
        
        storageRef.putData(imgData!, metadata: metaData) { (metadata, error) in
            
            if error == nil{
                
                print("sucess")
                
                storageRef.downloadURL(completion: { (url, error) in
                    
                    completion(url!)
                })
            }else{
                print("error in save image")
                completion(nil)
            }
            
        }
    }


 
    func saveImage(name: String,profileURL: URL,completion: @escaping  ((_  url: URL?) -> ()))  {
        
        let dict = ["name":"vaishnavi","text":txtText.text!,"profieURL":profileURL.absoluteString] as [String : Any]
        
        self.ref.child("chat").childByAutoId().setValue(dict)
    }
}


//MARK: tableview delegates

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        cell.chatModel = arrData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 160
    }
    
    
}

