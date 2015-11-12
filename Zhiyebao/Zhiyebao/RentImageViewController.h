//
//  RentImageViewController.h
//  Zhiyebao
//
//  Created by LaiZhaowu on 14-5-29.
//
//

#import <UIKit/UIKit.h>
#import "TapDetectingImageView.h"

@protocol RentImageViewControllerDelegate <NSObject>
- (void)didZoomAnimate:(BOOL)isMinSize;
@end

@interface RentImageViewController : UIViewController<UIScrollViewDelegate, TapDetectingImageViewDelegate>

- (id)initWithImageURLString:(NSString *)imageURLString currentSelectedIndex:(NSUInteger)currentSelectedIndex;
@property (nonatomic, assign) id<RentImageViewControllerDelegate> delegate;
@property (nonatomic, readonly) NSUInteger currentSelectedIndex;

@end
