//
//  ContactViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-5-2.
//
//

#import "ContactViewController.h"
#import "RentModel.h"
#import "RentCell.h"
#import "MainViewController.h"
#import "RentDetailViewController.h"
#import "Macros.h"
#import "ManagerMember.h"
#import "Result.h"
#import "CustomMarcos.h"
#import "Member.h"


@interface ContactViewController ()
{

    NSMutableArray* contactArray;
    UITableView* mainTableView;
    UIButton* rightButton;
    UIActivityIndicatorView *activityIndicatorView;
    


}
@property(nonatomic,strong) UIImageView* emptyImageView;
@property(nonatomic,strong) UILabel* emptyLable;


//请求联系记录列表
- (void)loadContactList;

@end

@implementation ContactViewController

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

    //navigationItem的titleView
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(160.0,
                                                              0.0,
                                                              40.0,
                                                              30.0)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20.0];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"联系记录", nil);
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

    contactArray = [NSMutableArray array];

    
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
    
    

    [self loadContactList];
    
    
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
    self.emptyLable.text = @"抱歉，还没有找到相关联系记录!";
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
    
}

#pragma mark UITableviewDatasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100.0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return contactArray.count;
    
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
    [cell setCellInfo:contactArray[indexPath.row]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    House* house = contactArray[indexPath.row];
    RentDetailViewController* rentDetail = [[RentDetailViewController alloc]initWithDataObject:house.houseID];
    rentDetail.mainViewController = self.mainController;
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
        
        
        House *house = [contactArray objectAtIndex:indexPath.row];
        
        
        NSLog(@"%@",house.houseID);
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            
            NSString* userId =[[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_ID];
            
            Result* result =[ManagerMember deleteContactList:userId houseId:[house.houseID intValue]];
            
            
            if (result.isSuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [contactArray removeObject:contactArray[indexPath.row]];
                    
                    [tableView beginUpdates];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [tableView endUpdates];
                    if (contactArray.count ==0) {
                        
                        [self loadContactList];
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


//请求联系记录列表
- (void)loadContactList
{

    dispatch_queue_t queue  =  dispatch_queue_create("ContactQueue", NULL);
    dispatch_async(queue, ^{
        
        
        NSString* userId =[[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_ID];
        
        Result* result = [ManagerMember getMyContactList:userId  offset:0 length:100];
        
         dispatch_async(dispatch_get_main_queue(), ^{
            
             if (result.isSuccess) {
             
                 contactArray = [NSMutableArray arrayWithArray:result.data];
                 if (contactArray.count > 0) {
                     
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
             }
             
        });
    });
}
@end
