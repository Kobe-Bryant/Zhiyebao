//
//  HomeListViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-4-30.
//
//

#define RENT_TABLE_TAG 0011
#define SELL_TABLE_TAG 0012
#define LIMIT 10

#import "HomeListViewController.h"
#import "RentDetailViewController.h"
#import "HomeViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "Macros.h"
#import "RentCell.h"
#import "MainViewController.h"

#import "House.h"
#import "SystemSetting.h"
#import "PullDownControl.h"
#import "CustomMarcos.h"

@interface HomeListViewController ()
{
    UISegmentedControl *segmentedControl;
    UITableView* rentTableView;
    UITableView* sellTableView;
    NSMutableArray* rentHouseArray;
    NSMutableArray* sellHouseArray;
    BOOL isRent;
    BOOL isSell;
    UIScrollView* mainScrollView;
    BOOL isEnter;
    UILabel* rentLabel;
    UILabel* sellLabel;
    
    UIView* bottomLeftView;
    UIView* bottomRightView;
    UIImage* unselectImage;
    UIImage* selectedImage;
    UIImageView* runImageView;
    UIButton* sellButton;
    UIButton* rentButton;
    
    BOOL isLoadingRentData;
    NSUInteger rentOffset;
    BOOL isLoadingSellData;
    NSUInteger sellOffset;
    
}

@property (nonatomic, retain) NSArray *areaIDArray;
@property (nonatomic, retain) NSArray *houseTypeIDArray;
@property (nonatomic, retain) NSArray *rentPriceIDArray;
@property (nonatomic, retain) NSArray *proportionIDArray;

@end

@implementation HomeListViewController

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


    segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"租房", @"买房"]];
    segmentedControl.tintColor = [UIColor whiteColor];
    [segmentedControl setWidth:90.0 forSegmentAtIndex:0];
    [segmentedControl setWidth:90.0 forSegmentAtIndex:1];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl addTarget:self
                         action:@selector(segmentedControlChanged:)
               forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    
    //rightBarButtonItem
    UIImage* rightImage = [UIImage imageNamed:@"filter.png"];
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0.0,
                                   0.0,
                                   rightImage.size.width,
                                   rightImage.size.height);
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [rightButton setTitle:@"筛选" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(rightButtonMethod)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    

    // set default value
    self.areaIDArray = [[NSArray alloc] init];
    self.houseTypeIDArray = [[NSArray alloc] init];
    self.rentPriceIDArray = [[NSArray alloc] init];
    self.proportionIDArray = [[NSArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [rentTableView deselectRowAtIndexPath:[rentTableView indexPathForSelectedRow] animated:YES];
    [sellTableView deselectRowAtIndexPath:[sellTableView indexPathForSelectedRow] animated:YES];

    
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterSidebarChanged:)
                                                 name:FILTER_SIDEBR_OPTION_CHANGED_NOTIFICATION
                                               object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushHouseDetail:)
                                                 name:PUSH_PRODUCT_NOTIFICATION
                                               object:nil];
    
    if (isEnter) {
        return;
    } else {
        isEnter = YES;
    }
    
    
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0,
                                                                   0.0,
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height)];
    NSLog(@"mainScrollView %@", NSStringFromCGRect(mainScrollView.frame));
