//
//  CTOnboardingCustomTableViewCell.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 17/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class CTOnboardingCustomTableViewCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var cellimage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDescription: UILabel!
    
    func showHint() {
        UIView.animate(withDuration: 0.5, delay: 1, options: [.curveEaseOut], animations: {
            self.baseView.transform = CGAffineTransform(translationX: 70, y: 0)
        })
    }

}
