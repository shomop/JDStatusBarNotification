//
//  JDStatusBarNotificationPresenterCustomViewSizingController.h
//
//  Created by Markus Emrich on 10/25/23.
//  Copyright 2023 Markus Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(NotificationPresenterCustomViewSizingController)
@protocol JDStatusBarNotificationPresenterCustomViewSizingController
- (CGSize)sizeThatFits:(CGSize)size NS_SWIFT_NAME(sizeThatFits(in:));
@end

NS_ASSUME_NONNULL_END