//    NSLog(@"self.tabBarController.tabBar.frame.size.height %f", self.parentViewController.tabBarController.tabBar.frame.size.height);
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width * 2.0,
                                            mainScrollView.frame.size.height);
    mainScrollView.pagingEnabled = YES;
    mainScrollView.delegate = self;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.scrollEnabled = NO;
    [self.view addSubview:mainScrollView];
    
    
    //创建rentTableView
    rentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0,
                                                                  0.0,
                                                                  mainScrollView.frame.size.width,
                                                                  mainScrollView.frame.size.height)
                                                 style:UITableViewStylePlain];
    rentTableView.delegate = self;
    rentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rentTableView.dataSource = self;
    rentTableView.userInteractionEnabled = YES;
    rentTableView.tag = RENT_TABLE_TAG;
    rentTableView.backgroundColor = UIColorFromRGB(255.0, 248.0, 238.0);
    [mainScrollView addSubview:rentTableView];
    
    
    PullDownControl *rentTablePullDownControl = [[PullDownControl alloc] init];
    rentTablePullDownControl.frame = CGRectMake(0.0, 0.0, rentTableView.frame.size.width, 60.0);
    [rentTablePullDownControl changeStatus:PullDownControlReleaseStatus];
    rentTableView.tableHeaderView = rentTablePullDownControl;
    rentTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);


    rentTableView.tableFooterView = [[UIView alloc] init];
    rentTableView.tableFooterView.frame = CGRectMake(0.0,
                                                     0.0,
                                                     rentTableView.frame.size.width,
                                                     60.0);
    rentTableView.tableFooterView.hidden = YES;
    UIActivityIndicatorView *rentTableActivityIndicatorView = [[UIActivityIndicatorView alloc] init];
    rentTableActivityIndicatorView.frame = CGRectMake(0.0,
                                                      0.0,
                                                      rentTableView.tableFooterView.frame.size.width,
                                                      rentTableView.tableFooterView.frame.size.height);
    rentTableActivityIndicatorView.color = UIColorFromRGB(233.0, 116.0, 44.0);
    [rentTableActivityIndicatorView startAnimating];
    [rentTableView.tableFooterView addSubview:rentTableActivityIndicatorView];
    
    
    
    
    //创建sellTableView
    sellTableView = [[UITableView alloc]initWithFrame:CGRectMake(mainScrollView.frame.size.width,
                                                                 0.0,
                                                                 mainScrollView.frame.size.width,
                                                                 mainScrollView.frame.size.height)
                                                style:UITableViewStylePlain];
    sellTableView.delegate = self;
    sellTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    sellTableView.dataSource = self;
    sellTableView.userInteractionEnabled = YES;
    sellTableView.backgroundColor = UIColorFromRGB(255.0, 248.0, 238.0);
    sellTableView.tag = SELL_TABLE_TAG;
    [mainScrollView addSubview:sellTableView];
    
    PullDownControl *sellTablePullDownControl = [[PullDownControl alloc] init];
    sellTablePullDownControl.frame = CGRectMake(0.0, 0.0, sellTableView.frame.size.width, 60.0);
    [sellTablePullDownControl changeStatus:PullDownControlRefreshingStatus];
    sellTableView.tableHeaderView = sellTablePullDownControl;
    sellTableView.contentInset = UIEdgeInsetsMake(sellTableView.tableHeaderView.frame.size.height * -1.0,
                                                  0.0,
                                                  0.0,
                                                  0.0);

    sellTableView.tableFooterView = [[UIView alloc] init];
    sellTableView.tableFooterView.frame = CGRectMake(0.0,
                                                     0.0,
                                                     sellTableView.frame.size.width,
                                                     60.0);
    sellTableView.tableFooterView.hidden = YES;
    UIActivityIndicatorView *sellTableActivityIndicatorView = [[UIActivityIndicatorView alloc] init];
    sellTableActivityIndicatorView.frame = CGRectMake(0.0,
                                                      0.0,
                                                      sellTableView.tableFooterView.frame.size.width,
                                                      sellTableView.tableFooterView.frame.size.height);
    sellTableActivityIndicatorView.color = UIColorFromRGB(233.0, 116.0, 44.0);
    [sellTableActivityIndicatorView startAnimating];
    [sellTableView.tableFooterView addSubview:sellTableActivityIndicatorView];

    

    
    // load data
    [self scrollViewDidEndDragging:rentTableView willDecelerate:YES];
    //[self refreshSellData];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ENABLED_VIEW_DECK_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DISABLED_VIEW_DECK_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)refreshData
{
    NSLog(@"refreshData");
    NSLog(@"%@", self.areaIDArray);

    
    if (segmentedControl.selectedSegmentIndex == 0) {
        PullDownControl *pullDownControl = (PullDownControl *)rentTableView.tableHeaderView;
        [pullDownControl changeStatus:PullDownControlRefreshingStatus];
        rentOffset = 0;
        [UIView animateWithDuration:0.25 animations:^{
            rentTableView.contentOffset = CGPointZero;
            rentTableView.contentInset = UIEdgeInsetsMake(rentTableView.tableHeaderView.frame.size.height * -1.0, 0.0, 0.0, 0.0);

        } completion:^(BOOL finished) {
            [self refreshRentData];
        }];
    } else {
        PullDownControl *pullDownControl = (PullDownControl *)sellTableView.tableHeaderView;
        [pullDownControl changeStatus:PullDownControlRefreshingStatus];
        sellOffset = 0;
        [UIView animateWithDuration:0.25 animations:^{
            sellTableView.contentOffset = CGPointZero;
            sellTableView.contentInset = UIEdgeInsetsMake(sellTableView.tableHeaderView.frame.size.height * -1.0, 0.0, 0.0, 0.0);
        } completion:^(BOOL finished) {
            [self refreshSellData];
        }];
    }
}

