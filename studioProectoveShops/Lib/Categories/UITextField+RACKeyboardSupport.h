//
//  UITextField+RACKeyboardSupport.h
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface UITextField (RACKeyboardSupport)
- (RACSignal *)rac_keyboardReturnSignal;

@end
