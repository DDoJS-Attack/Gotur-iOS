//
//  BaseButton.swift
//  Gotur
//
//  Created by Sadik Ekin Ozbay on 16.02.2018.
//  Copyright © 2018 DDosJS-Attack. All rights reserved.
//

import UIKit

class BaseButton: UIButton {
    
    init(frame: CGRect, withColor color: UIColor) {
        super.init(frame: frame)
        setupViews(withColor: color)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(withColor color: UIColor) {
        self.setTitleColor(.white, for: .normal)
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        self.backgroundColor = color
        self.titleLabel?.sizeToFit()
        self.layer.borderWidth = 0.2
        self.layer.cornerRadius = 5
        self.titleLabel?.font = primaryBigFont
        self.setTitleColor(UIColor.white , for: .normal)
        self.addShadow()
    }
}
