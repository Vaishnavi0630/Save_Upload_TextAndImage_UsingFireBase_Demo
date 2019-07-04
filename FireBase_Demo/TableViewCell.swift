//
//  TableViewCell.swift
//  FireBase_Demo
//
//  Created by Admin on 03/07/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblProfileURL: UILabel!
    
    var chatModel: chatModel?{
        
        didSet{
            lblName.text = chatModel?.name
            lblText.text = chatModel?.text
            lblProfileURL.text = chatModel?.profileImageURL
            
            let url = URL(string: (chatModel?.profileImageURL!)!)!
            
            if let url = url as? URL{
                KingfisherManager.shared.retrieveImage(with: url as Resource, options: nil, progressBlock: nil) { (image, error, cache, imageURL) in
                    self.imgProfile.image = image
                    self.imgProfile.kf.indicatorType = .activity
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
