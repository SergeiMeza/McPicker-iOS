//
//  McPicker.swift
//  Pods
//
//  Created by Kevin McGill on 3/22/17.
//
//

import UIKit

open class McPicker: UIView {
    
    fileprivate var pickerSelection:String = ""
    
    fileprivate var pickerData:[String:Any] = [:]
    
    fileprivate var numberOfComponents:Int {
        get {
            if let numOfComponents = pickerData["numberOfComponents"] as? Int {
                return numOfComponents
            }
            return 1
        }
    }
    
    fileprivate var displayData:[String] {
        get {
            if let strings = pickerData["displayData"] as? [String] {
                return strings
            }
            return []
        }
    }
    
    fileprivate var picker:UIPickerView = UIPickerView()
    fileprivate var toolbar:UIToolbar = UIToolbar()
    
    private let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                                target: self,
                                                action: #selector(done))
    
    private let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                  target: self,
                                                  action: #selector(cancel))
    
    private let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)
    
    private var topViewController:UIViewController {
        get {
            return UIApplication.topViewController()!
        }
    }
    
    private let toolBarHeight:CGFloat = 44.0
    private var doneHandler:(_ word:String) -> Void = {_ in }
    private var cancelHandler:() -> Void = {_ in }

    
    convenience public init(pickerData:[String:Any]) {
        self.init(frame: CGRect.zero)
        
        self.pickerData = pickerData

        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancel)))

        setToolbarItems(items: [cancelBarButton, flexibleSpace, doneBarButton])

        picker.backgroundColor = UIColor.red
        toolbar.backgroundColor = UIColor.blue
        self.backgroundColor = UIColor.black
        self.alpha = 0.75
        
        picker.delegate = self
        picker.dataSource = self
        
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: self.topViewController.view.bounds.size.width,
                            height: self.topViewController.view.bounds.size.height)
        picker.frame = CGRect(x: 0,
                              y: self.bounds.size.height - self.picker.bounds.size.height,
                              width: self.bounds.size.width,
                              height: self.picker.bounds.size.height)        
        toolbar.frame = CGRect(x: 0,
                               y: self.bounds.size.height - picker.bounds.size.height - toolBarHeight,
                               width: self.bounds.size.width,
                               height: toolBarHeight)
        
        // Default selection to first item
        //
        if let firstItem = displayData.first {
            pickerSelection = firstItem
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }


    open func show(cancelHandler:@escaping () -> Void, doneHandler:@escaping (_ word:String) -> Void){
        
        self.doneHandler = doneHandler
        self.cancelHandler = cancelHandler
        
        self.addSubview(picker)
        self.addSubview(toolbar)
        topViewController.view.addSubview(self)
    }
    
    open class func show(cancelHandler:@escaping () -> Void, doneHandler:@escaping (_ word:String) -> Void) {
        // TODO: implement
    }
    
    open func setToolbarItems(items: [UIBarButtonItem]) {
        toolbar.items = items
    }
    
    func done() {
        self.doneHandler(self.pickerSelection)
        self.removeFromSuperview()
    }
    
    func cancel() {
        self.cancelHandler()
        self.removeFromSuperview()
    }
}


extension McPicker : UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.numberOfComponents
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.displayData.count
    }
}


extension McPicker : UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.displayData[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerSelection = self.displayData[row]
    }
}


extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
