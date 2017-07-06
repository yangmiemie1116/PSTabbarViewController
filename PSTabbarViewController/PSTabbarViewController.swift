//
//  PSTabbarViewController.swift
//  PSTabbarViewController
//
//  Created by 杨志强 on 2017/7/5.
//  Copyright © 2017年 sheep. All rights reserved.
//

import UIKit
import ObjectiveC
import SnapKit

/// tabbar 点击事件回调
protocol PSTabBarControllerDelegate {
    func didSelectTab(_ controller:UIViewController!, _ index:Int) -> Void
}

class PSTabbarViewController: UIViewController {
    var delegate:PSTabBarControllerDelegate?
    var selectIndex: Int = 0
    /// tabbarcontroller backgroundcolor
    var bgColor:UIColor?
    /// item 字体正常属性
    var normalAttributes:[String:Any]?
    /// item 字体高亮属性
    var highlightAttributes:[String:Any]?
    ///布局tabbar
    lazy var stackView:UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 0
        return stack
    }()
    ///tabbar controllers
    var viewControllers:[UIViewController]! {
        willSet(controllers) {
            self.view.addSubview(stackView)
            stackView.snp.makeConstraints { (make)->Void in
                make.left.equalTo(self.view);
                make.top.equalTo(self.view).offset(20);
                make.width.equalTo(80);
                make.height.equalTo(80 * controllers.count);
            }
            controllers.forEach { obj in
                let idx = controllers.index(of: obj)
                var topController: UIViewController!
                if let controller = obj as? UINavigationController {
                    topController = controller.topViewController
                } else {
                    topController = obj
                }
                if idx == self.selectIndex  {
                    self.view.addSubview(obj.view)
                    self.addChildViewController(obj)
                }
                
                let baseView: UIView = UIView()
                stackView.addArrangedSubview(baseView)
                let centerView: UIView = UIView()
                baseView.addSubview(centerView)
                centerView.snp.makeConstraints({ make in
                    make.center.equalTo(baseView);
                })
                
                let normalImage = topController.psBarItem.normalImage
                let selectImage = topController.psBarItem.selectImage
                let imageView = UIImageView.init(image: normalImage, highlightedImage: selectImage)
                centerView.addSubview(imageView)
                imageView.snp.makeConstraints({ make in
                    make.top.equalTo(centerView);
                    make.size.equalTo((normalImage?.size)!);
                    make.centerX.equalTo(centerView);
                })
                
                let titleLab: UILabel?
                let title:String? = topController.psBarItem.title
                if (title?.characters.count)! > 0 {
                    titleLab = UILabel()
                    let attrText = NSMutableAttributedString(string: title!)
                    if idx == self.selectIndex {
                        attrText.addAttributes(self.highlightAttributes!, range: NSRange(location: 0, length: (title?.characters.count)!))
                    } else {
                        attrText.addAttributes(self.normalAttributes!, range: NSRange(location: 0, length: (title?.characters.count)!))
                    }
                    titleLab!.attributedText = attrText
                    centerView.addSubview(titleLab!)
                    titleLab!.snp.makeConstraints({ make in
                        make.top.equalTo(imageView.snp.bottom).offset(10);
                        make.bottom.equalTo(centerView)
                        make.centerX.equalTo(centerView)
                    })
                    
                } else {
                    imageView.snp.makeConstraints{$0.bottom.equalTo(centerView)}
                }
                if idx == self.selectIndex {
                    baseView.backgroundColor = topController.psBarItem.selectBgColor
                    imageView.isHighlighted = true
                    if !topController.psBarItem.highlightEnable {
                        baseView.backgroundColor = UIColor.clear
                    }
                } else {
                    baseView.backgroundColor = topController.psBarItem.normalBgColor
                    imageView.isHighlighted = false
                }
                
                let tapGes = UITapGestureRecognizer(target: self, action: #selector(gestureAction(_:)))
                baseView.addGestureRecognizer(tapGes)
            }
        }
    }
    
    func gestureAction(_ ges:UIGestureRecognizer) -> Void {
        let index = self.stackView.arrangedSubviews.index(of: ges.view!)
        self.selectItemAt(index!)
    }
    
    func setTitleTextAttributes(attribute:[String:Any], state:UIControlState) -> Void {
        switch state {
        case UIControlState.normal:
            normalAttributes = attribute
            break
        case UIControlState.highlighted:
            highlightAttributes = attribute
            break
        case UIControlState.selected:
            highlightAttributes = attribute
            break
        default:
            break
        }
    }
    
    func selectItemAt(_ index:Int) -> Void {
        self.selectIndex = index
        self.childViewControllers.forEach { controller in
            controller.willMove(toParentViewController: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
        }
        var topController:UIViewController?
        let currentController = viewControllers[index]
        if let top = currentController as? UINavigationController {
            topController = top.viewControllers.first
        } else {
            topController = currentController
        }
        delegate?.didSelectTab(currentController, index)
        self.view.addSubview(currentController.view)
        self.addChildViewController(currentController)
        currentController.didMove(toParentViewController: self)
        
        self.stackView.arrangedSubviews.forEach { arrangeView in
            let idx = self.stackView.arrangedSubviews.index(of: arrangeView)
            if idx == index {
                arrangeView.backgroundColor = topController!.psBarItem.selectBgColor
                if topController!.psBarItem.highlightEnable {
                    arrangeView.backgroundColor = UIColor.clear
                }
            } else {
                arrangeView.backgroundColor = topController!.psBarItem.normalBgColor
            }
            let itemViews = arrangeView.subviews.first?.subviews
            itemViews?.forEach({ item in
                if let iv = item as? UIImageView {
                    if idx == index {
                        iv.isHighlighted = true
                    } else {
                        iv.isHighlighted = false
                    }
                } else if let lab = item as? UILabel {
                    let attrText = NSMutableAttributedString(string: lab.text!)
                    if idx == index {
                        attrText.addAttributes(self.highlightAttributes!, range: NSRange(location: 0, length: (lab.text?.characters.count)!))
                    } else {
                        attrText.addAttributes(self.normalAttributes!, range: NSRange(location: 0, length: (lab.text?.characters.count)!))
                    }
                    lab.attributedText = attrText
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = self.bgColor
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
