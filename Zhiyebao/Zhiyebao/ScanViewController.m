//
//  ScanViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-5-2.
//
//

#import "ScanViewController.h"
#import "RentModel.h"
#import "RentCell.h"
#import "MainViewController.h"
#import "RentDetailViewController.h"
#import "Macros.h"
#import "Result.h"
#import "ManagerMember.h"
#import "Member.h"
#import "CustomMarcos.h"



@interface ScanViewController ()
{

    NSMutableArray* scanDataArray;
    UITableView* mainTableView;
    UIButton* rightButton;
    UIActivityIndicatorView *activityIndicatorView;

}

@property(nonatomic,strong) UIImageView* emptyImageView;
@property(nonatomic,strong) UILabel* emptyLable;
//获取网络数据
- (void)loadWebServiceScanData;


@end

@implementation ScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(255.0, 248.0, 238.0);

    //navigationItem的titleView
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(160.0,
                                                              0.0,
                                                              40.0,
                                                              30.0)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20.0];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"最近浏览", nil);
    self.navigationItem.titleView = label;
    
    
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
    rightButton.frame = CGRectMake(280.0, 5.0, 40.0, 30.0);
    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    rightButton.titleLabel.textColor = [UIColor whiteColor];
    [rightButton addTarget:self action:@selector(DeleteCellRow:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear: animated];
   
 
    
    //请求网络数据
    [self loadWebServiceScanData];
    
    
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
        
        self.emptyLable.frame = CGRectMake(60.0, 300.0, 200.0, 40.0);
        
    } else {
        
        self.emptyLable.frame = CGRectMake(60.0, 200.0, 200.0, 40.0);
        
        
    }
    self.emptyLable.font = [UIFont systemFontOfSize:12.0];
    self.emptyLable.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
    self.emptyLable.hidden = YES;
    self.emptyLable.text = @"抱歉，还没有找到相关浏览记录!";
    [self.view addSubview:self.emptyLable];
    

   //创建tableview
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0,
                                                                 0.0,
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height)
                                                style:UITableViewStylePlain];
    mainTableView.contentSize = CGSizeMake(320, 560);
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = UIColorFromRGB(255.0, 248.0, 238.0);
    mainTableView.userInteractionEnabled = YES;
    [self.view addSubview:mainTableView];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100.0) / 2.0,
                                             (self.view.frame.size.height - 100.0) / 2.0,
                                             100.0,
                                             100.0);
    activityIndicatorView.backgroundColor = [UIColor blackColor];
    activityIndicatorView.layer.cornerRadius = 10.0;
    activityIndicatorView.alpha = 0.7;
    [activityIndicatorView startAnimating];
    [self.view addSubview:activityIndicatorView];
    
    
}

#pragma mark UITableviewDatasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100.0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return scanDataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* cellidenty = @"cellidenty";
    
    RentCell* cell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
    
    if (cell==nil) {
        
        cell = [[RentCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                              reuseIdentifier:cellidenty];
        
    }
    
    if (indexPath.row % 2 ==0) {
        
        
        cell.backgroundColor = UIColorFromRGB(250.0, 244.0, 234.0);
        
        
        
    }else {
        
        cell.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
        
        
        
    }
    //为cell赋值
    [cell setCellInfo:scanDataArray[indexPath.row]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    House* house = scanDataArray[indexPath.row];
    RentDetailViewController* rentDetail = [[RentDetailViewController alloc] init];
    rentDetail.houseID = house.houseID;
    rentDetail.mainViewController = self.mainController;
    rentDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rentDetail animated:YES];
    
    
}


- (void)backButtonMethod
{

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return YES;
    
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return UITableViewCellEditingStyleDelete;
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        House *house = [scanDataArray objectAtIndex:indexPath.row];
        
        
        NSLog(@"%@",house.houseID);
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            
           NSString* userId =[[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_ID];
            
            Result* result = [ManagerMember deleteScanHistoryList:userId houseID:[house.houseID intValue]];
            
            if (result.isSuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [scanDataArray removeObject:scanDataArray[indexPath.row]];
                    
                    [tableView beginUpdates];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [tableView endUpdates];
                    if (scanDataArray.count == 0) {
                     
                        [self loadWebServiceScanData];
                    }
                    
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSLog(@"%@",result.error.localizedDescription);
                        
                        
                        
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


- (void)DeleteCellRow:(UIButton*)bt
{

    if ([mainTableView isEditing]) {
        
        [mainTableView setEditing:NO animated:YES];
        [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
 
        
        
    }else {
    
        [mainTableView setEditing:YES animated:YES];
        [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    
    
    }


}



//获取浏览数据
- (void)loadWebServiceScanData
{
    
    
    
    dispatch_queue_t queue  =  dispatch_queue_create("scanQueue", NULL);
    
    
    dispatch_async(queue, ^{
   
        
        NSString* userId = [[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_ID];
        
    
        NSLog(@"userid = %@",userId);
        
        Result* result = [ManagerMember getMyScanList:userId offset:0 length:10];
        
     
        if (result.isSuccess) {
          
       dispatch_async(dispatch_get_main_queue(), ^{
         
           scanDataArray = [NSMutableArray arrayWithArray:result.data];
           
           NSLog(@"scanDataArray.count = %d",scanDataArray.count);
           
           if (scanDataArray.count > 0) {
               
               [activityIndicatorView removeFromSuperview];
               mainTableView.hidden = NO;
               rightButton.hidden = NO;
               self.emptyImageView.hidden = YES;
               self.emptyLable.hidden = YES;
               [mainTableView reloadData];
               
               
           } else {
               
               [activityIndicatorView removeFromSuperview];
               mainTableView.hidden = YES;
               self.emptyImageView.hidden = NO;
               self.emptyLable.hidden = NO;
               rightButton.hidden = YES;
           }
           
           
           
       });
            
            
        
        }

        
    });
  
}


@end
