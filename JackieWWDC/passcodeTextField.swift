//
//  passcodeTextField.swift
//  Prize Math
//
//  Created by Mark Eaton on 2/4/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class passcodeTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func caretRectForPosition(position: UITextPosition) -> CGRect {
        return CGRectZero
    }
}