- (void)refreshRentData
{
    NSLog(@"refreshRentData");

    if (isLoadingRentData) {
        return;
    } else {
        isLoadingRentData = YES;
    }
    
    
    rentTableView.tableFooterView.hidden = YES;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{        
        rentOffset = 0;
        Result *result = [House requestListWithMessageType:HouseMessageTypeRent
                                                          isRecommend:YES
                                                          areaIDArray:self.areaIDArray
                                                     houseTypeIDArray:self.houseTypeIDArray
                                                     rentPriceIDArray:self.rentPriceIDArray
                                                    proportionIDArray:self.proportionIDArray
                                                               offset:rentOffset
                                                                limit:LIMIT];
        
        
        NSLog(@"iiii===%d",[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus);
        

        
        if (result.isSuccess) {
            
        rentHouseArray = [[NSMutableArray alloc] initWithArray:result.data];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [rentTableView reloadData];
                rentOffset += LIMIT;
                
        
                
                
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
        PullDownControl *pullDownControl = (PullDownControl *)rentTableView.tableHeaderView;
        [UIView animateWithDuration:0.25 animations:^{
            rentTableView.contentInset = UIEdgeInsetsMake(rentTableView.tableHeaderView.frame.size.height * -1.0, 0.0, 0.0, 0.0);
        } completion:^(BOOL finished) {
            [pullDownControl changeStatus:PullDownControlNormalStatus];
            isLoadingRentData = NO;
        }];
    });
}

- (void)appendRentRows
{
    if (isLoadingRentData == NO) {
        isLoadingRentData = YES;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            Result *result = [House requestListWithMessageType:HouseMessageTypeRent
                                                   isRecommend:YES
                                                   areaIDArray:self.areaIDArray
                                              houseTypeIDArray:self.houseTypeIDArray
                                              rentPriceIDArray:self.rentPriceIDArray
                                             proportionIDArray:self.proportionIDArray
                                                        offset:rentOffset
                                                         limit:LIMIT];
            if (result.isSuccess) {
                NSArray *houseArray = result.data;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [rentTableView beginUpdates];
                    NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
                    for (NSUInteger i = 0; i < [houseArray count]; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([rentHouseArray count] + i) inSection:0];
                        [indexPathArray addObject:indexPath];
                    }
                    [rentTableView insertRowsAtIndexPaths:indexPathArray
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
                    [rentHouseArray addObjectsFromArray:houseArray];
                    [rentTableView endUpdates];
                    if ([houseArray count] > 0) {
                        rentOffset += LIMIT;
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
            rentTableView.tableFooterView.hidden = YES;
            isLoadingRentData = NO;
        });
    }
}

- (void)refreshSellData
{
    NSLog(@"refreshSellData");
    
    if (isLoadingSellData) {
        return;
    } else {
        isLoadingSellData = YES;
    }
    
    sellTableView.tableFooterView.hidden = YES;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        sleep(1);
        
        sellOffset = 0;
        Result *result = [House requestListWithMessageType:HouseMessageTypeSell
                                               isRecommend:YES
                                               areaIDArray:self.areaIDArray
                                          houseTypeIDArray:self.houseTypeIDArray
                                          rentPriceIDArray:self.rentPriceIDArray
                                         proportionIDArray:self.proportionIDArray
                                                    offset:sellOffset
                                                     limit:LIMIT];
        if (result.isSuccess) {
            NSLog(@"isSuccess");
            sellHouseArray = [[NSMutableArray alloc] initWithArray:result.data];
            NSLog(@"result.data %@", result.data);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"sellTableView reloadData");
                [sellTableView reloadData];
                sellOffset += LIMIT;
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
        PullDownControl *pullDownControl = (PullDownControl *)sellTableView.tableHeaderView;
        [UIView animateWithDuration:0.25 animations:^{
            sellTableView.contentInset = UIEdgeInsetsMake(sellTableView.tableHeaderView.frame.size.height * -1.0,
                                                          0.0,
                                                          0.0,
                                                          0.0);
        } completion:^(BOOL finished) {
            [pullDownControl changeStatus:PullDownControlNormalStatus];
            isLoadingSellData = NO;
            sellTableView.tableFooterView.hidden = YES;
        }];
    });
}

