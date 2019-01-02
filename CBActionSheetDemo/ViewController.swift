//
//  ViewController.swift
//  CBActionSheetDemo
//
//  Created by Creater on 2018/10/8.
//  Copyright © 2018年 Creative Bomb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showActionSheet(_ sender: Any) {
        CBActionSheet.show(onView: self.view, title: "请选择图片", cancelButtonTitle: "取消", destructiveButtonTitle: "删除", otherButtonTitles: ["1","2","3"]) { (idx) in
            print("选中\(idx)")
        }
    }
    
}

