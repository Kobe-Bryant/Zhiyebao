//
//  PostRentViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-5-2.
//
//

#import "PostRentViewController.h"
#import "Macros.h"
#import "MainViewController.h"
#import "RentModel.h"
#import "RentDetailViewController.h"
#import "Result.h"
#import "ManagerMember.h"
#import "House.h"
#import "CustomMarcos.h"
#import "SWTableViewCell.h"
#import "SubSwtableCell.h"
#import "UpdateRentViewController.h"

@interface PostRentViewController ()
{
    UIImage* rentImage;
    UIImageView* rentImageView;
    UIImage* sellImage;
    UIImageView* sellImageView;
    NSMutableArray* rentArray;
    NSMutableArray* offShelfArray;
    UITableView* rentTableView;
    UILabel* rentLable;
    UILabel* sellLable;
    UIImageView* updateImageView;
    UIScrollView* mainScrollView;
    UITableView* offShelfTableView;
    BOOL isEnter;
    
    UIView* bottomLeftView;
    UIView* bottomRightView;
    UIImage* unselectImage;
    UIImage* selectedImage;
    
    UIImageView* runImageView;
    UIButton* sellButton;
    UIButton* rentButton;
    
    UISegmentedControl *segmentedControl;
    UIButton* rightButton;
    BOOL isOffshelf;
    
    SubSwtableCell* subSwtTablecell;
    BOOL isClickImageView;
    BOOL isEdit;
    
    
}

//获取刊登出租的房源
- (void)loadPostRentList;


//下架刊登的房子
- (void)soldOutHouse:(NSIndexPath*)indexPath;


@end

@implementation PostRentViewController

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

    self.title = @"我刊登的出租";
    
    
    //返回的leftBarButtonItem
    UIImage* image = [UIImage imageNamed:@"arrowImage.png"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0.0,
                                  0.0,
                                  image.size.width,
                                  image.size.height);
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self
                   action:@selector(backButtonMethod)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;


    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0.0,
                                   0.0,
                                   50.0,
                                   30.0);
    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(editButtonMethod)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem* editBarButtonItem = [[UIBarButtonItem alloc] init];
    editBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    

    
    self.view.backgroundColor = UIColorFromRGB(248.0, 241.0, 234.0);
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"PostRentViewController viewWillAppear");
  //取消选中效果
   [rentTableView deselectRowAtIndexPath:[rentTableView indexPathForSelectedRow] animated:YES];
    

    if (isEnter) {
        return;
    } else {
        isEnter = YES;
    }


    //获取刊登出租的房源
    [self loadPostRentList];
    
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"出租中", @"已下架"]];
    segmentedControl.frame = CGRectMake(70.0,
                                        15.0,
                                        180.0,
                                        segmentedControl.frame.size.height);
    segmentedControl.tintColor = UIColorFromRGB(230.0, 113.0, 38.0);
    [segmentedControl setWidth:90.0 forSegmentAtIndex:0];
    [segmentedControl setWidth:90.0 forSegmentAtIndex:1];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl addTarget:self
                         action:@selector(segmentedControlChanged:)
               forControlEvents:UIControlEventValueChanged];
    segmentedControl.userInteractionEnabled  = YES;
    [self.view addSubview:segmentedControl];
    

    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0,
                                                                   60.0,
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height - 60.0)];
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width * 2.0,
                                            self.view.frame.size.height);
    mainScrollView.pagingEnabled = NO;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.scrollEnabled = NO;
    [self.view addSubview:mainScrollView];
    
    
    
    
    
    //创建tableview
    rentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0,
                                                                 0.0,
                                                                 mainScrollView.frame.size.width,
                                                                 mainScrollView.frame.size.height)
                                                   style:UITableViewStylePlain];
    rentTableView.delegate = self;
    rentTableView.dataSource = self;
    rentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rentTableView.userInteractionEnabled = YES;
    rentTableView.backgroundColor = UIColorFromRGB(255.0, 248.0, 238.0);
    rentTableView.backgroundColor = [UIColor clearColor];
    [mainScrollView addSubview:rentTableView];
    
   
    //创建Selltableview
    offShelfTableView = [[UITableView alloc]initWithFrame:CGRectMake(mainScrollView.frame.size.width,
                                                                     0.0,
                                                                     mainScrollView.frame.size.width,
                                                                     mainScrollView.frame.size.height)
                                                   style:UITableViewStylePlain];
    offShelfTableView.delegate = self;
    offShelfTableView.separatorColor = [UIColor redColor];
    offShelfTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    offShelfTableView.dataSource = self;
    offShelfTableView.userInteractionEnabled = YES;
    offShelfTableView.backgroundColor = [UIColor clearColor];
    [mainScrollView addSubview:offShelfTableView];
    offShelfTableView.backgroundColor = UIColorFromRGB(255.0, 248.0, 238.0);
    rentArray = [NSMutableArray array];

    

}

