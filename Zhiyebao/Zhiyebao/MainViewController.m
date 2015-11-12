//
//  MainViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-4-29.
//
//

#define FILTER_VIEW_WIDTH 200.0

#import "MainViewController.h"
//#import "RentViewController.h"
#import "RentListViewController.h"
#import "SellViewController.h"
#import "PostViewController.h"
#import "PublishViewController.h"
#import "CollectViewController.h"
#import "MemberViewController.h"
//#import "HomeViewController.h"
#import "HomeListViewController.h"
#import "MemberLoginViewController.h"
#import "Macros.h"
#import "CustomButton.h"
#import "TabBar.h"
#import "CustomMarcos.h"

@interface MainViewController ()

@property (nonatomic, retain) UITabBar* bottomTabbar;
@property (nonatomic) BOOL isViewWillAppeared;

//初始化所有视图控制器
- (void)initAllControllers;

//自定义tabbar
- (void)customTabbar;

@end

@implementation MainViewController

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
    
    NSLog(@"MainViewController viewDidLoad");
    

    //初始化所有视图控制器
    [self initAllControllers];
    
    
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(homeItemSelected:)
                                                 name:SELECTED_HOME_ITEM_NOTIFICATION
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
    
    
    //自定义tabbar
    [self customTabbar];
}

- (void)initAllControllers
{
    //首页视图控制器
    HomeListViewController *homeVC = [[HomeListViewController alloc] init];
    UINavigationController* homeNC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        homeVC.edgesForExtendedLayout = NO;
    }

    
    
    //出租视图控制器
    RentListViewController* rentVC = [[RentListViewController alloc] init];
    UINavigationController* rentNC = [[UINavigationController alloc] initWithRootViewController:rentVC];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        rentVC.edgesForExtendedLayout = NO;
    }

    
    
    //出售视图控制器
    SellViewController* sellVC = [[SellViewController alloc] init];
    UINavigationController* sellNC = [[UINavigationController alloc] initWithRootViewController:sellVC];

    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        sellVC.edgesForExtendedLayout = NO;
    }

    
    
    //刊登视图控制器

    UIViewController *postNC = [[UIViewController alloc] init];


    
    //收藏视图控制器
    CollectViewController* collectVC = [[CollectViewController alloc] init];
    UINavigationController* collectNC = [[UINavigationController alloc] initWithRootViewController:collectVC];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        collectVC.edgesForExtendedLayout = NO;
    }

    
    //会员视图控制器
    MemberViewController* memberVC = [[MemberViewController alloc] init];
    UINavigationController* memberNC = [[UINavigationController alloc] initWithRootViewController:memberVC];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        memberVC.edgesForExtendedLayout = NO;
    }

    
    

    self.viewControllers = @[homeNC, rentNC, sellNC, postNC, collectNC, memberNC];
    self.selectedIndex = 0;    
}