- (void)appendSellRows
{
    if (isLoadingSellData == NO) {
        isLoadingSellData = YES;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            Result *result = [House requestListWithMessageType:HouseMessageTypeSell
                                                   isRecommend:YES
                                                   areaIDArray:self.areaIDArray
                                              houseTypeIDArray:self.houseTypeIDArray
                                              rentPriceIDArray:self.rentPriceIDArray
                                             proportionIDArray:self.proportionIDArray
                                                        offset:sellOffset
                                                         limit:LIMIT];
            if (result.isSuccess) {
                NSArray *houseArray = result.data;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [sellTableView beginUpdates];
                    NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
                    for (NSUInteger i = 0; i < [houseArray count]; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([sellHouseArray count] + i)
                                                                    inSection:0];
                        [indexPathArray addObject:indexPath];
                    }
                    [sellTableView insertRowsAtIndexPaths:indexPathArray
                                         withRowAnimation:UITableViewRowAnimationAutomatic];
                    [sellHouseArray addObjectsFromArray:houseArray];
                    [sellTableView endUpdates];
                    if ([houseArray count] > 0) {
                        sellOffset += LIMIT;
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
            sellTableView.tableFooterView.hidden = YES;
            isLoadingSellData = NO;
        });
    }
}

#pragma mark UITableviewDatasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == RENT_TABLE_TAG) {
        return rentHouseArray.count;
    } else {
        return sellHouseArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdenty = @"cellidenty";
    
    RentCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdenty];
    if (cell == nil) {
        cell = [[RentCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                               reuseIdentifier:cellIdenty];
    }
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = UIColorFromRGB(255.0, 248.0, 238.0);
    } else {
        cell.backgroundColor = UIColorFromRGB(255.0, 244.0, 230.0);
    }
    
    if (tableView.tag == RENT_TABLE_TAG)  {
        //为cell赋值
        [cell setCellInfo:rentHouseArray[indexPath.row]];
    } else {
        [cell setCellInfo:sellHouseArray[indexPath.row]];
    }
    
    
    UIView* selectView = [[UIView alloc]init];
    UIImage* image = [UIImage imageNamed:@"sellselectbackImage.png"];
    selectView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    cell.selectedBackgroundView = selectView;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segmentedControl.selectedSegmentIndex == 0) {
        House *house = [rentHouseArray objectAtIndex:indexPath.row];
        house.houseMessageType = HouseMessageTypeRent;
        RentDetailViewController* rentDetail = [[RentDetailViewController alloc] initWithDataObject:house.houseID];
        rentDetail.house = house;
        rentDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rentDetail animated:YES];
    } else {
        House *house = [sellHouseArray objectAtIndex:indexPath.row];
        house.houseMessageType = HouseMessageTypeSell;
        RentDetailViewController* rentDetail = [[RentDetailViewController alloc] initWithDataObject:house.houseID];
        rentDetail.house = house;
        rentDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rentDetail animated:YES];
    }
}

-  (void)rightButtonMethod
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_FILTER_SIDEBR_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];

}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
    NSLog(@"scrollView %@", scrollView);
    
    NSLog(@"1111111scrollView.contentOffset.y =  %f",scrollView.contentOffset.y);
    
     //PullDownControlReleaseStatus
    
