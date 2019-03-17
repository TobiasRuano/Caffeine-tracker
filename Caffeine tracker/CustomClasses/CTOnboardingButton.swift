//
//  CTOnboardingButton.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 17/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

@IBDesignable
class CTOnboardingButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton () {
        backgroundColor     = UIColor(displayP3Red: 0, green: 122/255, blue: 255/255, alpha: 1)
        layer.cornerRadius  = 10
        
        setTitleColor(.white, for: .normal)
    }
}