#pragma mark UITableviewDatasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100.0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == rentTableView) {
        return rentArray.count;
    } else {
        return offShelfArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellidenty = @"cellidenty";
    
    
    subSwtTablecell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
    
    if (subSwtTablecell==nil)     {
        
        
        
        subSwtTablecell = [[SubSwtableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidenty indexPath:indexPath];
        subSwtTablecell.rightUtilityButtons = [self rightButtons];
        subSwtTablecell.delegate = self;
    }
    
    if (indexPath.row % 2 ==0) {
        
        
        subSwtTablecell.backgroundColor = UIColorFromRGB(250.0, 244.0, 234.0);
        
    }else {
        
        subSwtTablecell.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
        
    }
    
    UITapGestureRecognizer* clickTap = [[UITapGestureRecognizer alloc]
                                             initWithTarget:subSwtTablecell
                                        action:@selector(clickDeleteImageView:)];
    [subSwtTablecell.cellImageView addGestureRecognizer:clickTap];
     clickTap.view.tag = indexPath.row;
    
    
    
    
    //为cell赋值
    if (tableView == rentTableView) {
        [subSwtTablecell setCellInfo:rentArray[indexPath.row] indexPath:indexPath];
    } else {
        [subSwtTablecell setCellInfo:offShelfArray[indexPath.row] indexPath:indexPath];
    }
    
    
    return subSwtTablecell;
}

- (NSArray *)rightButtons
{
    
    
    
    if (segmentedControl.selectedSegmentIndex ==0)
    {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.89f green:0.43f blue:0.14f alpha:1.0]
                                                    title:@"修改"];
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.89f green:0.43f blue:0.14f alpha:1.0f]
                                                    title:@"下架"];
        return rightUtilityButtons;
    
        
        
     }else {
    
    
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
   
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.89f green:0.43f blue:0.14f alpha:1.0f]
                                                    title:@"上架"];
        return rightUtilityButtons;

    
    }
    
    return nil;
    

    
}




- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            
            if (!isOffshelf) {
                
                NSIndexPath *cellIndexPath = [rentTableView indexPathForCell:cell];
                
                House* house = [rentArray objectAtIndex:cellIndexPath.row];
                NSLog(@"%@",house.houseID);
                
                //修改出租房源信息
                UpdateRentViewController* updateVC = [[UpdateRentViewController alloc]initWithHouse:house];
                UINavigationController* updateNC = [[UINavigationController alloc]initWithRootViewController:updateVC];
                [self.navigationController presentViewController:updateNC animated:YES completion:nil];
                
            } else {
           
                NSIndexPath *cellIndexPath = [offShelfTableView indexPathForCell:cell];

                [self soldOnHouse:cellIndexPath];
           }


            [cell hideUtilityButtonsAnimated:YES];
            
             break;
        }
        case 1:
        {
        
            
            NSIndexPath *cellIndexPath = [rentTableView indexPathForCell:cell];
            
            //先下架在删除
            [self soldOutHouse:cellIndexPath];
            [cell hideUtilityButtonsAnimated:YES];

             break;
        }
        default:
            break;
    }
}
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    
    
    
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}
//点击删除按钮
- (void)clickDeleteImageView:(UITapGestureRecognizer*)tap
{
    
    NSLog(@"tap.view.tag = %d",tap.view.tag);
    NSIndexPath* indexPath = [rentTableView indexPathForSelectedRow];
    SubSwtableCell* cell =(SubSwtableCell*)[rentTableView cellForRowAtIndexPath:indexPath];
    if (isClickImageView ) {
        
         [cell showRightUtilityButtonsAnimated:YES];
        [rentTableView deselectRowAtIndexPath:[rentTableView indexPathForSelectedRow]  animated:YES];

        
    } else {
    
    
        [cell hideUtilityButtonsAnimated:YES];
        [rentTableView deselectRowAtIndexPath:[rentTableView indexPathForSelectedRow]  animated:YES];

    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

  
    if (isClickImageView==YES) {
        
        SubSwtableCell* cell =(SubSwtableCell*)[tableView cellForRowAtIndexPath:indexPath];
        UITapGestureRecognizer* tap =(UITapGestureRecognizer*) cell.cellImageView.gestureRecognizers[0];
        NSLog(@"%d",tap.view.tag);
        [self clickDeleteImageView:tap];
        
     }   else {
        
        if (tableView == rentTableView) {
            House* house = rentArray[indexPath.row];
            RentDetailViewController* rentDetail = [[RentDetailViewController alloc]initWithDataObject:house.houseID];
            NSLog(@"%@",house.houseID);
            rentDetail.mainViewController = self.mainController;
            [self.navigationController pushViewController:rentDetail animated:YES];
            
        } else {
            House* house = rentArray[indexPath.row];
            RentDetailViewController* rentDetail = [[RentDetailViewController alloc]initWithDataObject:house.houseID];
            rentDetail.mainViewController = self.mainController;
            [self.navigationController pushViewController:rentDetail animated:YES];
            
        }
   }
    
}
//编辑方法
- (void)editButtonMethod
{

    
    [[NSNotificationCenter defaultCenter]postNotificationName:CHANGE_CELL_FRAME object:rightButton];
    isEdit = !isEdit;
    if (!isEdit) {
        
        if (segmentedControl.selectedSegmentIndex == 0) {
            
            [rentTableView reloadData];
    
        } else {
        
          [offShelfTableView reloadData];
            
        }
        
        
          isClickImageView = NO;
        
    } else {
    
        isClickImageView = YES;

    
    }
    
    
}
- (void)backButtonMethod{


    [self.navigationController popViewControllerAnimated:YES];
}


//获取刊登出租的房源
- (void)loadPostRentList{

    
    //获取出租房源
    dispatch_queue_t queue  =  dispatch_queue_create("postrentQueue", NULL);
    dispatch_group_t group =   dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSString* userId =[[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_ID];
        
        Result* result = [ManagerMember getMyPostHouseList:[userId intValue] offset:0 length:100 type:@"rent" isReleased:1];
        
        rentArray = [NSMutableArray arrayWithArray:result.data];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (result.isSuccess) {
                
                
                NSLog(@"%d",rentArray.count);
                
                [rentTableView reloadData];
            }
        });
    });
}


