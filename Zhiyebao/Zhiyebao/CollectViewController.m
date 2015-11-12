//
//  CollectViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-4-29.
//
//

#define LIMIT 10

#import "CollectViewController.h"
#import "Macros.h"
#import "RentModel.h"
#import "CollectHouseCell.h"
#import "RentDetailViewController.h"
#import "Result.h"
#import "ManagerMember.h"
#import "PullDownControl.h"
#import "CustomMarcos.h"

@interface CollectViewController ()
{

    NSMutableArray* collectArray;
    UITableView* mainTableView;
    UIImageView* refreshImageView;
    UILabel* updateLable ;
    UIView* headView ;
    UIActivityIndicatorView* activityView ;
    UILabel* addDataLable ;
    BOOL isLoading;
    UILabel* footviewLabel;
    int count ;
    UIButton* rightButton;
    UIButton* rightItemButton;
    
    
}
@property(nonatomic,strong) UIImageView* emptyImageView;
@property(nonatomic,strong) UILabel* emptyLable;
@property(nonatomic,assign) int offset;

//获取收藏信息列表
- (void)loadCollectHouseList;

@end

@implementation CollectViewController

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
    
    self.view.backgroundColor = UIColorFromRGB(255.0, 248.0, 238.0);

    
     self.title = @"收藏夹";
    
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
 
    
    //返回的leftBarButtonItem
    rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame = CGRectMake(280.0, 5.0, 40.0, 30.0);
    [rightItemButton setTitle:@"编辑" forState:UIControlStateNormal];
    rightItemButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    rightItemButton.titleLabel.textColor = [UIColor whiteColor];
    [rightItemButton addTarget:self action:@selector(DeleteCellRow:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightItemButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    collectArray = [NSMutableArray array];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear: animated];
    
    
    // Remove all subviews
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    [self loadCollectHouseList];
    
    self.emptyImageView = [[UIImageView alloc]init];
    UIImage* emptyImage = [UIImage imageNamed:@"emptyHouseImage.png"];
    if ([UIScreen mainScreen].bounds.size.height > 480) {
        
        self.emptyImageView.frame = CGRectMake(100.0,
                                               200.0,
                                               emptyImage.size.width,
                                               emptyImage.size.height);
    }else {
        
        self.emptyImageView.frame = CGRectMake(100.0,
                                               100.0,
                                               emptyImage.size.width,
                                               emptyImage.size.height);
    }
    
    self.emptyImageView.image = emptyImage;
    self.emptyImageView.hidden = YES;
    [self.view addSubview:self.emptyImageView];
    
    
    self.emptyLable = [[UILabel alloc]init];
    if ([UIScreen mainScreen].bounds.size.height > 480) {
        
        self.emptyLable.frame = CGRectMake(80.0, 300.0, 200.0, 40.0);
        
    } else {
        
        self.emptyLable.frame = CGRectMake(80.0, 200.0, 200.0, 40.0);
        
        
    }
    self.emptyLable.font = [UIFont systemFontOfSize:12.0];
    self.emptyLable.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
    self.emptyLable.hidden = YES;
    self.emptyLable.text = @"抱歉，还没有找到收藏记录!";
    [self.view addSubview:self.emptyLable];
    
    
    

    
    //创建tableview
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0,
                                                                 0.0,
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height)
                                                style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundColor = UIColorFromRGB(255.0, 248.0, 238.0);
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.userInteractionEnabled = YES;
    [self.view addSubview:mainTableView];

    
    PullDownControl *pullDownControl = [[PullDownControl alloc] init];
    pullDownControl.frame = CGRectMake(0.0, 0.0, mainTableView.frame.size.width, 60.0);
    [pullDownControl changeStatus:PullDownControlReleaseStatus];
    mainTableView.tableHeaderView = pullDownControl;
   mainTableView.contentInset = UIEdgeInsetsMake(mainTableView.tableHeaderView.frame.size.height * -1, 0.0, 0.0, 0.0);
    
    
    mainTableView.tableFooterView = [[UIView alloc] init];
    mainTableView.tableFooterView.frame = CGRectMake(0.0,
                                                     0.0,
                                                     mainTableView.frame.size.width,
                                                     60.0);
    mainTableView.tableFooterView.hidden = YES;
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    activityIndicatorView.frame = CGRectMake(0.0,
                                             0.0,
                                             mainTableView.tableFooterView.frame.size.width,
                                             mainTableView.tableFooterView.frame.size.height);
    activityIndicatorView.color = UIColorFromRGB(233.0, 116.0, 44.0);
    [activityIndicatorView startAnimating];
    [mainTableView.tableFooterView addSubview:activityIndicatorView];

    
    // Load data
    [self scrollViewDidEndDragging:mainTableView willDecelerate:YES];

}

