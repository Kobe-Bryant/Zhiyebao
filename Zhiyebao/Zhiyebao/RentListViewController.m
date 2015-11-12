//
//  RentListViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-4-30.
//
//

#define LIMIT 10

#import "RentListViewController.h"
#import "RentDetailViewController.h"
#import "AreaSelectorViewController.h"

#import "RentModel.h"
#import "Macros.h"
#import "RentCell.h"
#import "PullDownControl.h"
#import "CustomMarcos.h"
#import "House.h"
#import "SystemSetting.h"

@interface RentListViewController ()
{
    NSMutableArray* rentHouseArray;
    UILabel* updateLabel;
    UIView* headView;
    UILabel* footviewLabel;
    UIImageView* refreshImageView;
    BOOL isLoading;
    UIActivityIndicatorView* activityView;
    UILabel* addDataLable;
    BOOL isViewWillAppeared;
    BOOL isViewDidApeared;
    NSUInteger offset;
}

@property (nonatomic, retain) NSArray *areaIDArray;
@property (nonatomic, retain) NSArray *houseTypeIDArray;
@property (nonatomic, retain) NSArray *rentPriceIDArray;
@property (nonatomic, retain) NSArray *proportionIDArray;


@end

@implementation RentListViewController

@synthesize areaIDArray;

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
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20.0];
    titleLabel.text = @"租房";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    
    //rightBarButtonItem
    UIImage* rightImage = [UIImage imageNamed:@"filter.png"];
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0.0,
                                   0.0,
                                   rightImage.size.width,
                                   rightImage.size.height);
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [rightButton setTitle:@"筛选" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[rightButton titleLabel] setFont:[UIFont systemFontOfSize:12.0]];
    [rightButton addTarget:self action:@selector(filterButtonMethod)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    UIImage* image = [UIImage imageNamed:@"BackHome.png"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0.0,
                                  0.0,
                                  image.size.width,
                                  image.size.height);
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backHomeVCMethod)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
    // set default attr
    self.areaIDArray = [[NSArray alloc] init];
    self.houseTypeIDArray = [[NSArray alloc] init];
    self.rentPriceIDArray = [[NSArray alloc] init];
    self.proportionIDArray = [[NSArray alloc] init];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    // Notification
    [[NSNotificationCenter defaultCenter] postNotificationName:FILTER_SIDEBR_TYPE_CHANGED_NOTIFICATION
                                                        object:self
                                                      userInfo:@{FILTER_SIDEBR_TYPE: @"rent"}];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterSidebarChanged:)
                                                 name:FILTER_SIDEBR_OPTION_CHANGED_NOTIFICATION
                                               object:nil];
    
    
    if (isViewWillAppeared) {
        return;
    } else {
        isViewWillAppeared = YES;
    }
    
    NSLog(@"RentListViewController viewWillAppear");

    
    NSLog(@"self.view.frame %@", NSStringFromCGRect(self.view.frame) );
    NSLog(@"self.tableView.frame %@", NSStringFromCGRect(self.tableView.frame) );


    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(255.0, 248.0, 238.0);

    
    PullDownControl *pullDownControl = [[PullDownControl alloc] init];
    pullDownControl.frame = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 60.0);
    [pullDownControl changeStatus:PullDownControlReleaseStatus];
    self.tableView.tableHeaderView = pullDownControl;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.tableHeaderView.frame.size.height * -1.0,
                                                   0.0,
                                                   0.0,
                                                   0.0);


    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableFooterView.frame = CGRectMake(0.0,
                                                      0.0,
                                                      self.tableView.frame.size.width,
                                                      60.0);
    self.tableView.tableFooterView.hidden = YES;
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    activityIndicatorView.frame = CGRectMake(0.0,
                                             0.0,
                                             self.tableView.tableFooterView.frame.size.width,
                                             self.tableView.tableFooterView.frame.size.height);
    activityIndicatorView.color = UIColorFromRGB(233.0, 116.0, 44.0);
    [activityIndicatorView startAnimating];
    [self.tableView.tableFooterView addSubview:activityIndicatorView];

    
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Notification
    [[NSNotificationCenter defaultCenter] postNotificationName:ENABLED_VIEW_DECK_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];

    
    if (isViewDidApeared) {
        return;
    } else {
        isViewDidApeared = YES;
    }
    
    //为AreaSelectorViewController创建一个透明的位图既截屏。
    UIGraphicsBeginImageContext(self.parentViewController.tabBarController.view.bounds.size);
    [self.parentViewController.tabBarController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    
    
    
    
    AreaSelectorViewController *areaSelectorVC = [[AreaSelectorViewController alloc] initWithBackgroundImage:screenImage];
    CGRect mainRect = [[UIScreen mainScreen] bounds];
    areaSelectorVC.view.frame = CGRectMake(0.0, 0.0, mainRect.size.width, mainRect.size.height);
    areaSelectorVC.delegate = self;
    [self presentViewController:areaSelectorVC animated:YES completion:nil];

}

