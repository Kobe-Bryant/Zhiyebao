//
//  RentListViewController.h
//  Zhiyebao
//
//  Created by Apple on 14-4-30.
//
//

#import <UIKit/UIKit.h>
#import "AreaSelectorViewController.h"

//@protocol  RentListViewControllertoggleDelegate <NSObject>
//
//
//- (void)toggleClickButton:(id)sender;
//
//
//@end
//
//@protocol RentListViewControllertoggleBackDelegate <NSObject>
//
//
//- (void)toogleBackMethod:(id)sender;
//
//
//
//@end

@interface RentListViewController : UITableViewController<AreaSelectorViewControllerDelegate>

//@property(nonatomic,assign) id<RentListViewControllertoggleDelegate>toggleDelegate;
//
//@property(nonatomic,assign) id<RentListViewControllertoggleBackDelegate>backDelegate;

//为了拿到出租视图控制器的tabbarController定义的属性
//@property(nonatomic,strong,readwrite) UIViewController* homeViewController;

//@property (nonatomic, retain) NSArray *areaIDArray;
//@property (nonatomic, retain) NSArray *houseTypeIDArray;
//@property (nonatomic, retain) NSArray *rentPriceIDArray;
//@property (nonatomic, retain) NSArray *proportionIDArray;
//- (void)refreshData;


@end