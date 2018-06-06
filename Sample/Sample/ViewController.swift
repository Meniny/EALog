//
//  ViewController.swift
//  Sample
//
//  Created by 李二狗 on 2018/6/6.
//  Copyright © 2018年 Meniny Lab. All rights reserved.
//

import UIKit
import EALog

class FakeFormatter: EALogFormatter {
    let level: EALoggingLevel
    init(_ l: EALoggingLevel = .verbose) {
        level = l
    }
    
    var counter: UInt = 0
    
    func log(_ type: EALoggingLevel, msg: [Any?], functionName: String, lineNum: Int, fileName: String) {
        counter += 1
        print("Fake Log Here, Yay! [NO.\(counter)]")
    }
    
    func isLogging(_ level: EALoggingLevel) -> Bool {
        return level.rawValue >= self.level.rawValue
    }
}

class ViewController: UIViewController {
    
    let formatter = FakeFormatter.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        EALog.info(self.view)
        
        EALog.formatter = formatter
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        EALog.info(touches, event)
    }
}

