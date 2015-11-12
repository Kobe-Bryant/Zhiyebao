//
//  FilterViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-4-30.
//
//

#define MAIN_TAG 21
#define SEARCH_RESULT_TAG 22

#import "FilterViewController.h"
#import "Cell2.h"
#import "Cell1.h"
#import "Macros.h"
#import "SystemSetting.h"
#import "HomeViewController.h"
#import "CustomMarcos.h"
#import "ManagerMember.h"
#import "Result.h"
#import "House.h"
#import "SingleSqlite.h"
#import "RentDetailViewController.h"


@interface FilterViewController ()
{
    NSDictionary* dic;
    BOOL isEnter;
    NSMutableArray *attrArray;
    NSMutableArray *selectedIndexPathArray;
    UIButton *okButton;
    BOOL isEnterHistory;
    
    
}
@property (nonatomic, retain) UITableView *searchTableView;
@property(nonatomic,retain) UISearchBar* searchResultBar;
@property(nonatomic,retain) UITableView* mainTableView;
@property(nonatomic,retain) NSMutableArray* searchHouseArray;


@end



@implementation FilterViewController

@synthesize isRent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithIsRent:(BOOL)newIsRent
{
    self = [super init];
    if (self) {
        
        self.isRent = newIsRent;
    }
    return self;
         
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"FilterViewController viewDidLoad");

    
    NSLog(@"%@",self.view);
    
    

    self.view.backgroundColor = UIColorFromRGB(36.0, 36.0, 36.0);
    
    
    UIImage *buttonImage = [UIImage imageNamed:@"SubmenuButton"];
    okButton = [[UIButton alloc] init];
    okButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [okButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton setTitleColor:UIColorFromRGB(167.0, 166.0, 166.0)
                   forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [okButton addTarget:self
                 action:@selector(okButtonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"FilterViewController viewWillAppear");
        
    if (isEnter) {
        return;
    } else {
        isEnter = YES;
    }
    
    self.searchResultBar = [[UISearchBar alloc]init];
    self.searchResultBar.delegate = self;
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.searchResultBar.frame = CGRectMake(self.view.frame.size.width - FILTER_SIDEBAR_WIDTH,
                                                20.0,
                                                FILTER_SIDEBAR_WIDTH,
                                                44.0);
        
    } else {
        self.searchResultBar.frame = CGRectMake(self.view.frame.size.width - FILTER_SIDEBAR_WIDTH,
                                                0.0,
                                                FILTER_SIDEBAR_WIDTH,
                                                44.0);
    }
    self.searchResultBar.backgroundColor = UIColorFromRGB(49.0, 49.0, 49.0);
    if ([self.searchResultBar respondsToSelector:@selector(setBarTintColor:)]) {
        self.searchResultBar.barTintColor = UIColorFromRGB(49.0, 49.0, 49.0);
    }
    
    self.searchResultBar.tintColor = UIColorFromRGB(49.0, 49.0, 49.0);
    self.searchResultBar.placeholder = @"搜索";
    [self.view addSubview:self.searchResultBar];
    
    
    self.mainTableView = [[UITableView alloc] init];
    self.mainTableView.frame = CGRectMake(0.0,
                                          CGRectGetMaxY(self.searchResultBar.frame),
                                          self.view.frame.size.width,
                                          self.view.frame.size.height - CGRectGetMaxY(self.searchResultBar.frame));
    self.mainTableView.backgroundColor =  UIColorFromRGB(36.0, 36.0, 36.0);
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.separatorColor = [UIColor clearColor];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.sectionFooterHeight = 0.0;
    self.mainTableView.sectionHeaderHeight = 0.0;
    self.mainTableView.tag = MAIN_TAG;
    self.mainTableView.allowsMultipleSelection = YES;
    self.mainTableView.allowsSelectionDuringEditing = YES;
    self.mainTableView.allowsMultipleSelectionDuringEditing = YES;
    [self.view addSubview:self.mainTableView];
    
    

    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0.0, 0.0, self.mainTableView.frame.size.width, 60.0);
    okButton.frame = CGRectMake(self.mainTableView.frame.size.width - 200.0 + (200.0 - okButton.frame.size.width) / 2.0,
                                (64.0 - okButton.frame.size.height) / 2.0,
                                okButton.frame.size.width,
                                okButton.frame.size.height);
    [footerView addSubview:okButton];
    self.mainTableView.tableFooterView = footerView;
    
    
    self.searchTableView = [[UITableView alloc]init];
    self.searchTableView.frame = CGRectMake(0.0, CGRectGetMaxY(self.searchResultBar.frame),self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.searchResultBar.frame));
    self.searchTableView.backgroundColor = [UIColor clearColor];
    self.searchTableView.separatorColor = [UIColor clearColor];
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.sectionFooterHeight = 0.0;
    self.searchTableView.sectionHeaderHeight = 0.0;
    self.searchTableView.hidden = YES;
    self.searchTableView.tag = SEARCH_RESULT_TAG;
    [self.view addSubview:self.searchTableView];
    
    
    UIView* footView = [[UIView alloc]init];
    footView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    footView.backgroundColor = UIColorFromRGB(36.0, 36.0, 36.0);
    self.searchTableView.tableFooterView = footView;
    
    UIButton*  clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(-30.0, 5.0, 200.0, 30.0);
    [clearButton setTitle:@"清除历史记录" forState:UIControlStateNormal];
    [clearButton setTitleColor:UIColorFromRGB(241.0, 116.0, 50.0) forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearMethod) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:clearButton];

    
    
    
    selectedIndexPathArray = [[NSMutableArray alloc] init];
    attrArray = [[NSMutableArray alloc] init];
    
    
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(typeChanged:)
                                                 name:FILTER_SIDEBR_TYPE_CHANGED_NOTIFICATION
                                               object:nil];

    [self refreshData];
    
}