//创建tabbar上的按钮，参数normalImage未选中按钮的颜色，selectedImage为选中按钮的颜色，andTitle是按钮上的字体，index指在哪一个位置
- (void)createButtonWithNormalImageName:(NSString*)normalImage andSelectImageName:(NSString*)selectedImage andTitle:(NSString*)title andIndex:(int)index
{
    if (index != 3) {
        CustomButton* button = [CustomButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        CGFloat buttonW = self.tabBar.frame.size.width / 5.0;
        CGFloat buttonH = self.tabBar.frame.size.height;
        button.frame = CGRectMake((self.tabBar.frame.size.width / 5.0) * (index - 1), 0.0, buttonW, buttonH);
        [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(changeViewController:)
         forControlEvents:UIControlEventTouchUpInside];
        button.imageView.contentMode = UIViewContentModeCenter;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [button setTitleColor:UIColorFromRGB(23.0, 207.0, 175.0) forState:UIControlStateSelected];
        button.userInteractionEnabled = YES;
        [self.tabBar addSubview:button];
    } else {
        UIImage *backgroundImage = [UIImage imageNamed:@"NewPostBackground"];
        UIButton *postButton = [[UIButton alloc] init];
        postButton.frame = CGRectMake((self.tabBar.frame.size.width - backgroundImage.size.width) / 2.0,
                                      self.tabBar.frame.size.height - backgroundImage.size.height,
                                      backgroundImage.size.width,
                                      backgroundImage.size.height);
        [postButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [postButton setImage:[UIImage imageNamed:@"NewPostIcon"] forState:UIControlStateNormal];
        postButton.tag = index;
        [postButton addTarget:self
                       action:@selector(changeViewController:)
             forControlEvents:UIControlEventTouchUpInside];
        postButton.userInteractionEnabled = YES;
        [self.tabBar addSubview:postButton];
    }
}

//自定义tabbar
- (void)customTabbar
{    
    //tabbar视图
    self.tabBar.backgroundImage = [UIImage imageNamed:@"Transparent"];
    self.tabBar.shadowImage = [UIImage imageNamed:@"Transparent"];
    
    self.moreNavigationController.title = nil;
    self.moreNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@""
                                                                             image:[UIImage imageNamed:@"Transparent"]
                                                                     selectedImage:[UIImage imageNamed:@"Transparent"]];
    

    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.frame = CGRectMake(0.0,
                                      0.0,
                                      self.tabBar.frame.size.width,
                                      self.tabBar.frame.size.height);
    backgroundView.backgroundColor = UIColorFromRGB(11.0, 102.0, 86.0);
    [self.tabBar addSubview:backgroundView];
    
    
    //创建tabbar上的按钮
    [self createButtonWithNormalImageName:@"NewHomeIcon" andSelectImageName:@"NewHomeSelectedIcon" andTitle:@"租房" andIndex:1];
    [self createButtonWithNormalImageName:@"NewSellIcon" andSelectImageName:@"NewSellSelectedIcon" andTitle:@"买房" andIndex:2];
    [self createButtonWithNormalImageName:@"NewPostIcon" andSelectImageName:@"NewPostSelectedIcon" andTitle:@"" andIndex:3];
    [self createButtonWithNormalImageName:@"NewCollectIcon" andSelectImageName:@"NewCollectSelectedIcon" andTitle:@"收藏" andIndex:4];
    [self createButtonWithNormalImageName:@"NewMemberIcon" andSelectImageName:@"NewMemberSelectedIcon" andTitle:@"会员" andIndex:5];

}


//切换试图控制器的方法
- (void)changeViewController:(CustomButton*)customButton
{
    [self changeTabBarSelectedIndex:customButton.tag];
}

- (void)changeTabBarSelectedIndex:(NSUInteger)currentSelectedIndex
{
    if (currentSelectedIndex == 3 || currentSelectedIndex == 4) {
        NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_USER_NAME];
        NSString* password = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_PASSWORD];
        if (!(username != nil && username.length > 0 && password != nil && password.length > 0)) {
            MemberLoginViewController* loginVC = [[MemberLoginViewController alloc] init];
            UINavigationController* loginNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:loginNC animated:YES completion:nil];
            return;
        }
    }
    
    if (currentSelectedIndex == 3) {
        PublishViewController* postVC = [[PublishViewController alloc] init];
        UINavigationController* postNC = [[UINavigationController alloc] initWithRootViewController:postVC];
        [self presentViewController:postNC animated:YES completion:nil];
    } else {
        for (CustomButton *customButton in self.tabBar.subviews) {
            if ([customButton isKindOfClass:[CustomButton class]]) {
                customButton.selected = (customButton.tag == currentSelectedIndex);
            }
        }
        

            self.selectedIndex = currentSelectedIndex;
        
    }
    
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"didSelectItem %@", item);
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSLog(@"shouldSelectViewController %@", viewController);
    return YES;
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"didSelectViewController %@", viewController);
}

- (void)hideTabBarItems:(NSTimer *)timer
{
    NSLog(@"hideTabBarItems %@", timer);
    
    for (UIView *subview in self.tabBar.subviews) {
        NSString *className = NSStringFromClass([subview class]);
        NSLog(@"className %@", className);
        
        if ([className isEqualToString:@"UITabBarButton"]) {
            subview.hidden = YES;
            subview.frame = CGRectMake(subview.frame.origin.x,
                                       subview.frame.origin.y + self.tabBar.frame.size.height,
                                       subview.frame.size.width,
                                       subview.frame.size.height);
        }
        
        //                NSLog(@"subview.hidden %i", subview.hidden);
        
        //                NSLog(@"subview.frame %@", NSStringFromCGRect(subview.frame));
        
    }

}

- (void)homeItemSelected:(NSNotification *)notification
{
    NSLog(@"homeItemSelected %@", notification);
    
    [self changeTabBarSelectedIndex:0];
}


@end
