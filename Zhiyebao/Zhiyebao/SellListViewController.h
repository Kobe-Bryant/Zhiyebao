//
//  SellListViewController.h
//  Zhiyebao
//
//  Created by Apple on 14-5-4.
//
//
#import <UIKit/UIKit.h>
#import "AreaSelectorViewController.h"

//@protocol  SellListViewControllertoggleDelegate <NSObject>
//
//- (void)toggleClickButton:(id)sender;
//
//@end

@interface SellListViewController : UITableViewController<AreaSelectorViewControllerDelegate>

//@property(nonatomic,assign) id<SellListViewControllertoggleDelegate>toggleDelegate;

//@property(nonatomic,strong,readwrite) UIViewController* homeViewController;

//@property (nonatomic, retain) NSArray *areaIDArray;
//@property (nonatomic, retain) NSArray *houseTypeIDArray;
//@property (nonatomic, retain) NSArray *rentPriceIDArray;
//@property (nonatomic, retain) NSArray *proportionIDArray;
//- (void)refreshData;



@end