//
//  CustomCardView.swift
//  RentAGRO
//
//  Created by Ouday Blouza on 06/01/2018.
//  Copyright © 2018 Blouza Ouday. All rights reserved.
//

import UIKit

    @IBDesignable  class CustomCardView: UIView {
        //Custom CardView for the Main menu

        @IBInspectable var cornerradius : CGFloat = 2
        @IBInspectable var shadowOffSetWidth : CGFloat = 0
        @IBInspectable var shadowOffSetHeight : CGFloat = 0
        @IBInspectable var shadowColor : UIColor = UIColor.black
        @IBInspectable var shadowOpacity : CGFloat = 0.5
        
        override func layoutSubviews() {
            layer.cornerRadius = cornerradius
            layer.shadowColor = shadowColor.cgColor
            layer.shadowOffset = CGSize(width: shadowOffSetWidth,height:shadowOffSetHeight)
            let shadowPath = UIBezierPath(roundedRect: bounds,cornerRadius: cornerradius)
            layer.shadowPath = shadowPath.cgPath
            layer.shadowOpacity = Float(shadowOpacity)
            
        }
    
}
