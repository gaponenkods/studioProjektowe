//
//  UITextField+RACKeyboardSupport.m
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

#import "UITextField+RACKeyboardSupport.h"
#import "RACTuple.h"
#import <objc/runtime.h>

@implementation UITextField (RACKeyboardSupport)

static void RACUseDelegateProxy(UITextField *self) {
    if (self.delegate == self.rac_delegateProxy) return;
    
    self.rac_delegateProxy.rac_proxiedDelegate = self.delegate;
    self.delegate = (id)self.rac_delegateProxy;
}

- (RACDelegateProxy *)rac_delegateProxy {
    RACDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
    if (proxy == nil) {
        proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UITextFieldDelegate)];
        objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return proxy;
}

- (RACSignal *)rac_keyboardReturnSignal {
    RACSignal *signal = [[[[self.rac_delegateProxy
                           signalForSelector:@selector(textFieldShouldReturn:)]
                          takeUntil:self.rac_willDeallocSignal]
                         setNameWithFormat:@" -rac_keyboardReturnSignal"]
                         map:^UITextField*(RACTuple *value) {
                             return value.first;
                         }];
    RACUseDelegateProxy(self);
    
    return signal;
}

@end