//    PullDownControlNormalStatus                = 0,
//    PullDownControlReleaseStatus               = 1,
//    PullDownControlRefreshingStatus            = 2
    
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        
        PullDownControl *pullDownControl = (PullDownControl *)rentTableView.tableHeaderView;
        
        NSLog(@"pullDownControl.status = %d",pullDownControl.status);
        
        
        if (pullDownControl.status != PullDownControlReleaseStatus
            && pullDownControl.status != PullDownControlRefreshingStatus) {
            
            
            NSLog(@"scrollView.contentOffset.y = %f",scrollView.contentOffset.y);
            
            
            if (scrollView.contentOffset.y >= 0.0) {
                [pullDownControl changeStatus:PullDownControlNormalStatus];
            } else {
                [pullDownControl changeStatus:PullDownControlReleaseStatus];
            }
        }
        
        
        if (pullDownControl.status == PullDownControlNormalStatus
            && scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height
            && rentTableView.tableFooterView.hidden == YES
            && (rentHouseArray.count == 0 || (rentHouseArray.count > 0 && rentHouseArray.count >= LIMIT))) {
            rentTableView.tableFooterView.hidden = NO;
            rentTableView.contentSize = CGSizeMake(rentTableView.contentSize.width,
                                                   rentTableView.contentSize.height + rentTableView.tableFooterView.frame.size.height);
        }
        
        
        
        
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        PullDownControl *pullDownControl = (PullDownControl *)sellTableView.tableHeaderView;
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
            && sellTableView.tableFooterView.hidden == YES
            && (sellHouseArray.count == 0 || (sellHouseArray.count > 0 && sellHouseArray.count >= LIMIT))) {
            if (isLoadingSellData == NO) {
                sellTableView.tableFooterView.hidden = NO;
                sellTableView.contentSize = CGSizeMake(sellTableView.contentSize.width,
                                                       sellTableView.contentSize.height + sellTableView.tableFooterView.frame.size.height);
            }
        }
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging");
    
 
    if (segmentedControl.selectedSegmentIndex == 0) {
        PullDownControl *pullDownControl = (PullDownControl *)rentTableView.tableHeaderView;
        if (pullDownControl.status == PullDownControlReleaseStatus) {
            [pullDownControl changeStatus:PullDownControlRefreshingStatus];
            [UIView animateWithDuration:0.25 animations:^{
                rentTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            } completion:^(BOOL finished) {
                [self refreshRentData];
            }];
        }
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        PullDownControl *pullDownControl = (PullDownControl *)sellTableView.tableHeaderView;
        if (pullDownControl.status == PullDownControlReleaseStatus) {
            [pullDownControl changeStatus:PullDownControlRefreshingStatus];
            [UIView animateWithDuration:0.25 animations:^{
                sellTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            } completion:^(BOOL finished) {
                [self refreshSellData];
            }];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    return;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
            [self appendRentRows];
        }
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
            [self appendSellRows];
        }
    }
}

- (void)segmentedControlChanged:(UISegmentedControl *)_segmentedControl
{

    self.areaIDArray = [[NSArray alloc] init];
    self.houseTypeIDArray = [[NSArray alloc] init];
    self.rentPriceIDArray = [[NSArray alloc] init];
    self.proportionIDArray = [[NSArray alloc] init];
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:FILTER_SIDEBR_TYPE_CHANGED_NOTIFICATION
                                                            object:self
                                                          userInfo:@{FILTER_SIDEBR_TYPE: @"rent"}];
        
        [UIView animateWithDuration:0.25 animations:^{
            mainScrollView.contentOffset = CGPointMake(0.0, 0.0);
            rentTableView.tableFooterView.hidden = YES;
        }];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:FILTER_SIDEBR_TYPE_CHANGED_NOTIFICATION
                                                            object:self
                                                          userInfo:@{FILTER_SIDEBR_TYPE: @"sell"}];
        
        [UIView animateWithDuration:0.25 animations:^{
            mainScrollView.contentOffset = CGPointMake(mainScrollView.frame.size.width, 0.0);
            sellTableView.tableFooterView.hidden = YES;
        }];
    }
}

- (void)filterSidebarChanged:(NSNotification *)notification
{
    NSLog(@"filterSidebarChanged %@", notification);
    
    _areaIDArray = [notification.userInfo objectForKey:AREA_KEY];
    _houseTypeIDArray = [notification.userInfo objectForKey:HOUSE_TYPE_KEY];
    _rentPriceIDArray = [notification.userInfo objectForKey:RENT_PRICE_KEY];
    _proportionIDArray = [notification.userInfo objectForKey:PROPORTION_KEY];
    [self refreshData];
}
- (void)pushHouseDetail:(NSNotification*)notification
{

    NSDictionary* houseDic = notification.object;
    NSString* houseId = [houseDic objectForKey:@"houseID"];
    
    NSLog(@"houseId = %@",houseId);
    
    NSLog(@"%@",self.navigationController);
  
   
    RentDetailViewController* rentDetail = [[RentDetailViewController alloc] initWithDataObject:houseId];
    rentDetail.hidesBottomBarWhenPushed = YES;
    rentDetail.changeBarColor = YES;
    [self.navigationController pushViewController:rentDetail animated:YES];
    
}

@end
