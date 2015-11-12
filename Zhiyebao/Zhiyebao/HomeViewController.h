//
//  HomeViewController.h
//  Zhiyebao
//
//  Created by Apple on 14-4-30.
//
//

#import <UIKit/UIKit.h>
#import "HomeListViewController.h"

@interface HomeViewController : UIViewController<HomeViewControllertoggleDelegate>

@property (nonatomic, retain) NSArray *areaIDArray;
@property (nonatomic, retain) NSArray *houseTypeIDArray;
@property (nonatomic, retain) NSArray *rentPriceIDArray;
@property (nonatomic, retain) NSArray *proportionIDArray;
@property (nonatomic) BOOL isRent;

- (void)refreshListData;
- (void)refreshFilterData;
- (void)toggleClickButton:(id)sender;

@end
