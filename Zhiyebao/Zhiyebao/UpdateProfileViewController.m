//
//  UpdateProfileViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-5-31.
//
//

#import "UpdateProfileViewController.h"
#import "Macros.h"
#import "Member.h"
#import "ManagerMember.h"
#import "CustomMarcos.h"


@interface UpdateProfileViewController ()
{

    UIScrollView* mainScrollView;
    UITextField* usernameFiled;
    UITextField* sexField;
    
    
}
//获取会员信息
- (void)getMemberInfomation;


@end

@implementation UpdateProfileViewController

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
    
    self.title = @"个人信息";
    
    
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
}

- (void)viewWillAppear:(BOOL)animated
{

  [super viewWillAppear:animated];
    
    
    mainScrollView = [[UIScrollView alloc] init];
    mainScrollView.frame = CGRectMake(0.0,
                                      0.0,
                                      self.view.frame.size.width,
                                      self.view.frame.size.height);
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 580.0);
    mainScrollView.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
    mainScrollView.delegate = self;
    [self.view addSubview:mainScrollView];
    
    
    
    UIImage* usernameImage = [UIImage imageNamed:@"username.png"];
    UIImageView* usernameImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                         ((self.view.frame.size.width - usernameImage.size.width)/2.0,
                                          20.0,
                                          usernameImage.size.width,
                                          usernameImage.size.height)];
    usernameImageView.userInteractionEnabled = YES;
    usernameImageView.image = usernameImage;
    [mainScrollView addSubview:usernameImageView];
    
    
    UILabel* usernameLable = [[UILabel alloc]init];
    usernameLable.frame = CGRectMake(10.0, 8.0, 60.0, 30.0);
    usernameLable.text = @"姓名 :";
    usernameLable.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
    [usernameImageView addSubview:usernameLable];
    
    
    
    usernameFiled = [[UITextField alloc]initWithFrame:CGRectMake(60,
                                                                 8,
                                                                 160,
                                                                 30)];
    usernameFiled.userInteractionEnabled = YES;
    usernameFiled.textColor = UIColorFromRGB(181.0, 181.0, 181.0);
    usernameFiled.tag = 1;
    usernameFiled.font = [UIFont systemFontOfSize:14];
    [usernameFiled setBorderStyle:UITextBorderStyleNone];
    [usernameImageView addSubview:usernameFiled];

    
    UIImageView* sexImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                      ((self.view.frame.size.width - usernameImage.size.width)/2.0,
                                       20.0+usernameImage.size.height+10.0,
                                       usernameImage.size.width,
                                       usernameImage.size.height)];
    sexImageView.userInteractionEnabled = YES;
    sexImageView.image = usernameImage;
    [mainScrollView addSubview:sexImageView];

    UILabel* sexLable = [[UILabel alloc]init];
    sexLable.frame = CGRectMake(10.0, 8.0, 60.0, 30.0);
    sexLable.text = @"性别 :";
    sexLable.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
    [sexImageView addSubview:sexLable];
    
    sexField = [[UITextField alloc]initWithFrame:CGRectMake(60,
                                                             8,
                                                             160,
                                                             30)];
    sexField.userInteractionEnabled = YES;
    sexField.textColor = UIColorFromRGB(181.0, 181.0, 181.0);
    sexField.tag = 2;
    sexField.font = [UIFont systemFontOfSize:14];
    [sexField setBorderStyle:UITextBorderStyleNone];
    [sexImageView addSubview:sexField];
    
    
    UIImage* saveImage = [UIImage imageNamed:@"savepasswordImage.png"];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.view.frame.size.width - saveImage.size.width)/2.0,
                              30+usernameImage.size.height*2+10.0,
                              saveImage.size.width,
                              saveImage.size.height);
    [button setBackgroundImage:saveImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveMethod) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:button];
    
    UILabel* saveLable = [[UILabel alloc]init];
    saveLable.frame = CGRectMake(140.0, 8.0, 40.0, 30.0);
    saveLable.text = @"保存";
    saveLable.textColor = [UIColor whiteColor];
    [button addSubview:saveLable];
    
    [self getMemberInfomation];
    

}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [usernameFiled resignFirstResponder];
    [sexField resignFirstResponder];
    
}
- (void)backButtonMethod
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];


}
- (void)saveMethod
{
    
    if (usernameFiled.text.length == 0) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"用户名不能为空"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
 
    
    if (sexField.text.length == 0) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"性别不能为空"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    dispatch_queue_t queue = dispatch_queue_create("modifyQueue", NULL);
    dispatch_async(queue, ^{
        
        Member* member = [Member shareMember];
        
        int gender;
        
        if ([sexField.text isEqualToString:@"男"]) {
            
            gender = 1;
            
        }else {
         
            gender = 0;
            
       }
        
        NSLog(@"%@",member.memberID);
        
        Result* result = [Member modifyProfile:member.memberID name:usernameFiled.text sex:gender];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.isSuccess) {
                
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"修改信息成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            
                NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:usernameFiled.text,@"username", nil];
                

                [[NSNotificationCenter defaultCenter]postNotificationName:MODIFY_PERSON_INFOMATION
                                                                   object:nil
                                                                 userInfo:dic];
                
                
               } else {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:[result.error localizedDescription]
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        });
    });
    
}

//获取会员信息
- (void)getMemberInfomation
{
    dispatch_queue_t queue = dispatch_queue_create("getMemberInfomationQueue", NULL);
    dispatch_async(queue, ^{
        
        Member* member = [Member shareMember];
        NSLog(@"%@",member.memberID);
        
        Result* result =[ManagerMember memberInfomation:member.memberID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.isSuccess) {
        
                Member* member = [Member shareMember];
                member = result.data;
                if ([member.name length] > 0) {
                    usernameFiled.text = member.name;
                } else {
                    usernameFiled.text = member.loginUsername;

                }
                 sexField.text = member.sexString;
                
             }
        });
    });
}

@end
