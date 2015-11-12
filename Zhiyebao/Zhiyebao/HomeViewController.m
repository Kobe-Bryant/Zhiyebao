//
//  HomeViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-4-30.
//
//

#define FILTER_VIEW_WIDTH 200.0

#import "HomeViewController.h"
#import "MainViewController.h"
#import "Macros.h"
#import "RentModel.h"
#import "RentCell.h"
#import "RentDetailViewController.h"
#import "MainViewController.h"
#import "HomeListViewController.h"
#import "FilterViewController.h"
#import "ViewSize.h"
#import "CustomMarcos.h"



@interface HomeViewController ()
{

}

@property (nonatomic, retain) UINavigationController* homeNC;
@property (nonatomic, retain) HomeListViewController* homeListVC;
@property (nonatomic, retain) FilterViewController* filterVC;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    NSLog(@"HomeViewController =  %@",self.navigationController);
    
    
    
    self.navigationController.navigationBarHidden = YES;
//    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor greenColor];
    
    
    self.homeListVC = [[HomeListViewController alloc] init];
    self.homeListVC.toggleDelegate = self;
//    self.homeListVC.homeViewController = self;
    //    self.homeListVC.view.frame = CGRectMake(0.0,
    //                                            0.0,
    //                                            self.view.frame.size.width,
    //                                            self.view.frame.size.height);
    
    
    self.homeNC = [[UINavigationController alloc] initWithRootViewController:self.homeListVC];
    self.homeNC.interactivePopGestureRecognizer.enabled = YES;
    [self.view addSubview:self.homeNC.view];
    

    
    self.filterVC = [[FilterViewController alloc] initWithIsRent:YES];
    self.filterVC.view.frame = CGRectMake(self.view.frame.size.width,
                                          0.0,
                                          FILTER_VIEW_WIDTH,
                                          self.view.frame.size.height + TAB_BAR_HEIGHT);
    self.filterVC.view.userInteractionEnabled = YES;
    [self addChildViewController:self.filterVC];
    [self.view addSubview:self.filterVC.view];
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"HomeViewController viewWillAppear");
    NSLog(@"self.view.frame %@", NSStringFromCGRect(self.view.frame) );
    
    self.homeNC.view.frame = CGRectMake(0.0,
                                        0.0,
                                        self.view.frame.size.width,
                                        self.view.frame.size.height);
    
    
    self.filterVC.view.frame = CGRectMake(self.view.frame.size.width,
                                          0.0,
                                          FILTER_VIEW_WIDTH,
                                          self.view.frame.size.height);
    
    
 
    

}



#pragma mark  HomeViewControllerDelegate
- (void)setIsRent:(BOOL)isRent
{
    self.filterVC.isRent = isRent;
    [self.filterVC refreshData];
}

//- (void)toggleClickButton:(id)sender
//{
////    MainViewController* mainVC = (MainViewController*)self.tabBarController;
////    [mainVC toggleTabBarLeftRightMove];
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        CGRect homeNCFrame = self.homeListVC.navigationController.view.frame;
//        
//        if (homeNCFrame.origin.x != 0) {
//            homeNCFrame.origin.x += FILTER_VIEW_WIDTH;
//            self.filterVC.view.frame = CGRectMake(self.view.frame.size.width,
//                                                  0.0,
//                                                  FILTER_VIEW_WIDTH,
//                                                  self.view.frame.size.height);
//        } else {
//            homeNCFrame.origin.x -= FILTER_VIEW_WIDTH;
//            self.filterVC.view.frame = CGRectMake(self.view.frame.size.width - FILTER_VIEW_WIDTH,
//                                                  0.0,
//                                                  FILTER_VIEW_WIDTH,
//                                                  self.view.frame.size.height);
//        }
//        
//        self.homeListVC.navigationController.view.frame = homeNCFrame;
//    }];
//}

- (void)changeSearchBarFrame
{
    
    

    [UIView animateWithDuration:0.25 animations:^{
        CGRect homeNCFrame = self.homeListVC.navigationController.view.frame;
        
        if (homeNCFrame.origin.x != 0) {
            homeNCFrame.origin.x += self.view.frame.size.width;
            self.filterVC.view.frame = CGRectMake(self.view.frame.size.width,
                                                  0.0,
                                                  self.view.frame.size.width,
                                                  self.view.frame.size.height);
        } else {
            homeNCFrame.origin.x -= self.view.frame.size.width;
            self.filterVC.view.frame = CGRectMake(self.view.frame.size.width - self.view.frame.size.width,
                                                  0.0,
                                                self.view.frame.size.width,
                                                  self.view.frame.size.height);
        }
        
        self.homeListVC.navigationController.view.frame = homeNCFrame;
    }];




}
@end
