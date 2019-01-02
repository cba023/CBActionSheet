//
//  CBActionSheet.swift
//  CBActionSheetDemo
//
//  Created by Creater on 2018/10/8.
//  Copyright © 2018年 Creative Bomb. All rights reserved.
//

import UIKit

typealias ActionSheetSelectedCallback = (_ selectedIdx:Int) -> Void
let TITLE_FONT = UIFont.systemFont(ofSize: 15.0)
let BUTTON_HEIGHT:CGFloat = 44.0
let SCREEN_SIZE = UIScreen.main.bounds.size
let SCREEN_BOUNDS = CGRect(origin: CGPoint(x: 0, y: 0), size: SCREEN_SIZE)
let BOTTOM_MARGIN: CGFloat = UIApplication.shared.statusBarFrame.size.height >= 44.0 ? 34.0 : 2.0

class CBActionSheet: UIView {
    var actionSheetSelectedCallback: ActionSheetSelectedCallback?
    var title: String!
    var cancelButtonTitle: String!
    var destructiveButtonTitle: String!
    var titleArray: Array<String>!
    var contentView: UIView!
    var darkShadowView: UIView!
    
    
    init(title: String?, cancelButtonTitle: String?, destructiveButtonTitle: String?, otherButtonTitles: Array<String>?) {
        super.init(frame: SCREEN_BOUNDS)
        self.title = title
        self.cancelButtonTitle = cancelButtonTitle
        self.destructiveButtonTitle = destructiveButtonTitle
        self.titleArray = Array()
        if ((otherButtonTitles?.count) != nil) {
            for item in otherButtonTitles! {
                self.titleArray.append(item)
            }
        }
        if (self.destructiveButtonTitle?.count) != nil {
            self.titleArray.append(destructiveButtonTitle!)
        }
        self.configSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getLabelHeight(labelStr: String, font: UIFont, width: CGFloat) -> CGFloat {
        let statusLabelText = labelStr
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context: nil).size
        return strSize.height
    }
    
    func getTitleHeight() -> CGFloat {
        return self.getLabelHeight(labelStr: title, font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.bold), width: SCREEN_SIZE.width - 60.0) + 25.0
    }

    func configSubViews() {
        self.frame = SCREEN_BOUNDS
        self.darkShadowView = UIView(frame: SCREEN_BOUNDS)
        self.darkShadowView.backgroundColor = UIColor(white: 0.2, alpha: 1)
        self.darkShadowView.alpha = 0
        self.addSubview(self.darkShadowView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEvent))
        self.darkShadowView.addGestureRecognizer(tap)
        self.contentView = UIView()
        self.contentView.backgroundColor = UIColor(white: 0.8, alpha: 1)
        self.addSubview(self.contentView)
        if self.title != nil && self.title!.count > 0 {
            let titleBackView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: self.getTitleHeight()))
            titleBackView.backgroundColor = UIColor.white
            self.contentView.addSubview(titleBackView)
            let titleLabel = UILabel(frame: CGRect(x: 30.0, y: 0, width: SCREEN_BOUNDS.width - 60.0, height: self.getTitleHeight()))
            titleLabel.text = title
            titleLabel.numberOfLines = 0
            titleLabel.textColor = UIColor(white: 0.2, alpha: 1)
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.bold)
            titleLabel.backgroundColor = UIColor.white
            contentView.addSubview(titleLabel)
            
            let line = UIView()
            line.backgroundColor = UIColor(red:230/255.0, green:235/255.0, blue:240/255.0, alpha: 1)
            line.frame = CGRect(x: 0, y: titleLabel.frame.origin.y + titleLabel.frame.size.height - 2, width: SCREEN_BOUNDS.width, height: 2)
            self.contentView.addSubview(line)
        }
        
        for (idx, _) in titleArray.enumerated() {
            let button = UIButton.init(type: .custom)
            button.tag = idx + 100
            button.setTitle(self.titleArray[idx], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            button.setTitleColor(UIColor(white: 0.2, alpha: 1), for: .normal)
            if (idx == self.titleArray.count - 1) && self.destructiveButtonTitle != nil && self.destructiveButtonTitle.count > 0 {
                button.setTitleColor(UIColor.red, for: .normal)
            }
            button.setBackgroundImage(self.createImageWithColor(color: .white), for: .normal)
            button.setBackgroundImage(self.createImageWithColor(color: UIColor(red:243/255.0, green:243/255.0, blue:243/255.0, alpha: 1)), for: .highlighted)
            button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
//            let buttonY = BUTTON_HEIGHT * (CGFloat(idx) + (self.title != nil && self.title.count > 0 ? 1 : 0))
            var buttonY = BUTTON_HEIGHT * CGFloat(idx)
            if (self.title != nil) && self.title.count > 0 {
                buttonY = BUTTON_HEIGHT * CGFloat(idx) + self.getTitleHeight()
            }
            button.frame = CGRect(x: 0, y: buttonY, width: SCREEN_BOUNDS.width, height: BUTTON_HEIGHT - 0.5)
            self.contentView.addSubview(button)
            
            let line = UIView()
            line.backgroundColor = UIColor(red:230/255.0, green:235/255.0, blue:240/255.0, alpha: 1)
            line.frame = CGRect(x: 0, y: buttonY + BUTTON_HEIGHT - 0.5, width: SCREEN_BOUNDS.width, height: 0.5)
            self.contentView.addSubview(line)
        }
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.tag = -1
        cancelButton.setTitle(self.cancelButtonTitle, for: .normal)
        cancelButton.titleLabel?.font = TITLE_FONT
        cancelButton.setTitleColor(UIColor(white: 0.2, alpha: 1), for: .normal)
        cancelButton.setBackgroundImage(self.createImageWithColor(color: UIColor.white), for: .normal)
        cancelButton.setBackgroundImage(self.createImageWithColor(color: UIColor(red:243/255.0, green:243/255.0, blue:243/255.0, alpha: 1)), for: .highlighted)
        cancelButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        
//        let buttonY = BUTTON_HEIGHT * (CGFloat(self.titleArray.count) + (self.title != nil && self.title.count > 0 ? 1: 0)) + 10
        var buttonY = BUTTON_HEIGHT * CGFloat(self.titleArray.count) + 10.0
        if (self.title != nil) && self.title.count > 0 {
            buttonY = BUTTON_HEIGHT * CGFloat(self.titleArray.count) + 10.0 + self.getTitleHeight()
        }
        cancelButton.frame = CGRect(x: 0, y: buttonY, width: SCREEN_BOUNDS.width, height: BUTTON_HEIGHT)
        self.contentView.addSubview(cancelButton)
        
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.9)
        view.frame = CGRect(x: 0, y: buttonY - 10 - 0.5, width: SCREEN_BOUNDS.width, height: 10 + 0.5)
        self.contentView.addSubview(view)
