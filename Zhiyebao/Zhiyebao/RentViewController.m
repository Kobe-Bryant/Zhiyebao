//
//  RentViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-4-29.
//
//

#import "RentViewController.h"
#import "Macros.h"
#import "RentModel.h"
#import "RentCell.h"
#import "RentListViewController.h"
#import "FilterViewController.h"
#import "RentDetailViewController.h"
#import "MainViewController.h"



@interface RentViewController ()
{
//    UINavigationController* rentListNC;
//    RentListViewController *rentListVC;
//    FilterViewController* filterVC;
//    MainViewController* mainVC;
    //为当前视图添加的蒙层的视图
//    UIView* backView;
    BOOL isViewWillAppeared;
//    BOOL isViewDidApeared;

}
@end

@implementation RentViewController

//自定义初始化方法
//-(id)initWithTitle:(NSString*)string
//{
//    self = [super init];
//    if (self) {

//        self.rentTitleString = string;
//        self.navigationItem.hidesBackButton = YES;
//        self.hidesBottomBarWhenPushed = YES;

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
    
    NSLog(@"RentViewController viewWillAppear");
    
    if (isViewWillAppeared) {
        return;
    } else {
        isViewWillAppeared = YES;
    }
   
    
    //创建出租列表视图控制器
    RentListViewController * rentListVC = [[RentListViewController alloc] init];

    UINavigationController *rentListNC = [[UINavigationController alloc] initWithRootViewController:rentListVC];
    rentListNC.view.frame = CGRectMake(0.0,
                                       0.0,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height);
    [self addChildViewController:rentListNC];
    [self.view addSubview:rentListNC.view];
    NSLog(@"rentListNC.view.frame %@", NSStringFromCGRect(rentListNC.view.frame) );

}




//回到首页方法
- (void)backHomeVCMethod
{
    
    self.tabBarController.selectedIndex = 0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)refreshListData
//{
//    //    NSLog(@"refreshData");
//    
//    rentListVC.areaIDArray = self.areaIDArray;
//    rentListVC.houseTypeIDArray = self.houseTypeIDArray;
//    rentListVC.rentPriceIDArray = self.rentPriceIDArray;
//    rentListVC.proportionIDArray = self.proportionIDArray;
//    [rentListVC refreshData];
//}

#pragma mark RentListViewControllertoggleBackDelegate
- (void)setAreaIDArrayAtSelector:(NSArray *)updateAreaIDArray
{
    NSLog(@"setAreaIDArray %@", updateAreaIDArray);
//    rentListVC.areaIDArray = updateAreaIDArray;
//    [rentListVC refreshData];
}


@end
