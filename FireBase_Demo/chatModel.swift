//
//  chatModel.swift
//  FireBase_Demo
//
//  Created by Admin on 03/07/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit

class chatModel {
    
    var name: String?
    var text: String?
    var profileImageURL: String?
    
    init(name: String,text: String,profileURL: String) {
        
        self.name = name
        self.text = text
        self.profileImageURL = profileURL
    }
    
    
    
}
