//
//  RootViewController.m
//  Zhiyebao
//
//  Created by LaiZhaowu on 14-5-28.
//
//

#define MASK_TAG 0022

#import "RootViewController.h"
#import "MainViewController.h"
#import "FilterViewController.h"
#import "ViewDeckController.h"
#import "CustomMarcos.h"
#import "EnterViewController.h"
#import "RentDetailViewController.h"
#import "LeftViewController.h"
#import "TopViewController.h"

@interface RootViewController ()

@property (retain, nonatomic) UIViewController *centerViewController;
@property (retain, nonatomic) UIViewController *rightViewController;
@property(retain ,nonatomic) UIViewController* leftViewController;
@property(retain ,nonatomic) UIViewController* topViewController;

@property (retain, nonatomic) ViewDeckController* deckViewController;
@property (nonatomic) BOOL isViewWillAppeared;



@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewDeckEnabled:)
                                                 name:ENABLED_VIEW_DECK_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewDeckDisabled:)
                                                 name:DISABLED_VIEW_DECK_NOTIFICATION
                                            object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openFilterSidebar:)
                                                 name:OPEN_FILTER_SIDEBR_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeFilterSidebar:)
                                                 name:CLOSE_FILTER_SIDEBR_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterSidebarDidOpened:)
                                                 name:FILTER_SIDEBR_DID_OPENED_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterSidebarDidClosed:)
                                                 name:FILTER_SIDEBR_DID_CLOSED_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterFullScreenChanged:)
                                                 name:FILTER_SIDEBAR_FULL_SCREEN_CHANGED_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterNormalScreenChanged:)
                                                 name:FILTER_SIDEBAR_NORMAL_SCREEN_CHANGED_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushDetailHouse:)
                                                 name:PUSH_PRODUCT_NOTIFICATION
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    if (self.isViewWillAppeared) {
        return;
    } else {
        self.isViewWillAppeared = YES;
    }

    
    NSLog(@"RootViewController viewWillAppear");
    NSLog(@"self.isViewLoaded %i", self.isViewLoaded);

    
    //监听点击进入主页的按钮事件。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterHomeVC:)
                                                 name:@"EnterHomeVCMethod"
                                               object:nil];
    
    //判断有没有第一次进入该页面
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_FIRST_ENTER_HOME_VC]) {
        EnterViewController* enterVC = [[EnterViewController alloc] init];
        [self.view addSubview:enterVC.view];
        [self addChildViewController:enterVC];
        [[NSUserDefaults standardUserDefaults] setBool:1 forKey:IS_FIRST_ENTER_HOME_VC];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [self enterHomeVC:nil];
    }
}


- (void)enterHomeVC:(NSNotification*)notification
{

    _centerViewController = [[MainViewController alloc] init];
    _rightViewController = [[FilterViewController alloc] initWithIsRent:YES];
    _leftViewController = [[LeftViewController alloc]init];
    UINavigationController* na = [[UINavigationController alloc]initWithRootViewController:_leftViewController];
    _topViewController = [[UIViewController alloc]init];
    

    _deckViewController =  [[ViewDeckController alloc] initWithCenterViewController:_centerViewController
                                                                 leftViewController:na
                                                                rightViewController:_rightViewController];
    
    _deckViewController = [[ViewDeckController alloc]initWithCenterViewController:_centerViewController leftViewController:na rightViewController:_rightViewController topViewController:_topViewController bottomViewController:_topViewController];

    
    
   
    
    _deckViewController.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    _deckViewController.leftSize = self.view.frame.size.width-200.0;
    _deckViewController.rightSize = self.view.frame.size.width - 200.0;
    [self.view addSubview:_deckViewController.view];
    
}


- (void)filterFullScreenChanged:(NSNotification *)notification
{
    NSLog(@"filterFullScreenChanged %@", notification);
    
    [_deckViewController setRightSize:0.0 completion:^(BOOL finished) {
        if (finished) {
            
            
        }
    }];
}
- (void)filterNormalScreenChanged:(NSNotification *)notification
{
    NSLog(@"filterNormalScreenChanged %@", notification);
    
    [_deckViewController setRightSize:(self.view.frame.size.width - FILTER_SIDEBAR_WIDTH) completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}
- (void)pushDetailHouse:(NSNotification *)notification
{
    NSLog(@"pushProduct %@", notification);
    //    [self.viewDeckController closeRightViewAnimated:NO];
    
    [_deckViewController closeRightViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        if (success) {
            //            NSLog(@"success");
            
            //            NSNumber *productID = [[notification object] objectForKey:PRODUCT_ID];
            //            NSLog(@"productID %@", productID);
            //            DetailViewController *productVC = [[DetailViewController alloc] initWithProductID:productID];
            //            [controller.centerController.navigationController pushViewController:productVC animated:YES];
            //            UIViewController *testVC = [[UIViewController alloc] init];
            //            [self.viewDeckController rightViewPushViewControllerOverCenterController:productVC];
            
            
            //            [controller.centerController.navigationController pushViewController:testVC animated:YES];
            
        }
    }];
    
}


- (void)viewDeckEnabled:(NSNotification *)notification
{
    NSLog(@"viewDeckEnabled %@", notification);
    _deckViewController.enabled = YES;
}

- (void)viewDeckDisabled:(NSNotification *)notification
{
    NSLog(@"viewDeckDisabled %@", notification);
    _deckViewController.enabled = NO;
}


- (void)openFilterSidebar:(NSNotification *)notification
{
    NSLog(@"openFilterSidebar %@", notification);
    [_deckViewController openRightViewAnimated:YES];
}

- (void)closeFilterSidebar:(NSNotification *)notification
{
    NSLog(@"closeFilterSidebar %@", notification);
    [_deckViewController closeRightViewAnimated:YES];
}

- (void)filterSidebarDidOpened:(NSNotification *)notification
{
    NSLog(@"filterSidebarDidOpened %@", notification);
    UIView *maskView = [_centerViewController.view viewWithTag:MASK_TAG];
    if (maskView == nil) {
        maskView = [[UIView alloc] init];
        maskView.frame = CGRectMake(0.0,
                                    0.0,
                                    _centerViewController.view.frame.size.width,
                                    _centerViewController.view.frame.size.height);
        maskView.tag = MASK_TAG;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(closeFilterSidebar:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [maskView addGestureRecognizer:tap];
        
        [_centerViewController.view addSubview:maskView];
    }
}

- (void)filterSidebarDidClosed:(NSNotification *)notification
{
    NSLog(@"filterSidebarDidClosed %@", notification);
    
    UIView *maskView = [_centerViewController.view viewWithTag:MASK_TAG];
    [maskView removeFromSuperview];
}


@end
