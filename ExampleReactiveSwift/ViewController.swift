//
//  ViewController.swift
//  ExampleReactiveSwift
//
//  Created by Iván Alejandro Moya Quilodrán on 10-05-17.
//  Copyright © 2017 Iván Alejandro Moya Quilodrán. All rights reserved.
//

import UIKit
import Foundation
import FormValidatorSwift
import Result
import ReactiveCocoa
import ReactiveSwift

class ViewController: UIViewController {


    @IBOutlet weak var lastNametTextField: ReactiveValidateTextField!
    @IBOutlet weak var firstNameTextField: ReactiveValidateTextField!
    @IBOutlet weak var emailTextField: ReactiveValidateTextField!
    @IBOutlet weak var registerButton: UIButton!
            //     let emailCondition = EmailValidator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let validUserNameSignal = self.firstNameTextField.signalReactiveTextField(typeCondition: .JLConditionTypeAlphabetic)
        let lastNameFieldSignal = self.lastNametTextField.signalReactiveTextField(typeCondition: .JLConditionTypeAlphabetic)
        let emailFiedlSignal = self.emailTextField.signalReactiveTextField(typeCondition: .JLConditionTypeEmail)
        
        
        _ =  Signal.combineLatest(validUserNameSignal,lastNameFieldSignal ,emailFiedlSignal)
            .map({ (firstName,lastName,email) -> Bool in
                
                print("\(firstName) \(lastName) \(email)")
                
                return  firstName && email && lastName})
            .observeResult({ (response) in
                self.registerButton.isEnabled = response.value!})
            .flatMap { (disponseResult) -> Bool? in
                self.registerButton.isEnabled = disponseResult.isDisposed
            return disponseResult.isDisposed

        }
        
//
//
//        signalDisposable.observeValues { (enable) in
//            print("\(enable)")
//            
//            self.registerButton.isEnabled = enable
//            
//
//        }
        
        
//        SignalProducer.combineLatest(validUserNameSignal, lastNameFieldSignal, emailFiedlSignal)
//        
//        let formValidation =
//            SignalProducer(validUserNameSignal.combineLatest(with: lastNameFieldSignal).combineLatest(with: emailFiedlSignal))
//                .map({ (userName, lastName, email) -> Bool in
//                    return userName && lastName && email
//                })
//                .prefix(value: false)
//        
//        formValidation.startWithValues {
//            print($0)
//            
//
//        }
        
        //        emailTextField.validatorTextFieldViolatedConditions([emailValidation as! Condition])
        
        
//        let validResult = emailCondition.checkConditions(emailTextField.text)
//        emailTextField.reactive.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

