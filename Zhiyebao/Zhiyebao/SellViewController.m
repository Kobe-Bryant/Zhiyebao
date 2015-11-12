//
//  SellViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-4-29.
//
//

#import "SellViewController.h"
#import "Macros.h"
#import "RentModel.h"
#import "RentCell.h"
#import "SellListViewController.h"
#import "FilterViewController.h"
#import "MainViewController.h"

@interface SellViewController ()
{

//    NSMutableArray* rentDataArray;
//    UITableView* mainTableView;
//    UINavigationController* sellListNC;
//    SellListViewController* sellListVC;
//    FilterViewController* filtVC;
//    UIView* backView ;
//    MainViewController* mainVC;
    BOOL isViewWillAppeared;
//    BOOL isViewDidApeared;

}
@end

@implementation SellViewController

//-(id)initWithTitle:(NSString*)string
//{
//    self = [super init];
//    if (self) {
//      
//        
//        self.sellTitleString = string;
////        self.navigationItem.hidesBackButton = YES;
////        self.hidesBottomBarWhenPushed = YES;
//        
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    NSLog(@"SellViewController viewWillAppear");
    
    NSLog(@"%@", NSStringFromCGRect(self.view.frame) );

    
    if (isViewWillAppeared) {
        return;
    } else {
        isViewWillAppeared = YES;
    }

    
    
    SellListViewController * sellListVC = [[SellListViewController alloc] init];

    UINavigationController *sellListNC = [[UINavigationController alloc] initWithRootViewController:sellListVC];
    sellListNC.view.frame = CGRectMake(0.0,
                                       0.0,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height);
    [self addChildViewController:sellListNC];
    [self.view addSubview:sellListNC.view];
    

    
}


#pragma mark RentListViewControllertoggleBackDelegate
//- (void)setAreaIDArrayAtSelector:(NSArray *)updateAreaIDArray
//{
//    NSLog(@"setAreaIDArray %@", updateAreaIDArray);
//    sellListVC.areaIDArray = updateAreaIDArray;
//    [sellListVC refreshData];
//}


@end
