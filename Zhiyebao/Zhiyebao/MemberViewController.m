//
//  MemberViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-4-29.
//
//

#import "MemberViewController.h"
#import "Macros.h"
#import "MemberLoginViewController.h"
#import "CollectViewController.h"
#import "ScanViewController.h"
#import "ContactViewController.h"
#import "ModifyPasswordViewController.h"
#import "UpdateProfileViewController.h"
#import "PostRentViewController.h"
#import "PostSellViewController.h"
#import "MemberCell.h"
#import "MainViewController.h"
#import "ManagerMember.h"
#import "Result.h"
#import "CustomMarcos.h"
#import "Member.h"
#import "AFNetworkReachabilityManager.h"
#import "SDWebImage/UIImageView+WebCache.h"



@interface MemberViewController ()
{
    
    UITableView* mainTableView;
    UIView* blackView;
    UIView* whiteView;
    
    UIView* sureBlackView;
    UIView* sureWhiteView;
    
    NSMutableArray* collectHouseCount;
    UILabel* collectLabel;
    UILabel* telephoneLabel;
    BOOL isViewWillAppeared;
    BOOL isTipsLogin;
    UILabel* greetLabel;
}

//获取会员信息
- (void)memberInfoMation;



@end

@implementation MemberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"会员";
    
    self.navigationItem.hidesBackButton = YES;
    

    
    //返回的leftBarButtonItem
    UIImage* image = [UIImage imageNamed:@"BackHome.png"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0.0,
                                  0.0,
                                  image.size.width,
                                  image.size.height);
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backHomeVCMethod)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(changePersonInfomation:)
                                                name:MODIFY_PERSON_INFOMATION
                                              object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"MemberViewController viewWillAppear");
    
    // Remove all subviews
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }

    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] !=AFNetworkReachabilityStatusNotReachable && [[AFNetworkReachabilityManager sharedManager]networkReachabilityStatus]!= AFNetworkReachabilityStatusUnknown)
    {
        
        if ([Member shareMember].isLogined )
        {
            
            UIImage* image = [UIImage imageNamed:@"cancelbuttonImage.png"];
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rightButton.frame = CGRectMake(0.0,
                                           0.0,
                                           image.size.width,
                                           image.size.height);
            //        [rightButton setImage:image forState:UIControlStateNormal];
            [rightButton setBackgroundImage:image forState:UIControlStateNormal];
            [rightButton addTarget:self
                            action:@selector(goBackMethod:)
                  forControlEvents:UIControlEventTouchUpInside];
            [rightButton setTitle:@"退出" forState:UIControlStateNormal];
            [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            rightButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
            
            UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
            self.navigationItem.rightBarButtonItem = rightItem;
            
            
            
            
            mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0,
                                                                         0.0,
                                                                         self.view.frame.size.width,
                                                                         self.view.frame.size.height)
                                                        style:UITableViewStyleGrouped];
            mainTableView.delegate = self;
            mainTableView.dataSource = self;
            mainTableView.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
            [self.view addSubview:mainTableView];
            
            
            
            UIView* tableViewHeadView = [[UIView alloc]init];
            tableViewHeadView.frame = CGRectMake(0.0,
                                                 0.0,
                                                 self.view.frame.size.width,
                                                 75.0);
            tableViewHeadView.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
            mainTableView.tableHeaderView = tableViewHeadView;
            
            
            telephoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(120.0,
                                                                               15.0,
                                                                               100.0,
                                                                               20.0)];
            telephoneLabel.textColor =UIColorFromRGB(11.0, 102.0, 86.0);
            telephoneLabel.font = [UIFont systemFontOfSize:16.0];
            if ([[NSUserDefaults standardUserDefaults]objectForKey:USER_NAME]) {
                telephoneLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:USER_NAME];
   
            } else {
                 telephoneLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:LOGIN_USER_NAME];
            }
            telephoneLabel.backgroundColor = [UIColor clearColor];
            telephoneLabel.textAlignment = NSTextAlignmentCenter;
            [tableViewHeadView addSubview:telephoneLabel];
            
            
            greetLabel = [[UILabel alloc]initWithFrame:CGRectMake(40.0,
                                                                      40.0,
                                                                      250.0,
                                                                      30.0)];
            greetLabel.textColor =UIColorFromRGB(234.0, 117.0, 45.0);
            greetLabel.font = [UIFont systemFontOfSize:16.0];
            greetLabel.backgroundColor = [UIColor clearColor];
            greetLabel.textAlignment = NSTextAlignmentCenter;
            [tableViewHeadView addSubview:greetLabel];
            
            UIView* tableviewfootView = [[UIView alloc]init];
            tableviewfootView.frame = CGRectMake(0.0,
                                                 0.0,
                                                 self.view.frame.size.width,
                                                 75.0);
            tableviewfootView.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
            mainTableView.tableFooterView = tableviewfootView;
            
            
            UILabel* versionlabel = [[UILabel alloc]initWithFrame:CGRectMake(120.0,
                                                                             10.0,
                                                                             250.0,
                                                                             30.0)];
            versionlabel.textColor =UIColorFromRGB(185.0, 185.0, 185.0);
            versionlabel.font = [UIFont systemFontOfSize:12.0];
            versionlabel.backgroundColor = [UIColor clearColor];
            versionlabel.text = @"当前版本 V1.0";
            [tableviewfootView addSubview:versionlabel];
            
        } else {
            
        self.navigationItem.rightBarButtonItem = nil;
        
        mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0,
                                                                      0.0,
                                                                      self.view.frame.size.width,
                                                                      self.view.frame.size.height)
                                                     style:UITableViewStyleGrouped];
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        mainTableView.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
        [self.view addSubview:mainTableView];
        
        
        
        UIView* tableViewHeadView = [[UIView alloc] init];
        tableViewHeadView.frame = CGRectMake(0.0,
                                             0.0,
                                             self.view.frame.size.width,
                                             75.0);
        tableViewHeadView.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
        tableViewHeadView.userInteractionEnabled = YES;
        mainTableView.tableHeaderView = tableViewHeadView;
        
        
        
        
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(35.0,
                                                                   30.0,
                                                                   100.0,
                                                                   30.0)];
        label.textColor = UIColorFromRGB(232.0, 116.0, 43.0);
        label.font = [UIFont systemFontOfSize:16.0];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"您尚未登录";
        [tableViewHeadView addSubview:label];
        
        UIImage* loginImage = [UIImage imageNamed:@"memberloginImage.png"];
        
        UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(205.0,
                                       20.0,
                                       loginImage.size.width,
                                       loginImage.size.height);
        [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
        [loginButton addTarget:self
                        action:@selector(loginMethod)
              forControlEvents:UIControlEventTouchUpInside];
        
        loginButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [loginButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        [loginButton setTitle:@"登录"
                     forState:UIControlStateNormal];
        
        [tableViewHeadView addSubview:loginButton];
        
        
        
        UIView* tableviewfootView = [[UIView alloc]init];
        tableviewfootView.frame = CGRectMake(0.0,
                                             0.0,
                                             self.view.frame.size.width,
                                             75.0);
        tableviewfootView.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
        mainTableView.tableFooterView = tableviewfootView;
        
        
        UILabel* versionlabel = [[UILabel alloc]initWithFrame:CGRectMake(120.0,
                                                                         10.0,
                                                                         250.0,
                                                                         30.0)];
        versionlabel.textColor =UIColorFromRGB(185.0, 185.0, 185.0);
        versionlabel.font = [UIFont systemFontOfSize:12.0];
        versionlabel.backgroundColor = [UIColor clearColor];
        versionlabel.text = @"当前版本 V1.0";
        [tableviewfootView addSubview:versionlabel];
        
        }
    
    } else {
    
        self.navigationItem.rightBarButtonItem = nil;
        
        mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0,
                                                                      0.0,
                                                                      self.view.frame.size.width,
                                                                      self.view.frame.size.height)
                                                     style:UITableViewStyleGrouped];
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        mainTableView.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
        [self.view addSubview:mainTableView];
        
        
        
        UIView* tableViewHeadView = [[UIView alloc] init];
        tableViewHeadView.frame = CGRectMake(0.0,
                                             0.0,
                                             self.view.frame.size.width,
                                             75.0);
        tableViewHeadView.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
        tableViewHeadView.userInteractionEnabled = YES;
        mainTableView.tableHeaderView = tableViewHeadView;
        
        
        
        
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(35.0,
                                                                   30.0,
                                                                   100.0,
                                                                   30.0)];
        label.textColor = UIColorFromRGB(232.0, 116.0, 43.0);
        label.font = [UIFont systemFontOfSize:16.0];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"您尚未登录";
        [tableViewHeadView addSubview:label];
        
        UIImage* loginImage = [UIImage imageNamed:@"memberloginImage.png"];
        
        UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(205.0,
                                       20.0,
                                       loginImage.size.width,
                                       loginImage.size.height);
        [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
        [loginButton addTarget:self
                        action:@selector(loginMethod)
              forControlEvents:UIControlEventTouchUpInside];
        
        loginButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [loginButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        [loginButton setTitle:@"登录"
                     forState:UIControlStateNormal];
        
        [tableViewHeadView addSubview:loginButton];
        
        
        
        UIView* tableviewfootView = [[UIView alloc]init];
        tableviewfootView.frame = CGRectMake(0.0,
                                             0.0,
                                             self.view.frame.size.width,
                                             75.0);
        tableviewfootView.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
        mainTableView.tableFooterView = tableviewfootView;
        
        
        UILabel* versionlabel = [[UILabel alloc]initWithFrame:CGRectMake(120.0,
                                                                         10.0,
                                                                         250.0,
                                                                         30.0)];
        versionlabel.textColor =UIColorFromRGB(185.0, 185.0, 185.0);
        versionlabel.font = [UIFont systemFontOfSize:12.0];
        versionlabel.backgroundColor = [UIColor clearColor];
        versionlabel.text = @"当前版本 V1.0";
        [tableviewfootView addSubview:versionlabel];
    }
    
    [self memberInfoMation];
    

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_USER_NAME];
    NSString* password = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_PASSWORD];
    if (!(username != nil && username.length > 0 && password != nil && password.length > 0)) {
        if (!isTipsLogin) {
            isTipsLogin = YES;
            [self loginMethod];
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdtifity = @"cellID";
    MemberCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdtifity];
    if (!cell) {
        cell = [[MemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdtifity];
    }
    
    
    UIImage* backImage = [UIImage imageNamed:@"yellowbackImage.png"];
    UIImageView* accessImageview = [[UIImageView alloc] init];
    accessImageview.image = backImage;
    accessImageview.frame = CGRectMake(300.0,
                                       20.0,
                                       backImage.size.width,
                                       backImage.size.height);
    cell.accessoryView = accessImageview;
    
    
    Member* member = [Member shareMember];

    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UIImage* image = [UIImage imageNamed:@"myCollectImage.png"];
        cell.imageView.image = image;
        
        collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0,
                                                                 10.0,
                                                                 250.0,
                                                                 30.0)];
        collectLabel.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
        collectLabel.font = [UIFont systemFontOfSize:15.0];
        collectLabel.backgroundColor = [UIColor clearColor];
        collectLabel.text = @"收藏夹";
        
        if ([member isLogined]) {
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, queue, ^{
               
           NSNumber* userId =[[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_ID];

                
            Result* result = [ManagerMember getCollectHouseList:[userId intValue] offset:0 length:100];
                
                if (result.isSuccess) {
                    
                    //获取收藏夹房源的个数
                    collectHouseCount = [NSMutableArray arrayWithArray:result.data];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        collectLabel.text = [NSString stringWithFormat:@"收藏夹(%ld)",(unsigned long)collectHouseCount.count];
                    });
                    
                }
                
            });
            
        }
         [cell.contentView addSubview:collectLabel];
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
            
        UIImage* image = [UIImage imageNamed:@"searchImage.png"];
        cell.imageView.image = image;
        
        cell.textLabel.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = @"最近浏览";
        
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        
        UIImage* image = [UIImage imageNamed:@"makecallImage.png"];
        cell.imageView.image = image;
        
        cell.textLabel.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = @"联系记录";
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
            
        UIImage* image = [UIImage imageNamed:@"myrentImage.png"];
        cell.imageView.image = image;
        
        cell.textLabel.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = @"我刊登的出租";
        
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        
        UIImage* image = [UIImage imageNamed:@"mysellImage.png"];
        cell.imageView.image = image;
        
        cell.textLabel.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = @"我刊登的出售";

    } else if (indexPath.section == 2 && indexPath.row == 0) {
        
        UIImage* image = [UIImage imageNamed:@"MemberProfileIcon"];
        cell.imageView.image = image;
        
        cell.textLabel.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = @"修改个人资料";

    } else if (indexPath.section == 2 && indexPath.row == 1) {
        
        UIImage* image = [UIImage imageNamed:@"MemberPasswordIcon"];
        cell.imageView.image = image;
        
        cell.textLabel.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = @"修改密码";

    } else if (indexPath.section == 3) {
        
        UIImage* image = [UIImage imageNamed:@"MemberClearIcon"];
        cell.imageView.image = image;
        
        cell.textLabel.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = @"清除缓存";
        
    }
    
    return cell;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 2;
    } else if (section == 3) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1 || section == 2) {
        return 10.0;
    }
    
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Member* member = [Member shareMember];
    
    
    switch (indexPath.section) {
        case 0: {
            
            if (indexPath.row == 0) {
                
                MainViewController* mainVC = (MainViewController*)self.tabBarController;
                [mainVC changeTabBarSelectedIndex:4];
    
                
            } else if (indexPath.row == 1) {
                
                if ([member isLogined]) {
                    
                    ScanViewController* scanVC = [[ScanViewController alloc]init];
                    scanVC.mainController = self;
                    scanVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:scanVC animated:YES];
                    
                } else {
                
                    [self loginMethod];
                    
                }
 
                
            }else {
                
                if ([member isLogined]) {
                    ContactViewController* contactVC = [[ContactViewController alloc]init];
                    contactVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:contactVC animated:YES];
                    
                    
                } else {
                
                    [self loginMethod];

                }
          
            }
            
        }
            break;
        case 1:
            
            if ([member isLogined]) {
                
                
                if (indexPath.row == 0) {
                    PostRentViewController* postRentVC = [[PostRentViewController alloc] init];
                    postRentVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:postRentVC animated:YES];
                } else {
                    PostSellViewController* postSellVC = [[PostSellViewController alloc] init];
                    postSellVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:postSellVC animated:YES];
                }
                
            } else {
            
            
                [self loginMethod];
                
            
            }
            
     
            break;
            case 2:
            
            if ([member isLogined]) {
                
                
                if (indexPath.row == 0) {
                    UpdateProfileViewController* updateProfileVC = [[UpdateProfileViewController alloc] init];
                    updateProfileVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:updateProfileVC animated:YES];
                } else {
                    ModifyPasswordViewController* modifyVC = [[ModifyPasswordViewController alloc] init];
                    modifyVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:modifyVC animated:YES];
                }
                
            } else {
            
                [self loginMethod];
                
            
            
            }
            
            break;
            
        case 3: {
            
            
            blackView = [[UIView alloc]init];
            blackView.frame = CGRectMake(0.0,
                                         0.0,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height);
            blackView.backgroundColor = [UIColor blackColor];
            blackView.alpha = 0.3;
            [self.view addSubview:blackView];
            
            
            whiteView = [[UIView alloc]init];
            whiteView.backgroundColor = [UIColor whiteColor];
            whiteView.layer.cornerRadius = 3.0;
            whiteView.frame = CGRectMake((self.view.frame.size.width - 270.0)/2.0,
                                         240.0,
                                         270.0,
                                         125.0);
            [self.view addSubview:whiteView];
            
            
            UILabel* calllabel = [[UILabel alloc]init];
            calllabel.font = [UIFont systemFontOfSize:16.0];
            calllabel.textColor = UIColorFromRGB(244.0, 127.0, 64.0);
            calllabel.frame = CGRectMake(60.0,
                                         20.0,
                                         190.0,
                                         30.0);
            calllabel.text = @"确定清除缓存？";
            [whiteView addSubview:calllabel];
            
            
            UIImage* sureCallImage = [UIImage imageNamed:@"suremakecall.png"];
            UIImage* cancelcallImage = [UIImage imageNamed:@"cancelmakecall.png"];
            UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.frame = CGRectMake((whiteView.frame.size.width - cancelcallImage.size.width - sureCallImage.size.width)/3.0,
                                            60.0,
                                            cancelcallImage.size.width ,
                                            cancelcallImage.size.height);
            [cancelButton setBackgroundImage:cancelcallImage forState:UIControlStateNormal];
            [cancelButton addTarget:self action:@selector(cancelMethod:) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:cancelButton];
            
            
            UIButton* sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
            sureButton.frame = CGRectMake((whiteView.frame.size.width - cancelcallImage.size.width - sureCallImage.size.width)/3.0*2+cancelcallImage.size.width,
                                          60.0,
                                          sureCallImage.size.width ,
                                          sureCallImage.size.height);
            [sureButton setBackgroundImage:sureCallImage forState:UIControlStateNormal];
            [sureButton addTarget:self action:@selector(sureMethod:) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:sureButton];
        }
            
            
            break;
            
        default:
            break;
    }
    
    
    
    
}

