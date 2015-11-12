//
//  RentDetailViewController.h
//  Zhiyebao
//
//  Created by Apple on 14-4-29.
//
//

#import <UIKit/UIKit.h>
@class House;

@interface RentDetailViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property(nonatomic, strong) UIPageViewController* pageController;

//为了拿到tabbarController而定义的属性
@property(nonatomic, strong) UIViewController* mainViewController;

@property(nonatomic, strong) NSString* titleSting;

@property(nonatomic, strong) NSString* houseID;

@property(nonatomic,strong) NSString* isSell;

@property(nonatomic) BOOL changeBarColor;

@property(nonatomic,strong) House* house;


- (id)initWithDataObject:(id)dataObject;

@end
