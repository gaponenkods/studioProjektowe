//
//  AuthManager.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//


import Foundation
import ReactiveCocoa
import Firebase
import FirebaseAuth

class AuthManager {    
    static let sharedInstance = AuthManager()
    
    func signalForAuthByEmail(email: String, password: String) -> SignalProducer <FIRUser, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (userSign, error) in
                if error != nil {
                    sink.sendFailed(error!)
                } else {
                    sink.sendNext(userSign!)
                    sink.sendCompleted()
                }
            })
        }
    }
    
    func signalForRegisterUserByEmail(email: String, password: String, userName: String) -> SignalProducer <FIRUser, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            FIRAuth.auth()?.createUserWithEmail(email, password: password,
                completion: { (newUser, error) in
                    if error != nil {
                        sink.sendFailed(error!)
                    }
                    
                    // save usertName
                    if let user = newUser {
                        let changeRequest = user.profileChangeRequest()
                        changeRequest.displayName = userName
                        changeRequest.commitChangesWithCompletion { errorChange in
                            if errorChange != nil {
                                sink.sendFailed(error!)
                            } else {
                                sink.sendNext(newUser!)
                                sink.sendCompleted()
                            }
                        }
                    }
            })
        }
    }
}
