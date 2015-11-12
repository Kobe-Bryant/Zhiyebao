//
//  MemberReginViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-5-2.
//
//

#import "MemberReginViewController.h"
#import "Macros.h"
#import "ManagerMember.h"
#import "Result.h"
#import "NSString+Validator.h"

@interface MemberReginViewController ()
{
    UITextField* usernameField;
    UITextField* passwordField;
    UIScrollView* mainScrollView;
}

//用户注册调用的方法
- (void)reginUsernameMethod;

@end

@implementation MemberReginViewController

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
    
    
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        // 设置导航栏的背景
        UIImage* navigationBarImage = [UIImage imageNamed:@"ios7tabbarImage.png"];
        [self.navigationController.navigationBar setBackgroundImage:navigationBarImage
                                                      forBarMetrics:UIBarMetricsDefault];
    } else {
        UIImage* barBackImage = [UIImage imageNamed:@"ios6tabbarImage.png"];
        [self.navigationController.navigationBar setBackgroundImage:barBackImage
                                                      forBarMetrics:UIBarMetricsDefault];
    }
    
    //navigationItem的titleView
//    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 40, 30)];
//    label.textColor = [UIColor whiteColor];
//    label.font = [UIFont systemFontOfSize:20.0];
//    label.backgroundColor = [UIColor clearColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = NSLocalizedString(@"注册", nil);
//    self.navigationItem.titleView = label;
    self.title = @"注册";
    
    
    //返回的leftBarButtonItem
    UIImage* image = [UIImage imageNamed:@"arrowImage.png"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self
                   action:@selector(backButtonMethod)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
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
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
    [self.view addSubview:mainScrollView];
    
    
    
    
    UIImage* usernameImage = [UIImage imageNamed:@"loginusernameImage.png"];
    UIImageView* usernameImageView = [[UIImageView alloc] init];
    usernameImageView.frame = CGRectMake((self.view.frame.size.width - usernameImage.size.width) / 2.0,
                                         25.0,
                                         usernameImage.size.width,
                                         usernameImage.size.height);
    usernameImageView.userInteractionEnabled = YES;
    usernameImageView.image = usernameImage;
    [mainScrollView addSubview:usernameImageView];
    
    usernameField = [[UITextField alloc]initWithFrame:
                     CGRectMake(40.0, 8.0, 250.0, 30.0)];
    usernameField.userInteractionEnabled = YES;
    usernameField.textColor = UIColorFromRGB(27.0, 27.0, 27.0);
    usernameField.tag = 1;
    usernameField.delegate = self;
    usernameField.font = [UIFont systemFontOfSize:15];
    usernameField.placeholder = @"请输入真实有效的手机号码";
    usernameField.borderStyle = UITextBorderStyleNone;
    usernameField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [usernameImageView addSubview:usernameField];
    
    
    
    UIImage* passwordImage = [UIImage imageNamed:@"passwordImage.png"];
    UIImageView* passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                      ((self.view.frame.size.width - passwordImage.size.width)/2.0,
                                       35.0+usernameImage.size.height ,
                                       passwordImage.size.width,
                                       passwordImage.size.height)];
    passwordImageView.userInteractionEnabled = YES;
    passwordImageView.image = passwordImage;
    [mainScrollView addSubview:passwordImageView];
    
    
    passwordField = [[UITextField alloc]initWithFrame:
                     CGRectMake(40.0, 10.0, 160.0, 30.0)];
    passwordField.userInteractionEnabled = YES;
    passwordField.textColor = UIColorFromRGB(181.0, 181.0, 181.0);
    passwordField.tag = 1;
    passwordField.delegate = self;
    passwordField.font = [UIFont systemFontOfSize:14];
    passwordField.placeholder = @"请输入密码";
    [passwordField setBorderStyle:UITextBorderStyleNone];
    [passwordImageView addSubview:passwordField];
    
    
    
    UIImage* saveImage = [UIImage imageNamed:@"savepasswordImage.png"];
    UIButton* reginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reginButton.frame = CGRectMake((self.view.frame.size.width - saveImage.size.width)/2.0,
                                      160.0,
                                   saveImage.size.width,
                                   saveImage.size.height);
    [reginButton setBackgroundImage:saveImage forState:UIControlStateNormal];
    [reginButton addTarget:self action:@selector(reginMethod:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:reginButton];
    
    UILabel* reginLable = [[UILabel alloc]init];
    reginLable.frame = CGRectMake(140.0, 8.0, 40.0, 30.0);
    reginLable.text = @"注册";
    reginLable.textColor = [UIColor whiteColor];
    [reginButton addSubview:reginLable];
}

-(void)reginMethod:(UIButton*)tap
{
    
    
    [self reginUsernameMethod];
    
}

- (void)backButtonMethod
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//用户注册调用的方法
- (void)reginUsernameMethod
{
    if (usernameField.text.length == 0) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:usernameField.placeholder
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (![usernameField.text isMobile]) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"请输入正确的手机号码"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (passwordField.text.length == 0) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:passwordField.placeholder
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    dispatch_queue_t queue = dispatch_queue_create("reginQueue", NULL);
    dispatch_async(queue, ^{
        Result* result = [ManagerMember memberRegin:usernameField.text reginPassword:passwordField.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.isSuccess) {
                usernameField.text = @"";
                passwordField.text = @"";
                
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"注册成功"
                                                                   message:nil
                                                                  delegate:nil
                                                         cancelButtonTitle:@"取消"
                                                         otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[result.error localizedDescription]
                                                                   message:nil
                                                                  delegate:nil
                                                         cancelButtonTitle:@"取消"
                                                         otherButtonTitles:nil, nil];
                [alertView show];
            }
        });
    });
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