- (void)cancelMethod:(UIButton*)bt
{
    
    
    [blackView removeFromSuperview];
    [whiteView removeFromSuperview];
    [mainTableView deselectRowAtIndexPath:[mainTableView indexPathForSelectedRow]  animated:YES];
}

- (void)sureMethod:(UIButton*)bt
{
    [blackView removeFromSuperview];
    [whiteView removeFromSuperview];
    
    sureBlackView = [[UIView alloc]init];
    sureBlackView.frame = CGRectMake(0.0,
                                     0.0,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
    sureBlackView.backgroundColor = [UIColor blackColor];
    sureBlackView.alpha = 0.3;
    [self.view addSubview:sureBlackView];
    
    sureWhiteView = [[UIView alloc]init];
    sureWhiteView.backgroundColor = [UIColor whiteColor];
    sureWhiteView.layer.cornerRadius = 5.0;
    sureWhiteView.frame = CGRectMake((self.view.frame.size.width - 250.0)/2.0,
                                     250.0,
                                     250.0,
                                     57.0);
    [self.view addSubview:sureWhiteView];
    
    UILabel* calllabel = [[UILabel alloc]init];
    calllabel.font = [UIFont systemFontOfSize:16.0];
    calllabel.textColor = UIColorFromRGB(244.0, 127.0, 64.0);
    calllabel.frame = CGRectMake(72.0, 12.0, 190.0, 30.0);
    calllabel.text = @"清除缓存成功 ";
    [sureWhiteView addSubview:calllabel];
    
    [self performSelector:@selector(sureClearCache) withObject:nil afterDelay:2];
    
}

- (void)sureClearCache
{
    
    
    [sureBlackView removeFromSuperview];
    [sureWhiteView removeFromSuperview];
    [mainTableView deselectRowAtIndexPath:[mainTableView indexPathForSelectedRow]  animated:YES];
    
    //清除url cache
    [[NSURLCache sharedURLCache]removeAllCachedResponses];
    
    //清除图片缓存
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache]clearMemory];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (void)backHomeVCMethod
{
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SELECTED_HOME_ITEM_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];
    
}