//加载历史数据
- (void)loadHistoryData
{
    
    
    SingleSqlite* sqlite = [SingleSqlite shareSingleSqlite];
    NSArray* houseArray = [sqlite getAllHouse];
    
    for (House* house in houseArray) {
        
        NSLog(@"house = %@",house.houseID);
    }
    NSLog(@"%d",houseArray.count);
    self.searchHouseArray = [NSMutableArray arrayWithArray:houseArray];
    
    NSLog(@"self.searchHouseArray.count = %d",self.searchHouseArray.count);
    [self.searchTableView reloadData];
    
}

#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{

    return YES;
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    
    if (searchBar == self.searchResultBar) {
        
        if ([searchBar.text length]== 0.0) {
            
            isEnterHistory = YES;
            
        }else {
        
            isEnterHistory = NO;
 
        
        }
    }
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
   
   
       searchBar.showsCancelButton = YES;
    
    
     if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
     {
    
         
        UIView* searchBarView = [self.searchResultBar.subviews firstObject];
  
        for (UIView* subView in searchBarView.subviews) {
           
            NSLog(@"subView = %@",subView);
            
            
            if ([subView isKindOfClass:[NSClassFromString(@"UINavigationButton")class]])
            {
                
                [(UIButton*)subView setTintColor:[UIColor whiteColor]];
                [(UIButton*)subView setTitle:@"取消" forState:UIControlStateNormal];
             }
         }
        
    } else {
    
        for (UIView* subview in searchBar.subviews) {
            if ([subview isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
                [(UIButton *)subview setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    
}
    
    [[NSNotificationCenter defaultCenter]postNotificationName:FILTER_SIDEBAR_FULL_SCREEN_CHANGED_NOTIFICATION object:self];
    
    self.searchTableView.hidden = NO;
    self.searchTableView.alpha = 0.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.searchResultBar.frame = CGRectMake(0.0,
                                     self.searchResultBar.frame.origin.y,
                                     self.view.frame.size.width,
                                     self.searchResultBar.frame.size.height);

        self.mainTableView.alpha = 0.0;
        self.searchTableView.alpha = 1.0;
        
        }completion:^(BOOL finished) {
        
        self.mainTableView.hidden = YES;
        
            
            [self loadHistoryData];
            
        
    }];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarCancelButtonClicked %@", searchBar);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FILTER_SIDEBAR_NORMAL_SCREEN_CHANGED_NOTIFICATION
                                                        object:self];
    
    [searchBar resignFirstResponder];
    self.mainTableView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        searchBar.showsCancelButton = NO;
        searchBar.frame = CGRectMake(self.view.frame.size.width - FILTER_SIDEBAR_WIDTH,
                                     searchBar.frame.origin.y,
                                     FILTER_SIDEBAR_WIDTH,
                                     searchBar.frame.size.height);
        self.mainTableView.alpha = 1.0;
        self.searchTableView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.searchTableView.hidden = YES;
        }
    }];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    NSLog(@"searchText = %@",searchText);
    
    dispatch_queue_t queue  =  dispatch_queue_create("searchHouseQueue", NULL);
    dispatch_async(queue, ^{
        
        NSString* houseType ;
        
        if (self.isRent) {
            
            houseType = @"rent";
        } else {
            
            houseType = @"oversell";
        }
        
        Result* result = [ManagerMember searchHouse:searchText houseType:houseType];
        
        if (result.isSuccess) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
               self.searchHouseArray = [NSMutableArray arrayWithArray:result.data];
                
                NSLog(@"searchHouseArray.count =  %d",self.searchHouseArray.count);
                
                
                [self.searchTableView reloadData];
                
            });
            
        }
        
        
    });
}


