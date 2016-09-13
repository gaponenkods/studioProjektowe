//
//  Utils.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

func base64StringFromImage(image: UIImage) -> String {
    var data: NSData = NSData()
    data = UIImageJPEGRepresentation(image, 0.1)!
    let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    return base64String
}

func formatDate(date: NSDate) -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    let dateString = dateFormatter.stringFromDate(date)
    return dateString
}

func router() -> RouterManager {
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    return delegate.router!
}

func stringIsValidEmail(checkString: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(checkString)
}

func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
        SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
    }
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
}


struct Converter {
    
    //Make Sring
    
    static func daySringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(date)
    }
    
    static func sringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.stringFromDate(date)
    }
    
    static func prettySringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy MMM dd"
        
        return dateFormatter.stringFromDate(date)
    }
    
    static func fullHoursInDate(date: NSDate) -> Int? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "H"
        
        return Int(dateFormatter.stringFromDate(date))
    }
    
    //Make date
    
    static func dateFromString(string: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.dateFromString(string)
    }
    
    static func dateFromDayString(string: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.dateFromString(string)
    }
    
    static func dateWithParams(hours: Int, minutes: Int, seconds: Int, byDay: NSDate) -> NSDate? {
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian);
        calendar?.timeZone = (NSTimeZone.localTimeZone())
        
        let unitFlags: NSCalendarUnit = [.Day, .Month, .Year]
        
        let dateComponents = calendar?.components(unitFlags, fromDate: NSDate());
        dateComponents?.hour = hours
        dateComponents?.minute = minutes
        dateComponents?.second = seconds
        
        //return date relative from date
        return calendar?.dateFromComponents(dateComponents!)
    }
    
    static func convertToHeightUsingFeet(feet: Int, inches: Int) -> Int {
        return (feet * 12 + inches)
    }
    
    static func convertToFeetInchUseHeight(height: Int) -> (feet: Int, inches: Int) {
        if height > 0 {
            let feet = Int(height / 12)
            let inches = height % 12
            
            return (feet, inches)
        }
        return (0, 0)
    }
}