//退出
- (void)goBackMethod:(UIButton*)bt{
    
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:LOGIN_USER_NAME];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:LOGIN_PASSWORD];
    isTipsLogin = YES;
    [self viewWillAppear:YES];
    
    
}

- (void)loginMethod
{
    //login
    MemberLoginViewController* loginVC = [[MemberLoginViewController alloc]init];
    UINavigationController* na = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:na animated:YES completion:nil];
    
    
}

- (void)changePersonInfomation:(NSNotification*)notification
{
 
    NSDictionary* dic = [notification userInfo];
    
    telephoneLabel.text = [dic objectForKey:@"username"];
    
    [[NSUserDefaults standardUserDefaults]setObject:telephoneLabel.text forKey:USER_NAME];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
}
//获取会员信息
- (void)memberInfoMation
{
 
    
    dispatch_queue_t queue = dispatch_queue_create("memberInfoQueue", NULL);

    dispatch_async(queue, ^{
        
        Member* member = [Member shareMember];
        NSLog(@"%@",member.memberID);
        
        Result* result =[ManagerMember memberInfomation:member.memberID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.isSuccess) {
                
                Member* member = [Member shareMember];
                member = result.data;
                
                NSLog(@"member = %@",member.loginUsername);
                
                NSLog(@"%@",member.loginAppTime);
                
                NSString* greetString = [member.loginAppTime stringByAppendingString:@","];
                
                NSString* greetloginString = [greetString stringByAppendingString:@"欢迎登录置业宝 !"];
                
                greetLabel.text = greetloginString;
            }
            
            
        });
        
        
        
        
    });
}

@end