- (void)loadSoldOutList
{

   //获取下架房源
    dispatch_queue_t queue  =  dispatch_queue_create("postrentQueue", NULL);
    dispatch_group_t group =   dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        
        NSString* userId =[[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_ID];
        Result* result = [ManagerMember getMyPostHouseList:[userId intValue] offset:0 length:100 type:@"rent" isReleased:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.isSuccess) {
                offShelfArray = [NSMutableArray arrayWithArray:result.data];
                [offShelfTableView reloadData];
            }
        });
    });

}

//下架刊登的房子
- (void)soldOutHouse:(NSIndexPath*)indexPath
{

    dispatch_queue_t queue  =  dispatch_queue_create("soldOutHouseQueue", NULL);

    dispatch_async(queue, ^{
    
      House* house = [rentArray objectAtIndex:indexPath.row];
        
      Result* result = [ManagerMember cancelReleaseHouse:[house.houseID intValue] isRelease:0];
        
        NSLog(@"result.isSuccess =  %d",result.isSuccess);
        
//        setRelease.html	上架或下架	 signature
//    houseId: 信息Id
//    isRelease:0(下架)1(上架)
        if (result.isSuccess) {
         
            
         dispatch_async(dispatch_get_main_queue(), ^{
      
             
             [rentArray removeObjectAtIndex:indexPath.row];
             
             [rentTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
             [rentTableView reloadData];
             
        });
            
    }
        
    });
}

//上架房源
- (void)soldOnHouse:(NSIndexPath *)indexPath
{

    
    dispatch_queue_t queue  =  dispatch_queue_create("soldOutHouseQueue", NULL);
    
    dispatch_async(queue, ^{
        
        House* house = [offShelfArray objectAtIndex:indexPath.row];
        
        Result* result = [ManagerMember soldOnHouse:[house.houseID intValue] isRelease:1];
        
       if (result.isSuccess) {
            
           
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [offShelfArray removeObjectAtIndex:indexPath.row];
                
                [offShelfTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                
           });
            
            
        }
        
    });
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return YES;
    
}

- (void)segmentedControlChanged:(UISegmentedControl *)segmentControl
{
    NSLog(@"segmentedControlChanged");
    if (segmentControl.selectedSegmentIndex == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            mainScrollView.contentOffset = CGPointMake(0.0, 0.0);
            isOffshelf = NO;
            [self loadPostRentList];
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            mainScrollView.contentOffset = CGPointMake(mainScrollView.frame.size.width, 0.0);
            isOffshelf = YES;
            [self loadSoldOutList];
        }];
    }
}


@end
