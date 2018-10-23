//
//  News.swift
//  Ouday_Blouza_APP
//
//  Created by Ouday Blouza on 23/10/2018.
//  Copyright © 2018 Ouday Blouza. All rights reserved.
//

import Foundation
// News Entity with news attribute
class News : Decodable {
    var newsId: Int?
    var newsTitle: String?
    var newsSubTitle: String?
    var newsOriImage: String?
    var newsThumbImage: String?
    var newsShortDesc: String?
    var newsBody: String?
    var newsCat: String?
    var newsUrl: String?
    

}