//        BUTTON_HEIGHT * (CGFloat(self.titleArray.count) + 1.0 + (title != nil && title.count > 0 ? 1 : 0)) + 10 + BOTTOM_MARGIN
        var height = BUTTON_HEIGHT * CGFloat(self.titleArray.count) + 11.0 + BOTTOM_MARGIN
        if (self.title != nil) && self.title.count > 0 {
            height = BUTTON_HEIGHT * (CGFloat(self.titleArray.count) + 1) + 11.0 + BOTTOM_MARGIN + self.getTitleHeight()
        }
        self.contentView.frame = CGRect(x: 0, y: SCREEN_BOUNDS.height, width: SCREEN_BOUNDS.width, height: height)
    }
    
    func show(onView view: UIView) {
        view.endEditing(true)
        view.window?.addSubview(self)
        showSheet()
    }
    
    func showSheet() {
        UIView.animate(withDuration: 0.3) {
            var frame = self.contentView.frame
            frame.origin.y = self.frame.size.height - self.contentView.frame.size.height
            self.contentView.frame = frame
            var shadowViewFrame = self.darkShadowView.frame
            shadowViewFrame.size.height = self.frame.size.height - self.contentView.frame.size.height
            self.darkShadowView.frame = shadowViewFrame
            self.darkShadowView.alpha = 0.5
        }
    }
    
    static func show(onView view: UIView?, itemArray: Array<String>?, selectedHandler:ActionSheetSelectedCallback?) {
        guard view != nil else {
            return
        }
        let actionSheet = CBActionSheet(title: nil, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: itemArray)
        actionSheet.actionSheetSelectedCallback = selectedHandler
        actionSheet.show(onView: view!)
        return
    }
    
    static func show(onView view: UIView?, title: String, cancelButtonTitle: String, destructiveButtonTitle: String, otherButtonTitles:Array<String>?, selectedHandler: @escaping ActionSheetSelectedCallback) {
        guard view == nil else {
            let actionSheet = CBActionSheet(title: title, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: destructiveButtonTitle, otherButtonTitles: otherButtonTitles)
            actionSheet.actionSheetSelectedCallback = selectedHandler
            actionSheet.show(onView: view!)
            return
        }
    }
    
    func hideSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            var frame = self.contentView.frame
            frame.origin.y = self.frame.size.height
            self.contentView.frame = frame
            self.darkShadowView.frame = self.frame
            self.darkShadowView.alpha = 0
            var shadowViewFrame = self.darkShadowView.frame
            shadowViewFrame.size.height = self.frame.size.height
        }) {(finished) in
            self.removeFromSuperview()
        }
    }
    
    @objc func btnClick(btn: UIButton) {
        let tagNum = btn.tag
        if (self.actionSheetSelectedCallback != nil) && tagNum != 1 {
            self.actionSheetSelectedCallback!(tagNum - 100)
        }
        self.hideSheet()
    }
    
    @objc func tapEvent() {
        self.hideSheet()
    }
    
    func createImageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
