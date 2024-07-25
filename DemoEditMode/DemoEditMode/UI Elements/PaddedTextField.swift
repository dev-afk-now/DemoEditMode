//
//  PaddedTextField.swift
//  DemoEditMode
//
//  Created by Nik Dub on 24.07.2024.
//

import UIKit

open class PaddedTextField: UITextField {
    public var textInsets = UIEdgeInsets(
        top: 30,
        left: 10,
        bottom: 10,
        right: 10
    )
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
}
