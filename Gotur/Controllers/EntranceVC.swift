//
//  EntranceVC.swift
//  Gotur
//
//  Created by Sadik Ekin Ozbay on 16.02.2018.
//  Copyright © 2018 DDosJS-Attack. All rights reserved.
//

import UIKit

class EntranceVC: BaseVC {
    
    // this VC is basicly for selecting if you are messenger or normal user
    lazy var normalUser: BaseButton = {
        let view = BaseButton(frame: CGRect(), withColor: UIColor(red: 81/255, green: 68/255, blue: 191/255, alpha: 1.0))
        view.setTitle(signInUser, for: .normal)
        view.addTarget(self, action: #selector(goToUserPacketsVC), for: .touchUpInside)
        return view
    }()
    
    lazy var messengerUser: BaseButton = {
        let view = BaseButton(frame: CGRect(), withColor: UIColor(red: 95/255, green: 153/255, blue: 90/255, alpha: 1.0))
        view.setTitle(signInCourier, for: .normal)
        view.addTarget(self, action: #selector(goToMessengerVC), for: .touchUpInside)
        return view
    }()
    
    override func setupAnchors() {
        _ = normalUser.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: self.view.frame.height/2-84, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 72)
        _ = messengerUser.anchor(nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: self.view.frame.height/2-84, rightConstant: 24, widthConstant: 0, heightConstant: 72)
    }
    
    override func setupViews() {
        self.view.addSubview(normalUser)
        self.view.addSubview(messengerUser)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = .white
    }
    
    func goToMessengerVC() {
        let messenger = MessengerVC()
        present(messenger, animated: true, completion: nil)
    }
    
    func goToUserPacketsVC(){
        let userPackets = UserPacketsVC()
        present(userPackets, animated: true, completion: nil)
    }
    

}
