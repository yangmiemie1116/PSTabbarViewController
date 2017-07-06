//
//  PSTabbarViewController.swift
//  PSTabbarViewController
//
//  Created by 杨志强 on 2017/7/5.
//  Copyright © 2017年 sheep. All rights reserved.
//

import UIKit
import ObjectiveC
class PSTabbarViewController: UIViewController {
    var viewControllers:[UIViewController]! {
        willSet(controllers) {
            controllers.forEach { obj in
                var topController: UIViewController!
                if let controller = obj as? UINavigationController {
                    topController = controller.topViewController
                } else {
                    topController = obj
                }
                let normalImage = topController.psBarItem.normalImage
                let selectImage = topController.psBarItem.selectImage
                var imageView = UIImageView.init(image: normalImage, highlightedImage: selectImage)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension UIViewController {
    private struct AssociatedKeys {
        static var DescriptiveName = "nsh_DescriptiveName"
    }
    
    var psBarItem:PSTabbarItem! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveName) as! PSTabbarItem
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.DescriptiveName, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