#pragma mark UITableviewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView.tag ==MAIN_TAG) {
        
        NSLog(@"%@",selectedIndexPathArray);
        
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    if ([selectedIndexPathArray indexOfObject:indexPath] != NSNotFound) {

        NSArray *listArray = [attrArray objectAtIndex:section];
        NSLog(@"listArray %@", listArray);
        return [listArray count] + 1;
    }
    
    return 1;
        
    } else {
    
    
        return self.searchHouseArray.count;
    
    
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == MAIN_TAG) {
        
        return [attrArray count];
   
    } else {
     
        return 1;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    
    NSLog(@"indexPath row = %d",indexPath.row);
    
    if (tableView.tag == MAIN_TAG) {
        
        if (indexPath.row != 0)
       {
        
         static NSString *CellId = @"Cell2";
        
         Cell2 *cell2 = (Cell2*)[tableView dequeueReusableCellWithIdentifier:CellId];
         if (!cell2) {
             cell2 = [[Cell2 alloc]initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:CellId
                             cellControllerType:0];
         }
        
        cell2.textLabel.textColor = UIColorFromRGB(107.0, 107.0, 107.0);
        cell2.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell2.textLabel.backgroundColor = [UIColor clearColor];
        

        if (indexPath.section == 0) {
            NSArray *areaArray = [attrArray objectAtIndex:indexPath.section];
            if (areaArray) {
                Area *area = (Area *)[areaArray objectAtIndex:indexPath.row - 1];
                cell2.textLabel.text = area.title;
            }
        } else if (indexPath.section == 1) {
            NSArray *houseTypeArray = [attrArray objectAtIndex:indexPath.section];
            if (houseTypeArray) {
                HouseType *houseType = (HouseType *)[houseTypeArray objectAtIndex:indexPath.row - 1];
                cell2.textLabel.text = houseType.title;
            }
        } else if (indexPath.section == 2 && isRent == YES) {
            NSArray *rentPriceArray = [attrArray objectAtIndex:indexPath.section];
            if (rentPriceArray) {
                RentPrice *rentPrice = (RentPrice *)[rentPriceArray objectAtIndex:indexPath.row - 1];
                cell2.textLabel.text = rentPrice.title;
            }
        } else if (indexPath.section == 2 && isRent == NO) {
            NSArray *sellPriceArray = [attrArray objectAtIndex:indexPath.section];
            if (sellPriceArray) {
                RentPrice *rentPrice = (RentPrice *)[sellPriceArray objectAtIndex:indexPath.row - 1];
                cell2.textLabel.text = rentPrice.title;
            }
        } else if (indexPath.section == 3) {
            NSArray *proportionArray = [attrArray objectAtIndex:indexPath.section];
            if (proportionArray) {
                Proportion *proportion = (Proportion *)[proportionArray objectAtIndex:indexPath.row - 1];
                cell2.textLabel.text = proportion.title;
            }
        }

        
        
        
        //cell的背景颜色
        UIView* backgroundview = [[UIView alloc] init];
        [backgroundview setBackgroundColor:UIColorFromRGB(29.0, 29.0, 29.0)];
        cell2.backgroundView = backgroundview;
        
       
        
        // Selected Status
        if ([selectedIndexPathArray indexOfObject:indexPath] != NSNotFound) {
            UIImageView *selectedImageView = [[UIImageView alloc] init];
            selectedImageView.image = [UIImage imageNamed:@"SubmenuSelectedPoint"];
            selectedImageView.frame = CGRectMake(0.0,
                                                 0.0,
                                                 selectedImageView.image.size.width,
                                                 selectedImageView.image.size.height);
            cell2.accessoryView = selectedImageView;
        } else {
            UIImageView *selectedImageView = [[UIImageView alloc] init];
            selectedImageView.image = [UIImage imageNamed:@"SubmenuUnselectedPoint"];
            selectedImageView.frame = CGRectMake(0.0,
                                                 0.0,
                                                 selectedImageView.image.size.width,
                                                 selectedImageView.image.size.height);
            cell2.accessoryView = selectedImageView;
        }
        
        return cell2;
        
    } else {
        
        Cell1* cell = [[Cell1 alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:nil
                                cellControllerType:0];
        

        if (indexPath.section == 0) {
            cell.textLabel.text = @"片区";
        } else if (indexPath.section == 1) {
            cell.textLabel.text = @"房型";
        } else if (indexPath.section == 2 && isRent == YES) {
            cell.textLabel.text = @"租金";
        } else if (indexPath.section == 2 && isRent == NO) {
            cell.textLabel.text = @"售价";
        } else if (indexPath.section == 3) {
            cell.textLabel.text = @"面积";
        }

        
        UIImage* changeImage = [UIImage imageNamed:@"accessviewImage.png"];
        cell.FirstArrowImageView = [[UIImageView alloc] initWithFrame:
                                    CGRectMake(180.0,
                                               15.0,
                                               changeImage.size.width,
                                               changeImage.size.height)];
        [cell.contentView addSubview:cell.FirstArrowImageView];
        
        UIView* backgroundview = [[UIView alloc] init];
        [backgroundview setBackgroundColor:UIColorFromRGB(36.0, 36.0, 36.0)];
        cell.backgroundView = backgroundview;
        
        //改变箭头图片
        // Selected Status
        if ([selectedIndexPathArray indexOfObject:indexPath] != NSNotFound) {
            UIImageView *selectedImageView = [[UIImageView alloc] init];
            selectedImageView.image = [UIImage imageNamed:@"accessdown"];
            selectedImageView.frame = CGRectMake(0.0,
                                                 0.0,
                                                 selectedImageView.image.size.width,
                                                 selectedImageView.image.size.height);
            cell.accessoryView = selectedImageView;
        } else {
            UIImageView *selectedImageView = [[UIImageView alloc] init];
            selectedImageView.image = [UIImage imageNamed:@"accessviewImage"];
            selectedImageView.frame = CGRectMake(0.0,
                                                 0.0,
                                                 selectedImageView.image.size.width,
                                                 selectedImageView.image.size.height);
            cell.accessoryView = selectedImageView;
        }

        
        return cell;
        
    }
    } else if (tableView.tag == SEARCH_RESULT_TAG) {
    
        static NSString* cellIdentify = @"cellIdentify";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        
        if (cell==nil) {
            
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
            
            UILabel* numberLable = [[UILabel alloc]init];
            numberLable.frame = CGRectMake(10.0, 5.0, 240.0,30.0);
            numberLable.tag = 100;
            numberLable.font = [UIFont systemFontOfSize:15.0];
            numberLable.textColor = UIColorFromRGB(167.0, 166.0, 166.0);
            [cell.contentView addSubview:numberLable];
        }
        
        
        UIView* cellSelectView = [[UIView alloc]init];
        cellSelectView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, cell.frame.size.height);
        cellSelectView.backgroundColor =UIColorFromRGB(40.0, 40.0, 40.0);
        cell.selectedBackgroundView = cellSelectView;
        
        cell.backgroundColor = UIColorFromRGB(36.0, 36.0, 36.0);
        UILabel* numberLable = (UILabel*)[cell viewWithTag:100];
        
        if (self.searchHouseArray.count > 0) {
            
            
            House* house = (House*)[self.searchHouseArray objectAtIndex:indexPath.row];
            numberLable.text = [NSString stringWithFormat:@"%@ %@",house.houseIdentifier,house.title];
            
        }

        return cell;
        
    }
    return nil;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    
    NSLog(@"didSelectRowAtIndexPath   indexPath.row =  %d",indexPath.row);
    
    if (indexPath.row == 0)
    {

        if ([selectedIndexPathArray indexOfObject:indexPath] != NSNotFound) {
            [selectedIndexPathArray removeObject:indexPath];
            NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
            NSArray *listArray = [attrArray objectAtIndex:indexPath.section];
            for (int i = 1; i <= listArray.count; i++) {
                [indexPathArray addObject:[NSIndexPath indexPathForRow:i
                                                             inSection:indexPath.section]];
            }

            [self.mainTableView beginUpdates];
            [self.mainTableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
            [self.mainTableView deleteRowsAtIndexPaths:indexPathArray
                                 withRowAnimation:UITableViewRowAnimationTop];
            [self.mainTableView endUpdates];
            
        } else {
            [selectedIndexPathArray addObject:indexPath];
            
            NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
            NSArray *listArray = [attrArray objectAtIndex:indexPath.section];
            for (int i = 1; i <= listArray.count; i++) {
                [indexPathArray addObject:[NSIndexPath indexPathForRow:i
                                                             inSection:indexPath.section]];
            }
            
            
            [self.mainTableView beginUpdates];
            [self.mainTableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
            [self.mainTableView insertRowsAtIndexPaths:indexPathArray
                                  withRowAnimation:UITableViewRowAnimationBottom];
            [self.mainTableView endUpdates];
        }

    }
    else {
        
        if ([selectedIndexPathArray indexOfObject:indexPath] != NSNotFound) {
            [selectedIndexPathArray removeObject:indexPath];
        } else {
            [selectedIndexPathArray addObject:indexPath];
        }
        //调用该方法会重新加载表示图
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
}



- (void)okButtonPressed:(UIButton *)button
{
    NSLog(@"okButtonPressed %@", button);
    
    NSMutableArray *selectedAreaIDArray = [[NSMutableArray alloc] init];
    NSMutableArray *selectedHouseTypeIDArray = [[NSMutableArray alloc] init];
    NSMutableArray *selectedRentPriceIDArray = [[NSMutableArray alloc] init];
    NSMutableArray *selectedProportionIDArray = [[NSMutableArray alloc] init];

    NSLog(@"selectedIndexPathArray =  %@",selectedIndexPathArray);
    
    
    NSLog(@"selectedIndexPathArray count  =  %d",selectedIndexPathArray.count);
    

    for (NSIndexPath *indexPath in selectedIndexPathArray) {

        NSLog(@"indexPath.row =  %d",indexPath.row);
        
        
        
        if (indexPath.row > 0) {


            if (indexPath.section == 0) {
                NSArray *areaArray = [attrArray objectAtIndex:indexPath.section];
                Area *currentArea = [areaArray objectAtIndex:indexPath.row - 1];
                [selectedAreaIDArray addObject:currentArea.areaID];
            }
            if (indexPath.section == 1) {
                NSArray *houseTypeArray = [attrArray objectAtIndex:indexPath.section];
                HouseType *currentHouseType = [houseTypeArray objectAtIndex:indexPath.row - 1];
                [selectedHouseTypeIDArray addObject:currentHouseType.houseTypeID];
            }
            if (indexPath.section == 2 && self.isRent == YES) {
                NSArray *rentPriceArray = [attrArray objectAtIndex:indexPath.section];
                RentPrice *currentRentPrice = [rentPriceArray objectAtIndex:indexPath.row - 1];
                [selectedRentPriceIDArray addObject:currentRentPrice.rentPriceID];
            } else if (indexPath.section == 2) {
                NSArray *sellPriceArray = [attrArray objectAtIndex:indexPath.section];
                SellPrice *currentSellPrice = [sellPriceArray objectAtIndex:indexPath.row - 1];
                [selectedRentPriceIDArray addObject:currentSellPrice.sellPriceID];
            }
            if (indexPath.section == 3) {
                NSArray *proportionArray = [attrArray objectAtIndex:indexPath.section];
                Proportion *currentProportion = [proportionArray objectAtIndex:indexPath.row - 1];
                [selectedProportionIDArray addObject:currentProportion.proportionID];
            }
        }
    }
    
    

    NSMutableDictionary *selectedDict = [[NSMutableDictionary alloc] init];
    [selectedDict setValue:selectedAreaIDArray forKey:AREA_KEY];
    [selectedDict setValue:selectedHouseTypeIDArray forKey:HOUSE_TYPE_KEY];
    [selectedDict setValue:selectedRentPriceIDArray forKey:RENT_PRICE_KEY];
    [selectedDict setValue:selectedProportionIDArray forKey:PROPORTION_KEY];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FILTER_SIDEBR_OPTION_CHANGED_NOTIFICATION
                                                        object:self
                                                      userInfo:selectedDict];
    [[NSNotificationCenter defaultCenter] postNotificationName:CLOSE_FILTER_SIDEBR_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];

}

- (void)refreshData
{
    NSLog(@"refreshData");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        Result *result = [SystemSetting request];
        if (result.isSuccess) {
//            NSLog(@"result.data %@", result.data);
            dic = [[NSDictionary alloc] initWithDictionary:result.data];
//            NSMutableDictionary *returnDict = (NSMutableDictionary *)result.data;
//            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
            attrArray = [[NSMutableArray alloc] init];
            if ([dic objectForKey:AREA_KEY]) {
//                [tempDict setValue:[returnDict objectForKey:AREA_KEY] forKey:AREA_KEY];
                [attrArray insertObject:[dic objectForKey:AREA_KEY] atIndex:0];
            }
            if ([dic objectForKey:HOUSE_TYPE_KEY]) {
//                [tempDict setValue:[returnDict objectForKey:HOUSE_TYPE_KEY] forKey:HOUSE_TYPE_KEY];
                [attrArray insertObject:[dic objectForKey:HOUSE_TYPE_KEY] atIndex:1];
            }
            if (self.isRent) {
                if ([dic objectForKey:RENT_PRICE_KEY]) {
//                    [tempDict setValue:[returnDict objectForKey:RENT_PRICE_KEY] forKey:RENT_PRICE_KEY];
                    [attrArray insertObject:[dic objectForKey:RENT_PRICE_KEY] atIndex:2];
                }
            } else {
                if ([dic objectForKey:SELL_PRICE_KEY]) {
//                    [tempDict setValue:[returnDict objectForKey:SELL_PRICE_KEY] forKey:SELL_PRICE_KEY];
                    [attrArray insertObject:[dic objectForKey:SELL_PRICE_KEY] atIndex:2];
                }
            }
            if ([dic objectForKey:PROPORTION_KEY]) {
//                [tempDict setValue:[returnDict objectForKey:PROPORTION_KEY] forKey:PROPORTION_KEY];
                [attrArray insertObject:[dic objectForKey:PROPORTION_KEY] atIndex:3];
            }
////            NSLog(@"tempDict %@", tempDict);
//            
//            //            NSLog(@"dic %@", dic);
//            dic = [[NSDictionary alloc] initWithDictionary:tempDict];
            NSLog(@"attrArray %@", attrArray);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                selectedIndexPathArray = [[NSMutableArray alloc] init];
                [self.mainTableView reloadData];
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
}

- (void)typeChanged:(NSNotification *)notification
{
    NSLog(@"typeChanged %@", notification);
    
    NSString *typeString = [notification.userInfo objectForKey:FILTER_SIDEBR_TYPE];
    
    NSLog(@"tt= %@",typeString);
    
    
    self.isRent = [typeString isEqualToString:@"rent"];
    [self refreshData];
}

- (void)clearMethod
{
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"是否清空历史记录"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
    [alertView show];
    
}
//清除记录
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        
        SingleSqlite* sqlite = [SingleSqlite shareSingleSqlite];
        NSArray* allHouse = [sqlite getAllHouse];
        
        for (House* house in allHouse) {
            
           [sqlite deleteHouse:house.houseID];
            
        }
        
        self.searchHouseArray = nil;
        [self.searchTableView reloadData];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.searchResultBar resignFirstResponder];
    
}


@end