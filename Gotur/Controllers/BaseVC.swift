//
//  BaseVC.swift
//  Gotur
//
//  Created by Sadik Ekin Ozbay on 16.02.2018.
//  Copyright © 2018 Sadik Ekin Ozbay. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    // This is the base View Controller. It will be the parent Class of every controller.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        fetchData()
        setupViews()
        setupAnchors()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // It is responsible for creating the views
    func setupViews(){
        
    }
    
    // It is responsible for setting up the anchors
    func setupAnchors(){

    }
    
    //API works will be in this function
    func fetchData(){
 
    }

}

