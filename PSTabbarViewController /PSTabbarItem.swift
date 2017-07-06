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
    let highlightEnable: Bool?
    init(title t:String?, normalImage n:UIImage?, selectImage s: UIImage?, highlightEnable h:Bool?) {
        selectImage = s
        normalImage = n
        title = t
        highlightEnable = h
        super.init()
    }
}
