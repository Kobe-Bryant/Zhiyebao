//
//  PullDownControl.h
//  Zhiyebao
//
//  Created by LaiZhaowu on 14-5-25.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PullDownControlNormalStatus                = 0,
    PullDownControlReleaseStatus               = 1,
    PullDownControlRefreshingStatus            = 2
} PullDownControlStatus;

@interface PullDownControl : UIView

@property (nonatomic, readonly) PullDownControlStatus status;
- (void)changeStatus:(PullDownControlStatus)status;

@end
