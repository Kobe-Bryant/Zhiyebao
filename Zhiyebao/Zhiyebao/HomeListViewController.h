//
//  HomeListViewController.h
//  Zhiyebao
//
//  Created by Apple on 14-4-30.
//
//

#import <UIKit/UIKit.h>

@protocol HomeViewControllertoggleDelegate <NSObject>

- (void)setIsRent:(BOOL)isRent;
- (void)toggleClickButton:(id)sender;

@end


@interface HomeListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property(nonatomic, assign) id<HomeViewControllertoggleDelegate>toggleDelegate;
//@property(nonatomic, strong) UIViewController* homeViewController;
//@property (nonatomic, retain) NSArray *areaIDArray;
//@property (nonatomic, retain) NSArray *houseTypeIDArray;
//@property (nonatomic, retain) NSArray *rentPriceIDArray;
//@property (nonatomic, retain) NSArray *proportionIDArray;
//- (void)refreshData;


@end
