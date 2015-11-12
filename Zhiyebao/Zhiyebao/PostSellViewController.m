//
//  PostSellViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-5-2.
//
//

#import "PostSellViewController.h"
#import "Macros.h"
#import "RentCell.h"
#import "RentModel.h"
#import "MainViewController.h"
#import "RentDetailViewController.h"
#import "Result.h"
#import "ManagerMember.h"
#import "SWTableViewCell.h"
#import "SubSwtableCell.h"
#import "UpdateSellViewController.h"
#import "CustomMarcos.h"


@interface PostSellViewController ()
{
    UIImage* rentImage;
    UIImageView* rentImageView;
    UIImage* sellImage;
    UIImageView* sellImageView;
    NSMutableArray* sellArray;
    NSMutableArray* offShelfArray;
    UITableView* rentTableView;
    UILabel* rentLable;
    UILabel* sellLable;
    BOOL isOffshelf;
    
    UIImageView* updateImageView;
    UITableView* offshelfTableView;
    UIScrollView* mainScrollView;
    BOOL isEnter;

    
    UISegmentedControl *segmentedControl;
    
    UIView* bottomLeftView;
    UIView* bottomRightView;
    UIImage* unselectImage;
    UIImage* selectedImage;
    
    UIImageView* runImageView;
    UIButton* sellButton;
    UIButton* rentButton;
    UIButton* rightButton;
    SubSwtableCell* subSwtTablecell;
    BOOL isClickImageView;
    BOOL isEdit;
}
@end

@implementation PostSellViewController

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
 
    self.title = @"我刊登的出售";
    
    
    //返回的leftBarButtonItem
    UIImage* image = [UIImage imageNamed:@"arrowImage.png"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0.0,
                                  0.0,
                                  image.size.width,
                                  image.size.height);
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonMethod)
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
    

    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = UIColorFromRGB(255.0, 248.0, 238.0);
    
    

    if (isEnter) {
        
        return;
        
    }else {
        
        isEnter = YES;
        
        
    }
    
    
    [self loadPostSellList];

    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"出售中", @"已下架"]];
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
    segmentedControl.userInteractionEnabled = YES;
    [self.view addSubview:segmentedControl];
    

    

    
    
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0,
                                                                   60.0,
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height)];
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
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height)
                                                style:UITableViewStylePlain];
    rentTableView.delegate = self;
    rentTableView.dataSource = self;
    rentTableView.tag = 100;
    rentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rentTableView.userInteractionEnabled = YES;
    rentTableView.backgroundColor = UIColorFromRGB(255.0, 248.0, 238.0);
    [mainScrollView addSubview:rentTableView];
    
    //创建Selltableview
    offshelfTableView = [[UITableView alloc]initWithFrame:CGRectMake(320.0,
                                                                     0.0,
                                                                     self.view.frame.size.width,
                                                                     self.view.frame.size.height)
                                                    style:UITableViewStylePlain];
    offshelfTableView.delegate = self;
    offshelfTableView.separatorColor = [UIColor redColor];
    offshelfTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    offshelfTableView.dataSource = self;
    offshelfTableView.tag = 101;
    offshelfTableView.userInteractionEnabled = YES;
    offshelfTableView.backgroundColor = UIColorFromRGB(255.0, 248.0, 238.0);
    [mainScrollView addSubview:offshelfTableView];
    
    
    
    
    UIImage* Vertical = [UIImage imageNamed:@"Vertical.png"];
    UIImageView* VerticalImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                      (sellImage.size.width,
                                       0.0,
                                       Vertical.size.width,
                                       Vertical.size.height)];
    VerticalImageView.image = Vertical;
    VerticalImageView.userInteractionEnabled = YES;
    [self.view addSubview:VerticalImageView];
    
    
    sellArray = [NSMutableArray array];

    
}

