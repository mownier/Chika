//
//  EmailValidator.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import Foundation

protocol EmailValidator: class {

    func isValid(_ email: String) -> Bool
}

class EmailValidatorProvider: EmailValidator {
    
    // Ref: http://swiftdeveloperblog.com/code-examples/validate-email-address-code-example-in-swift/
    func isValid(_ emailAddressString: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
            
        } catch {
            returnValue = false
        }
        
        return  returnValue
    }
}
