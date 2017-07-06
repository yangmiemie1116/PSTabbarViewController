//
//  PSTabbarItem.swift
//  PSTabbarViewController
//
//  Created by 杨志强 on 2017/7/5.
//  Copyright © 2017年 sheep. All rights reserved.
//

import UIKit
class PSTabbarItem: NSObject {
    let selectImage: UIImage?
    let title: String?
    let normalImage: UIImage?
    var highlightEnable: Bool = true
    var itemWith = 80
    var itemHeight = 80
    var normalBgColor:UIColor?
    var selectBgColor:UIColor?
    init(title t:String?, normalImage n:UIImage?, selectImage s: UIImage?) {
        selectImage = s
        normalImage = n
        title = t
        super.init()
    }
}
