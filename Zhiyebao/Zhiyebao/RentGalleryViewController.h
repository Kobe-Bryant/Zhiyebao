//
//  RentGalleryViewController.h
//  Zhiyebao
//
//  Created by LaiZhaowu on 14-5-29.
//
//

#import <UIKit/UIKit.h>
#import "RentImageViewController.h"

@interface RentGalleryViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate, RentImageViewControllerDelegate>

- (id)initWithHouseImageArray:(NSArray *)houseImageArray currentSelectedIndex:(NSUInteger)currentSelectedIndex;

@end
