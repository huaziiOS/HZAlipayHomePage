//
//  UIViewExtention.swift
//  HZAlipayHomePage
//
//  Created by 韩兆华 on 2017/9/7.
//  Copyright © 2017年 韩兆华. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
     *
     *  描述: 加载带XIB文件方法(xib文件的名称和类名称对应)
     *
     *  @return: AnyObject类型
     *
     */
    class func loadFromNib() -> AnyObject? {
        /// 截取项目的文件名
        let classString = NSStringFromClass(object_getClass(self))
        let classRange: Range<String.Index> = classString.startIndex ..< classString.endIndex
        let range = classString.range(of: ".", options: NSString.CompareOptions.caseInsensitive, range: classRange, locale: nil)
        return self.loadFromNibNamed(classString.substring(from: (range?.upperBound)!), isKindOf: self.classForCoder())
    }
    
    /**
     *
     *  描述: 封装加载带xib文件类
     *
     *  @param1: xib的文件名称(String)
     *
     *  @param2: 类名
     *
     *  @return: AnyObject类型
     *
     */
    fileprivate class func loadFromNibNamed(_ xibName: String, isKindOf: AnyClass) -> AnyObject? {
        let array = Bundle.main.loadNibNamed(xibName, owner: nil, options: nil)
        for object in array! {
            let obj = object as AnyObject
            if obj.isKind(of: isKindOf) {
                return object as AnyObject
            }else {
                return nil
            }
        }
        return nil
    }
    
}
