//
//  ReactiveValidateTextField.swift
//  ExampleReactiveSwift
//
//  Created by Iván Alejandro Moya Quilodrán on 12-05-17.
//  Copyright © 2017 Iván Alejandro Moya Quilodrán. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

enum JLConditionType {
    case JLConditionTypeAlphabetic
    case JLConditionTypeEmail
    case JLConditionTypeAlphaNumeric
}

@IBDesignable
class ReactiveValidateTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var minCharacter: NSInteger = 0
    @IBInspectable var maxCharacter: NSInteger = 0
    
    @IBInspectable var backgroundError: UIColor?
    @IBInspectable var backgroundDefault: UIColor?


    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = self.backgroundDefault
        
    }
    
    public func signalReactiveTextField(typeCondition: JLConditionType) -> Signal<Bool,NoError>{
        
        let condition = ValidateConditions()
        
        var signalWithCondition:Signal<Bool,NoError>
        
        switch typeCondition {
            
        case .JLConditionTypeAlphabetic:
            signalWithCondition = self
                .reactive
                .continuousTextValues
                .skipNil()
                .map({ (textAlphabetic) -> Bool in
                  
                    if self.maxCharacter > 0{
                        return  condition.isAlphabetic(textString: textAlphabetic) && textAlphabetic.characters.count > self.minCharacter && textAlphabetic.characters.count < self.maxCharacter
                    }else{
                        return condition.isAlphabetic(textString: textAlphabetic) && textAlphabetic.characters.count > self.minCharacter
                    }
                })

        case .JLConditionTypeEmail:
            
            signalWithCondition = self
                .reactive
                .continuousTextValues
                .skipNil()
                .map({ (textEmail) -> Bool in
                    
                    if self.maxCharacter > 0{
                        return  condition.isValidEmailAddress(emailAddressString: textEmail) && textEmail.characters.count > self.minCharacter && textEmail.characters.count < self.maxCharacter
                    }else{
                        return  condition.isValidEmailAddress(emailAddressString: textEmail) && textEmail.characters.count > self.minCharacter
                    }

                })
        
        case .JLConditionTypeAlphaNumeric:
            
            signalWithCondition = self
                .reactive
                .continuousTextValues
                .skipNil()
                .map({ (textAlphabetic) -> Bool in
                    
                    if self.maxCharacter > 0{
                        return  condition.isAlphaNumeric(textString: textAlphabetic) && textAlphabetic.characters.count > self.minCharacter && textAlphabetic.characters.count < self.maxCharacter
                    }else{
                        return condition.isAlphaNumeric(textString: textAlphabetic) && textAlphabetic.characters.count > self.minCharacter
                    }
                })
     
        }
    
        
        signalWithCondition.observeResult { (response) in
            print("value result \(response)")
            self.findTextState(response: response.value!)
        }
        
        return signalWithCondition
    
    }
    
    
    func findTextState(response : Bool) {
        if response{
            self.backgroundColor = self.backgroundDefault
        }else{
            self.backgroundColor = self.backgroundError
        }
        
    }

}
