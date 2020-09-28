//
//  cardsDataModel.swift
//  TinderStack
//
//  Created by Osama Naeem on 16/03/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import UIKit

struct CardsDataModel {
    var text: String
    var image: ImageType
    enum ImageType {
        case uiimage(image: UIImage)
        case photoURL(url: URL)
    }
      
    init(text: String, imageType: ImageType) {
        self.text = text
        self.image = imageType
    
    }
}