- (void)refreshRentData
{
    NSLog(@"refreshRentData");
    
    if (isLoading) {
        return;
    } else {
        isLoading = YES;
    }
    
    
//    self.tableView.tableFooterView.hidden = YES;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        sleep(1);
        
        offset = 0;
        Result *result = [House requestListWithMessageType:HouseMessageTypeRent
                                               isRecommend:NO
                                               areaIDArray:self.areaIDArray
                                          houseTypeIDArray:self.houseTypeIDArray
                                          rentPriceIDArray:self.rentPriceIDArray
                                         proportionIDArray:self.proportionIDArray
                                                    offset:offset
                                                     limit:LIMIT];
        if (result.isSuccess) {
            rentHouseArray = [[NSMutableArray alloc] initWithArray:result.data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                offset += LIMIT;
                NSLog(@"self.tableView %@", self.tableView) ;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:result.error.localizedDescription
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        PullDownControl *pullDownControl = (PullDownControl *)self.tableView.tableHeaderView;
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.tableHeaderView.frame.size.height * -1.0,
                                                           0.0,
                                                           0.0,
                                                           0.0);
        } completion:^(BOOL finished) {
            [pullDownControl changeStatus:PullDownControlNormalStatus];
            isLoading = NO;
        }];
    });
}

- (void)appendRentRows
{
    if (isLoading == NO) {
        isLoading = YES;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            Result *result = [House requestListWithMessageType:HouseMessageTypeRent
                                                   isRecommend:NO
                                                   areaIDArray:self.areaIDArray
                                              houseTypeIDArray:self.houseTypeIDArray
                                              rentPriceIDArray:self.rentPriceIDArray
                                             proportionIDArray:self.proportionIDArray
                                                        offset:offset
                                                         limit:LIMIT];
            if (result.isSuccess) {
                NSArray *houseArray = result.data;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView beginUpdates];
                    NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
                    for (NSUInteger i = 0; i < [houseArray count]; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([rentHouseArray count] + i) inSection:0];
                        [indexPathArray addObject:indexPath];
                    }
                    [self.tableView insertRowsAtIndexPaths:indexPathArray
                                         withRowAnimation:UITableViewRowAnimationAutomatic];
                    [rentHouseArray addObjectsFromArray:houseArray];
                    [self.tableView endUpdates];
                    if ([houseArray count] > 0) {
                        offset += LIMIT;
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:result.error.localizedDescription
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                });
            }
        });
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            self.tableView.tableFooterView.hidden = YES;
            isLoading = NO;
        });
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DISABLED_VIEW_DECK_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];
    
}

