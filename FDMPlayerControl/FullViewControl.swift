//
//  FullViewControl.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/5/9.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

class FullViewControl: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {UIInterfaceOrientationMask.init(arrayLiteral: [.landscapeRight,.landscapeLeft])}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = .whites
        
        let label = UILabel()
        label.text = "啦啦啦啦"
        self.view.addSubview(label)
        label.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

}
