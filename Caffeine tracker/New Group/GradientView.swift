//
//  GradientView.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 7/7/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    private var gradientLayer = CAGradientLayer()
    private var vertical: Bool = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        
        //fill view with gradient layer
        gradientLayer.frame = self.bounds
        
        //style and insert layer if not already inserted
        if gradientLayer.superlayer == nil {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
            gradientLayer.colors = [UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor, UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0).cgColor]
            gradientLayer.locations = [0.0, 1.0]
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
