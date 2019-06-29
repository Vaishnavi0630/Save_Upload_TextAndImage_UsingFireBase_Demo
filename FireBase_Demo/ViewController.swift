//
//  ViewController.swift
//  FireBase_Demo
//
//  Created by Admin on 28/06/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var txtText: UITextField!
    
    @IBOutlet weak var imgView: UIImageView!
    
    let uiImagePicker = UIImagePickerController()
    
    var ref = DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        
        
        //Added geesture to img clicked
        
        let tapGuesture = UITapGestureRecognizer()
        imgView.isUserInteractionEnabled = true
        tapGuesture.addTarget(self, action: #selector(openGallery(tap:)))
        imgView.addGestureRecognizer(tapGuesture)
        
        // Do any additional setup after loading the view.
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
    
    
    @IBAction func saveClicked(_ sender: Any) {
        
        self.saveFIRData()

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

