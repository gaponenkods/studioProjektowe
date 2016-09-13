//
//  UIKitExtensions.swift
//  ReactiveTwitterSearch
//
//  Created by Colin Eberhardt on 10/05/2015.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

struct AssociationKey {
  static var hidden: UInt8 = 1
  static var alpha: UInt8 = 2
  static var text: UInt8 = 3
  static var enabled: UInt8 = 4
  static var secureTextEntry: UInt8 = 5
  static var textTextView: UInt8 = 6
}

// lazily creates a gettable associated property via the given factory
func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, key: UnsafePointer<Void>, factory: ()->T) -> T {
  return objc_getAssociatedObject(host, key) as? T ?? {
    let associatedProperty = factory()
    objc_setAssociatedObject(host, key, associatedProperty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    return associatedProperty
  }()
}

func lazyMutableProperty<T>(host: AnyObject, key: UnsafePointer<Void>, setter: T -> (), getter: () -> T) -> MutableProperty<T> {
  return lazyAssociatedProperty(host, key: key) {
    let property = MutableProperty<T>(getter())
    property.producer
        .startWithNext{
            newValue in
            setter(newValue)
      }
    
    return property
  }
}

extension UIView {
  public var rac_alpha: MutableProperty<CGFloat> {
    return lazyMutableProperty(self, key: &AssociationKey.alpha, setter: { self.alpha = $0 }, getter: { self.alpha  })
  }
  
  public var rac_hidden: MutableProperty<Bool> {
    return lazyMutableProperty(self, key: &AssociationKey.hidden, setter: { self.hidden = $0 }, getter: { self.hidden  })
  }
}

extension UIButton {
    public var rac_enabled: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.enabled, setter: { self.enabled = $0 }, getter: { self.enabled  })
    }
    public var rac_buttonTouchUpInside: RACSignal {
        return self.rac_signalForControlEvents(.TouchUpInside)
    }
}

extension UILabel {
  public var rac_text: MutableProperty<String> {
    return lazyMutableProperty(self, key: &AssociationKey.text, setter: { self.text = $0 }, getter: { self.text ?? "" })
  }
}

extension UITextField {
  public var rac_text: MutableProperty<String> {
    return lazyAssociatedProperty(self, key: &AssociationKey.text) {
      
      self.addTarget(self, action: #selector(self.changed), forControlEvents: UIControlEvents.EditingChanged)
      
      let property = MutableProperty<String>(self.text ?? "")
      property.producer
        .startWithNext {
          newValue in
          self.text = newValue
        }
      return property
    }
  }
    
  func changed() {
    rac_text.value = self.text ?? ""
  }
    public var rac_textKB: SignalProducer<String, NoError> {
        return self.rac_textSignal().toSignalProducer()
            .flatMapError { error in
                SignalProducer<AnyObject?, NoError>.empty
            }.map { $0 as! String }
    }
    
    public var rac_secureTextEntry: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.secureTextEntry, setter: { self.secureTextEntry = $0 }, getter: { self.secureTextEntry  })
    }
}

extension UITextView {
    public var rac_text: MutableProperty<String> {
        return lazyMutableProperty(self, key: &AssociationKey.textTextView, setter: { self.text = $0 }, getter: { self.text ?? "" })
    }
}

extension UISwitch {
    public var rac_newOnChannel: SignalProducer<Bool, NoError> {
        return self.rac_newOnChannel().toSignalProducer()
            .flatMapError { error in
                SignalProducer<AnyObject?, NoError>.empty
            }.map { $0 as! Bool }
    }
}
