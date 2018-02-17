//
//  MessengerPopupTableViewCell.swift
//  Gotur
//
//  Created by Sadik Ekin Ozbay on 17.02.2018.
//  Copyright © 2018 DDosJS-Attack. All rights reserved.
//

import UIKit

class MessengerPopupTableViewCell: UITableViewCell {

    lazy var viewForLabel : UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.2
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = primaryBigFont
        return label
    }()
    
    lazy var icon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(viewForLabel)
        viewForLabel.addSubview(nameLabel)
        viewForLabel.addSubview(icon)
        
        _ = viewForLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = icon.anchor(viewForLabel.topAnchor, left: viewForLabel.leftAnchor, bottom: viewForLabel.bottomAnchor, right: nil, topConstant: 6, leftConstant: 6, bottomConstant: 6, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
        _ = nameLabel.anchor(viewForLabel.topAnchor, left: icon.rightAnchor, bottom: viewForLabel.bottomAnchor, right: viewForLabel.rightAnchor, topConstant: 6, leftConstant: 6, bottomConstant: 6, rightConstant: 6, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
