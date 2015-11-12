//
//  MemberLoginViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-5-1.
//
//

#import "MemberLoginViewController.h"
#import "MemberReginViewController.h"
#import "Macros.h"
#import "ForgetPasswordViewController.h"
#import "ManagerMember.h"
#import "Result.h"
#import "Member.h"
#import "NSString+Validator.h"
#import "CustomMarcos.h"


@interface MemberLoginViewController ()
{
    
    UITextField* usernameField ;
    UITextField* passwordField ;
    UIScrollView* mainScrollView;
    
    
}
@end

@implementation MemberLoginViewController

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
    
    self.view.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
    
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        //设置导航栏的背景
        UIImage* navigationBarImage = [UIImage imageNamed:@"ios7tabbarImage.png"];
        [self.navigationController.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
    }else  {
        
        UIImage* barBackImage = [UIImage imageNamed:@"ios6tabbarImage.png"];
        [self.navigationController.navigationBar setBackgroundImage:barBackImage  forBarMetrics:UIBarMetricsDefault];
    }
    
    //navigationItem的titleView
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(160.0, 0.0, 40.0, 30.0)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20.0];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"登录", nil);
    self.navigationItem.titleView = label;
    
    
    
    //rightBarButtonItem
    UIImage* rightImage = [UIImage imageNamed:@"closeImage.png"];
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(262.0,
                                   8.0,
                                   rightImage.size.width,
                                   rightImage.size.height);
    [rightButton setImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonMethod)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear: animated];
    
    mainScrollView = [[UIScrollView alloc] init];
    mainScrollView.frame = CGRectMake(0.0,
                                      0.0,
                                      self.view.frame.size.width,
                                      self.view.frame.size.height);
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 580.0);
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);
    [self.view addSubview:mainScrollView];
    
    
    
    
    UIImage* usernameImage = [UIImage imageNamed:@"loginusernameImage.png"];
    UIImageView* usernameImageView = [[UIImageView alloc] init];
    usernameImageView.frame = CGRectMake((self.view.frame.size.width - usernameImage.size.width) / 2.0,
                                         25.0 ,
                                         usernameImage.size.width,
                                         usernameImage.size.height);
    usernameImageView.userInteractionEnabled = YES;
    usernameImageView.image = usernameImage;
    [mainScrollView addSubview:usernameImageView];
    
    
    usernameField = [[UITextField alloc] initWithFrame:CGRectMake(40, 8, 160, 30)];
    usernameField.userInteractionEnabled = YES;
    usernameField.textColor = UIColorFromRGB(27.0, 27.0, 27.0);
    usernameField.tag = 1;
    usernameField.font = [UIFont systemFontOfSize:15];
    usernameField.placeholder = @"请输入手机号码";
    usernameField.borderStyle = UITextBorderStyleNone;
    usernameField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [usernameImageView addSubview:usernameField];
    
    
    
    UIImage* passwordImage = [UIImage imageNamed:@"passwordImage.png"];
    UIImageView* passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                      ((self.view.frame.size.width - passwordImage.size.width)/2.0,
                                       35.0+usernameImage.size.height,
                                       passwordImage.size.width,
                                       passwordImage.size.height)];
    passwordImageView.userInteractionEnabled = YES;
    passwordImageView.image = passwordImage;
    [mainScrollView addSubview:passwordImageView];
    
    
    passwordField = [[UITextField alloc]initWithFrame:
                     CGRectMake(40, 8, 160, 30)];
    passwordField.userInteractionEnabled = YES;
    passwordField.textColor = UIColorFromRGB(181.0, 181.0, 181.0);
    passwordField.tag = 1;
    passwordField.font = [UIFont systemFontOfSize:14];
    passwordField.placeholder = @"请输入密码";
    [passwordField setBorderStyle:UITextBorderStyleNone];
    passwordField.secureTextEntry = YES;

    [passwordImageView addSubview:passwordField];
    
    
    
    
    UIImage* saveImage = [UIImage imageNamed:@"savepasswordImage.png"];
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake((self.view.frame.size.width - saveImage.size.width)/2.0,
                             35.0+usernameImage.size.height+20.0+passwordImage.size.height,
                              saveImage.size.width,
                              saveImage.size.height);
    [loginButton setBackgroundImage:saveImage forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginMethod:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:loginButton];
    
    UILabel* saveLable = [[UILabel alloc]init];
    saveLable.frame = CGRectMake(140.0, 8.0, 40.0, 30.0);
    saveLable.text = @"登录";
    saveLable.textColor = [UIColor whiteColor];
    [loginButton addSubview:saveLable];
    
    
    
    
    //?
    UIButton* forgetButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(-25.0,
                                    35.0+usernameImage.size.height+20.0+passwordImage.size.height+saveImage.size.height+10.0,
                                    160.0,
                                    30.0);
    [forgetButton addTarget:self action:@selector(forgetMethod) forControlEvents:UIControlEventTouchUpInside];
    [forgetButton setTitle:@"忘记密码 ?" forState:UIControlStateNormal];
    [forgetButton setTitleColor: UIColorFromRGB(160.0,160.0, 160.0) forState:UIControlStateNormal];
    [mainScrollView addSubview:forgetButton];
    
    
    
    UILabel*  reginLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - saveImage.size.width)/2.0,
                                                                    35.0+usernameImage.size.height+20.0+passwordImage.size.height+saveImage.size.height+70,
                                                                    250.0,
                                                                    30.0)];
    reginLabel.textColor = UIColorFromRGB(160.0,160.0, 160.0);
    reginLabel.font = [UIFont systemFontOfSize:12.0];
    reginLabel.backgroundColor = [UIColor clearColor];
    reginLabel.text = @"如果您还不是会员请点击这里注册";
    [mainScrollView addSubview:reginLabel];
    
    
    
    UIButton* reginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reginButton.frame = CGRectMake((self.view.frame.size.width - saveImage.size.width)/2.0,
                                    35.0+usernameImage.size.height+20.0+passwordImage.size.height+saveImage.size.height+70.0+35.0,
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

- (void)forgetMethod{
    
    
    
    ForgetPasswordViewController* forgetVC = [[ForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
    
    
}

- (void)rightButtonMethod{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)loginMethod:(UIButton*)loginButton
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
    
    dispatch_queue_t queue = dispatch_queue_create("loginQueue", NULL);
    dispatch_async(queue, ^{
        Result* result = [ManagerMember memberLogin:usernameField.text
                                      loginPassword:passwordField.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.isSuccess) {
                Member* member = result.data;
                [[NSUserDefaults standardUserDefaults] setObject:usernameField.text forKey:LOGIN_USER_NAME];
                [[NSUserDefaults standardUserDefaults] setObject:passwordField.text forKey:LOGIN_PASSWORD];
                [[NSUserDefaults standardUserDefaults] setObject:member.memberID forKey:MEMBER_ID];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"islogin"];
                member.loginUsername = usernameField.text;
                member.loginPassword = passwordField.text;
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)reginMethod:(UIButton*)reginBt
{
    MemberReginViewController* reginVC = [[MemberReginViewController alloc] init];
//    UINavigationController* na = [[UINavigationController alloc]initWithRootViewController:reginVC];
//    [self presentViewController:na animated:YES completion:nil];
    [self.navigationController pushViewController:reginVC animated:YES];
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