- (void)refreshData
{
    NSLog(@"refreshData");
    
    if (isLoading) {
        return;
    } else {
        isLoading = YES;
    }
    
    mainTableView.tableFooterView.hidden = YES;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        sleep(1);
        
        self.offset = 0;
        NSNumber* userId =[[NSUserDefaults standardUserDefaults] objectForKey:MEMBER_ID];
        Result* result = [ManagerMember getCollectHouseList:[userId intValue]
                                                     offset:self.offset
                                                     length:LIMIT];
        if (result.isSuccess) {
            collectArray = [[NSMutableArray alloc] initWithArray:result.data];
            dispatch_async(dispatch_get_main_queue(), ^{
            
                if (collectArray.count == 0) {
                    
                    mainTableView.hidden = YES;
                    self.emptyLable.hidden = NO;
                    self.emptyImageView.hidden = NO;
                    rightItemButton.hidden = YES;

                    
                } else {
                
                    self.emptyLable.hidden = YES;
                    self.emptyImageView.hidden = YES;
                    [mainTableView reloadData];
                    rightItemButton.hidden = NO;
                    self.offset += LIMIT;
                
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        PullDownControl *pullDownControl = (PullDownControl *)mainTableView.tableHeaderView;
        [UIView animateWithDuration:0.25 animations:^{
            mainTableView.contentInset = UIEdgeInsetsMake(mainTableView.tableHeaderView.frame.size.height * -1.0, 0.0, 0.0, 0.0);
        } completion:^(BOOL finished) {
            [pullDownControl changeStatus:PullDownControlNormalStatus];
        }];
        isLoading = NO;
        NSLog(@"pullDownControl %@", NSStringFromCGRect(pullDownControl.frame));
    });
}

- (void)appendRows
{
    if (isLoading == NO) {
        isLoading = YES;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            NSNumber* userId =[[NSUserDefaults standardUserDefaults] objectForKey:MEMBER_ID];
            Result* result = [ManagerMember getCollectHouseList:[userId intValue]
                                                         offset:self.offset
                                                         length:LIMIT];
            if (result.isSuccess) {
                NSArray *currentCollectArray = result.data;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mainTableView beginUpdates];
                    NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
                    for (NSUInteger i = 0; i < [currentCollectArray count]; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([currentCollectArray count] + i) inSection:0];
                        [indexPathArray addObject:indexPath];
                    }
                    [mainTableView insertRowsAtIndexPaths:indexPathArray
                                         withRowAnimation:UITableViewRowAnimationAutomatic];
                    [collectArray addObjectsFromArray:currentCollectArray];
                    [mainTableView endUpdates];
                    if ([currentCollectArray count] > 0) {
                        self.offset += LIMIT;
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
            mainTableView.tableFooterView.hidden = YES;
            isLoading = NO;
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
    
    return collectArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellidenty = @"cellidenty";
    
    CollectHouseCell* cell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
    
    if (cell==nil) {
        
        cell = [[CollectHouseCell alloc]initWithStyle:UITableViewCellStyleDefault
                              reuseIdentifier:cellidenty];
        
    }
    
    if (indexPath.row % 2 ==0) {
        
        
        cell.backgroundColor = UIColorFromRGB(250.0, 244.0, 234.0);
        
        
        
    }else {
        
        cell.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
        
    }
    

    //为cell赋值
    [cell setCellInfo:collectArray[indexPath.row]];
    
    return cell;
  
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return YES;
    
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{


    return UITableViewCellEditingStyleDelete;
    

}


//获取收藏的数据
- (void)loadCollectHouseList
{
    

    NSLog(@"self.offset = %d",self.offset);
    
    
    
    dispatch_queue_t queue  =  dispatch_queue_create("collectListQueue", NULL);
    dispatch_async(queue, ^{
        
        
        NSNumber* userId =[[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_ID];
        Result* result = [ManagerMember getCollectHouseList:[userId intValue] offset:self.offset length:LIMIT];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (result.isSuccess) {
                
                NSArray* array = result.data;
                
                for (House* house in array) {
                    
                    [collectArray addObject:house];
                    
                }
                
                if (collectArray.count == 0) {
                    mainTableView.hidden = YES;
                    self.emptyLable.hidden = NO;
                    self.emptyImageView.hidden = NO;
                    rightItemButton.hidden = YES;
                } else {
                    
                    self.emptyLable.hidden = YES;
                    self.emptyImageView.hidden = YES;
                    rightItemButton.hidden = NO;
                    [mainTableView reloadData];
                }
            }
            
        });
        
    });
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    House* house = collectArray[indexPath.row];
    NSLog(@"%@",house.houseID);
    RentDetailViewController* detailVC = [[RentDetailViewController alloc]initWithDataObject:house.houseID];
    detailVC.mainViewController = self;
    [self.navigationController pushViewController:detailVC animated:YES];

}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"commitEditingStyle");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"DEL");
        House *house = [collectArray objectAtIndex:indexPath.row];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            NSString* userId =[[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_ID];
            Result* result = [ManagerMember cancelCollectHouse:userId
                                                       houseId:[house.houseID intValue]];
            if (result.isSuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [collectArray removeObject:collectArray[indexPath.row]];
                    
                    [tableView beginUpdates];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [tableView endUpdates];
                    if (collectArray.count ==0) {
                        
                     [self loadCollectHouseList];
                        
                    }

                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                            message:result.error.localizedDescription
                                                                           delegate:self
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil, nil];
                        [alertView show];
                    });

                });
            }
        });

        
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
    NSLog(@"scrollView %@", scrollView);

    PullDownControl *pullDownControl = (PullDownControl *)mainTableView.tableHeaderView;
    if (pullDownControl.status != PullDownControlReleaseStatus
        && pullDownControl.status != PullDownControlRefreshingStatus) {
        if (scrollView.contentOffset.y >= 0.0) {
            [pullDownControl changeStatus:PullDownControlNormalStatus];
        } else {
            [pullDownControl changeStatus:PullDownControlReleaseStatus];
        }
    }
    
    
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height
        && mainTableView.tableFooterView.hidden == YES) {
        if (isLoading == NO) {
            mainTableView.tableFooterView.hidden = NO;
            mainTableView.contentSize = CGSizeMake(mainTableView.contentSize.width,
                                                   mainTableView.contentSize.height + mainTableView.tableFooterView.frame.size.height);
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging");
    PullDownControl *pullDownControl = (PullDownControl *)mainTableView.tableHeaderView;
    if (pullDownControl.status == PullDownControlReleaseStatus) {
        [UIView animateWithDuration:0.25 animations:^{
            mainTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        }];
        [pullDownControl changeStatus:PullDownControlRefreshingStatus];
        [self refreshData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
        [self appendRows];

    }
    
}


- (void)refreshTableView
{
    
    self.offset+=LIMIT;
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        NSNumber* userId =[[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_ID];

        
        Result* result = [ManagerMember getCollectHouseList:[userId intValue] offset:self.offset length:LIMIT];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (result.isSuccess)
            {
         
            }else {
                    
                    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"数据已经加载完成！"
                                    message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                    [alertView show];
            }
                
        });
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        CGSize size = mainTableView.contentSize;
        size.height = mainTableView.tableHeaderView.frame.size.height + mainTableView.rowHeight * [collectArray count];
        mainTableView.contentSize = size;
        mainTableView.tableFooterView.frame = CGRectMake(0.0,
                                                         mainTableView.rowHeight * [collectArray count],
                                                         mainTableView.bounds.size.width,
                                                         mainTableView.rowHeight);
        mainTableView.tableFooterView.hidden = YES;
        
        
        [mainTableView reloadData];
         mainTableView.contentInset = UIEdgeInsetsMake(-60.0, 0.0, 0.0, 0.0);
        [activityView stopAnimating];
        
         activityView.hidden = YES;
         addDataLable.hidden = YES;
        
        [UIView beginAnimations:@"changeImage" context:NULL];
        [UIView setAnimationDuration:0.5];
        refreshImageView.transform = CGAffineTransformMakeRotation(-(180.0f*M_PI*2)/180.0f);
        [UIView commitAnimations];
        updateLable.text = @"下拉刷新";
        refreshImageView.hidden = NO;
        updateLable.hidden = NO;
        isLoading = NO;
        footviewLabel.text = @"上拉加载更多数据";
    });
    
}


- (void)backButtonMethod{


    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)DeleteCellRow:(UIButton*)bt
{

    
    if (mainTableView.isEditing) {
        
        
        [mainTableView setEditing:NO animated:YES];
        [rightItemButton setTitle:@"编辑" forState:UIControlStateNormal];

    
    }else {
    
        [mainTableView setEditing:YES animated:YES];
        [rightItemButton setTitle:@"完成" forState:UIControlStateNormal];


   }
    
}

- (void)backHomeVCMethod
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SELECTED_HOME_ITEM_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];

}


@end