#pragma mark UITableviewDatasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rentHouseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellidenty = @"cellidenty";
    
    RentCell* cell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
    
    if (cell == nil) {
        
        cell = [[RentCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                              reuseIdentifier:cellidenty];
        
    }
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = UIColorFromRGB(250.0, 244.0, 234.0);
    } else {
        cell.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
    }
    
    
    //为cell赋值
    [cell setCellInfo:rentHouseArray[indexPath.row]];

    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    House *house = [rentHouseArray objectAtIndex:indexPath.row];
    RentDetailViewController* rentDetail = [[RentDetailViewController alloc] initWithDataObject:house.houseID];
    rentDetail.hidesBottomBarWhenPushed = YES;
    NSLog(@"self.parentViewController %@", self.parentViewController);
    [self.navigationController pushViewController:rentDetail animated:YES];
    
}

//帅选的按钮点击方法
-  (void)filterButtonMethod
{
    
//    [self.toggleDelegate toggleClickButton:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_FILTER_SIDEBR_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
    NSLog(@"scrollView %@", scrollView);
    
    PullDownControl *pullDownControl = (PullDownControl *)self.tableView.tableHeaderView;
    if (pullDownControl.status != PullDownControlReleaseStatus
        && pullDownControl.status != PullDownControlRefreshingStatus) {
        if (scrollView.contentOffset.y >= 0.0) {
            [pullDownControl changeStatus:PullDownControlNormalStatus];
        } else {
            [pullDownControl changeStatus:PullDownControlReleaseStatus];
        }
    }
    
    
    if (pullDownControl.status == PullDownControlNormalStatus
        && scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height
        && self.tableView.tableFooterView.hidden == YES) {
        if (isLoading == NO) {
            self.tableView.tableFooterView.hidden = NO;
            self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,
                                                    self.tableView.contentSize.height + self.tableView.tableFooterView.frame.size.height);
        }
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging");
    
    PullDownControl *pullDownControl = (PullDownControl *)self.tableView.tableHeaderView;
    if (pullDownControl.status == PullDownControlReleaseStatus) {
        [pullDownControl changeStatus:PullDownControlRefreshingStatus];
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        } completion:^(BOOL finished) {
            [self refreshRentData];
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    PullDownControl *pullDownControl = (PullDownControl *)self.tableView.tableHeaderView;
    if (pullDownControl.status == PullDownControlNormalStatus
        && scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
        [self appendRentRows];
    }
}


- (void)backHomeVCMethod
{
    NSLog(@"backHomeVCMethod");
//    NSLog(@"self.tabBarController %@", self.homeViewController);
//    MainViewController *mainVC = (MainViewController *)self.parentViewController.tabBarController;
//    [mainVC changeTabBarSelectedIndex:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SELECTED_HOME_ITEM_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];

}

- (void)refreshData
{
    NSLog(@"refreshData");

    PullDownControl *pullDownControl = (PullDownControl *)self.tableView.tableHeaderView;
    [pullDownControl changeStatus:PullDownControlRefreshingStatus];
    offset = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.contentOffset = CGPointZero;
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.tableHeaderView.frame.size.height * -1.0,
                                                       0.0,
                                                       0.0,
                                                       0.0);
    } completion:^(BOOL finished) {
        [self refreshRentData];
    }];


}

#pragma mark RentListViewControllertoggleBackDelegate
- (void)setAreaIDArrayAtSelector:(NSArray *)updateAreaIDArray
{
    NSLog(@"setAreaIDArray %@", updateAreaIDArray);
    self.areaIDArray = updateAreaIDArray;
    [self refreshData];
}

- (void)filterSidebarChanged:(NSNotification *)notification
{
    NSLog(@"filterSidebarChanged %@", notification);
    
    self.areaIDArray = [notification.userInfo objectForKey:AREA_KEY];
    self.houseTypeIDArray = [notification.userInfo objectForKey:HOUSE_TYPE_KEY];
    self.rentPriceIDArray = [notification.userInfo objectForKey:RENT_PRICE_KEY];
    self.proportionIDArray = [notification.userInfo objectForKey:PROPORTION_KEY];
    [self refreshData];
}


@end

