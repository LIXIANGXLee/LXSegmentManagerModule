//
//  ViewController.swift
//  LXSegmentManagerModule
//
//  Created by Mac on 2020/4/25.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
               
        
          self.view.backgroundColor = UIColor.red
         
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(TestViewController(), animated: true)
    }
    
}

