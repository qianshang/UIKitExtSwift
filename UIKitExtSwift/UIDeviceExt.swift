//
//  UIDeviceExt.swift
//  UIKitExtSwift
//
//  Created by mac on 2018/4/20.
//

import Foundation

public enum DeviceType {
    case Simulator
    
    case iPhone
    case iPhone3G
    case iPhone3GS
    case iPhone4
    case iPhone4S
    case iPhone5
    case iPhone5c
    case iPhone5s
    case iPhone6
    case iPhone6P
    case iPhone6s
    case iPhone6sP
    case iPhoneSE
    case iPhone7
    case iPhone7P
    case iPhone8
    case iPhone8P
    case iPhoneX
    case iPhoneXr
    case iPhoneXs
    case iPhoneXsMax
    
    case iPod
    case iPod2
    case iPod3
    case iPod4
    case iPod5
    case iPod6
    
    case iPad
    case iPad2
    case iPad3
    case iPad4
    case iPad5
    case iPad6
    case iPadAir
    case iPadAir2
    case iPadPro_12_9
    case iPadPro_9_7
    case iPadPro2_12_9
    case iPadPro_10_5
    
    case iPadMini
    case iPadMini2
    case iPadMini3
    case iPadMini4
    
    case unKnown
}

extension UIKitExt where Base: UIDevice {
    public var deviceType: DeviceType {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machine = Mirror(reflecting: systemInfo.machine)
        let identifier = machine.children.reduce("") { id, element in
            guard let value = element.value as? Int8, value != 0 else { return id }
            return id + String(UnicodeScalar(UInt8(value)))
        }
        return getDeviceType(with: identifier)
    }
    
    public var isX: Bool {
        switch deviceType {
        case .iPhoneX, .iPhoneXr, .iPhoneXs, .iPhoneXsMax:
            return true
        default:
            return false
        }
    }
}


fileprivate func getDeviceType(with identifier: String) -> DeviceType {
    switch identifier {
    case "i386", "x86_64":
        return .Simulator
        
    case "iPhone1,1":
        return .iPhone
    case "iPhone1,2":
        return .iPhone3G
    case "iPhone2,1":
        return .iPhone3GS
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":
        return .iPhone4
    case "iPhone4,1":
        return .iPhone4S
    case "iPhone5,1", "iPhone5,2":
        return .iPhone5
    case "iPhone5,3", "iPhone5,4":
        return .iPhone5c
    case "iPhone6,1", "iPhone6,2":
        return .iPhone5s
    case "iPhone7,2":
        return .iPhone6
    case "iPhone7,1":
        return .iPhone6P
    case "iPhone8,1":
        return .iPhone6s
    case "iPhone8,2":
        return .iPhone6sP
    case "iPhone8,4":
        return .iPhoneSE
    case "iPhone9,1", "iPhone9,3":
        return .iPhone7
    case "iPhone9,2", "iPhone9,4":
        return .iPhone7P
    case "iPhone10,1", "iPhone10,4":
        return .iPhone8
    case "iPhone10,2", "iPhone10,5":
        return .iPhone8P
    case "iPhone10,3", "iPhone10,6":
        return .iPhoneX
    case "iPhone11,8":
        return .iPhoneXr
    case "iPhone11,2":
        return .iPhoneXs
    case "iPhone11,6":
        return .iPhoneXsMax
        
    case "iPod1,1":
        return .iPod
    case "iPod2,1":
        return .iPod2
    case "iPod3,1":
        return .iPod3
    case "iPod4,1":
        return .iPod4
    case "iPod5,1":
        return .iPod5
    case "iPod7,1":
        return .iPod6
        
    case "iPad1,1":
        return .iPad
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
        return .iPad2
    case "iPad3,1", "iPad3,2", "iPad3,3":
        return .iPad3
    case "iPad3,4", "iPad3,5", "iPad3,6":
        return .iPad4
    case "iPad4,1", "iPad4,2", "iPad4,3":
        return .iPadAir
    case "iPad5,3", "iPad5,4":
        return .iPadAir2
    case "iPad6,3", "iPad6,4":
        return .iPadPro_9_7
    case "iPad6,7", "iPad6,8":
        return .iPadPro_12_9
    case "iPad6,11", "iPad6,12":
        return .iPad5
    case "iPad7,1", "iPad7,2":
        return .iPadPro2_12_9
    case "iPad7,3", "iPad7,4":
        return .iPadPro_10_5
    case "iPad7,5", "iPad7,6":
        return .iPad6
        
    case "iPad2,5", "iPad2,6", "iPad2,7":
        return .iPadMini
    case "iPad4,4", "iPad4,5", "iPad4,6":
        return .iPadMini2
    case "iPad4,7", "iPad4,8", "iPad4,9":
        return .iPadMini3
    case "iPad5,1", "iPad5,2":
        return .iPadMini4
        
    default :
        return .unKnown
    }
}