#pragma mark UITableviewDatasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100.0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView.tag == 100) {
        
        return sellArray.count;
  
        
    } else{
    
    
        return offShelfArray.count;
        
    
    }
    
    
    
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
        [subSwtTablecell setCellInfo:sellArray[indexPath.row] indexPath:indexPath];
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
            
            if (!isOffshelf)
            {
                
                NSIndexPath *cellIndexPath = [rentTableView indexPathForCell:cell];
                
                House* house = [sellArray objectAtIndex:cellIndexPath.row];
                NSLog(@"%@",house.houseID);
                
                //修改出租房源信息
                UpdateSellViewController* updateVC = [[UpdateSellViewController alloc]initWithHouse:house];
                UINavigationController* updateNC = [[UINavigationController alloc]initWithRootViewController:updateVC];
                [self.navigationController presentViewController:updateNC animated:YES completion:nil];
                
            } else {
                
                NSIndexPath *cellIndexPath = [offshelfTableView indexPathForCell:cell];
                
                
                House* house = [offShelfArray objectAtIndex:cellIndexPath.row];
                
                NSLog(@"%@",house.houseID);
                
                [self soldOnHouse:cellIndexPath];

         
            }
            
            
            [cell hideUtilityButtonsAnimated:YES];
            
            break;
        }
        case 1:
        {
            
            
            NSIndexPath *cellIndexPath = [rentTableView indexPathForCell:cell];
            
           [self soldOutHouse:cellIndexPath];
            
            NSLog(@"cellIndexPath.section = %d cellIndexPath.row = %d",cellIndexPath.section,cellIndexPath.row);
            
            
            NSLog(@"rentArray.count = %d",sellArray.count);

            
            
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
            House* house = sellArray[indexPath.row];
            RentDetailViewController* rentDetail = [[RentDetailViewController alloc]initWithDataObject:house.houseID];
            rentDetail.mainViewController = self.mainController;
            [self.navigationController pushViewController:rentDetail animated:YES];
            
        } else {
            House* house = offShelfArray[indexPath.row];
            RentDetailViewController* rentDetail = [[RentDetailViewController alloc]initWithDataObject:house.houseID];
            rentDetail.mainViewController = self.mainController;
            [self.navigationController pushViewController:rentDetail animated:YES];
            
        }
    }
    
    
    
}



- (void)backButtonMethod{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

//获取刊登出售的房源
- (void)loadPostSellList
{
    
    
    
    dispatch_queue_t queue  =  dispatch_queue_create("postSellQueue", NULL);
    dispatch_group_t group =   dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        
        NSString* userId =[[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_ID];
        
        
        Result* result = [ManagerMember getMyPostHouseList:[userId intValue] offset:0 length:100 type:@"oversell" isReleased:1];
        
        sellArray = [NSMutableArray arrayWithArray:result.data];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (result.isSuccess) {
                
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
        Result* result = [ManagerMember getMyPostHouseList:[userId intValue] offset:0 length:100 type:@"oversell" isReleased:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.isSuccess) {
                offShelfArray = [NSMutableArray arrayWithArray:result.data];
                
                [offshelfTableView reloadData];
            }
        });
    });
    
}

//下架刊登出售的房子
- (void)soldOutHouse:(NSIndexPath*)indexPath
{
    
    dispatch_queue_t queue  =  dispatch_queue_create("soldOutHouseQueue", NULL);
    
    dispatch_async(queue, ^{
        
        House* house = [sellArray objectAtIndex:indexPath.row];
        
        Result* result = [ManagerMember cancelReleaseHouse:[house.houseID intValue] isRelease:0];
        
        
        if (result.isSuccess) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [sellArray removeObjectAtIndex:indexPath.row];
                
                [rentTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [offshelfTableView reloadData];

                
            });
            
        }
        
    });
}

//上架房源
- (void)soldOnHouse:(NSIndexPath *)indexPath
{
    
    
    NSLog(@"%d",offShelfArray.count);
    
    
    dispatch_queue_t queue  =  dispatch_queue_create("soldOnHouseQueue", NULL);
    
    dispatch_async(queue, ^{
        
        House* house = [offShelfArray objectAtIndex:indexPath.row];
        
        Result* result = [ManagerMember soldOnHouse:[house.houseID intValue] isRelease:1];
        
        if (result.isSuccess) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [offShelfArray removeObjectAtIndex:indexPath.row];
                
                [offshelfTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                
                [offshelfTableView reloadData];
                
                
            });
            
            
        }
        
    });
    
    
}


- (void)segmentedControlChanged:(UISegmentedControl *)segmentControl
{
 
    if (segmentControl.selectedSegmentIndex == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            mainScrollView.contentOffset = CGPointMake(0.0, 0.0);
        }];
        isOffshelf = NO;
       [self loadPostSellList];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            mainScrollView.contentOffset = CGPointMake(mainScrollView.frame.size.width, 0.0);
        }];
        isOffshelf = YES;

        [self loadSoldOutList];
        
    }
}

//编辑方法
- (void)editButtonMethod
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:CHANGE_CELL_FRAME object:rightButton];
     isEdit = !isEdit;
     if (!isEdit) {
        
        [rentTableView reloadData];
         isClickImageView = NO;
      } else {
        
        isClickImageView = YES;
      }
    
}

@end
