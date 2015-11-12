//
//  ForgetPasswordViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-5-2.
//
//

#import "ForgetPasswordViewController.h"
#import "Macros.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController

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

    
    //navigationItem的titleView
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20.0];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"忘记密码", nil);
    self.navigationItem.titleView = label;
    
    
    //返回的leftBarButtonItem
    UIImage* image = [UIImage imageNamed:@"arrowImage.png"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0.0, 0.0,image.size.width, image.size.height);
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonMethod)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
}

- (void)viewWillAppear:(BOOL)animated{


    [super viewWillAppear: animated];
    
    UIImage* usernameImage = [UIImage imageNamed:@"inputusername.png"];
    UIImageView* usernameImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                      ((self.view.frame.size.width - usernameImage.size.width)/2.0,
                                       60.0 ,
                                       usernameImage.size.width,
                                       usernameImage.size.height)];
    usernameImageView.userInteractionEnabled = YES;
    usernameImageView.image = usernameImage;
    [self.view addSubview:usernameImageView];
    
    
    
    UITextField* usernameField = [[UITextField alloc]initWithFrame:CGRectMake(5.0,
                                                                              10.0,
                                                                              160,
                                                                              30)];
    usernameField.userInteractionEnabled = YES;
    usernameField.textColor = UIColorFromRGB(210.0, 210.0, 210.0);
    usernameField.tag = 1;
    usernameField.font = [UIFont systemFontOfSize:14.0];
    usernameField.placeholder = @"请输入您的手机号";
    [usernameField setBorderStyle:UITextBorderStyleNone];
    [usernameImageView addSubview:usernameField];
    
    
    //navigationItem的titleView
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - usernameImage.size.width)/2.0,
                                                                   15.0,
                                                                   240.0,
                                                                   30.0)];
    titleLabel.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
    titleLabel.font = [UIFont systemFontOfSize:12.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"如需重设密码, 请输入已绑定的手机号。";
    [self.view addSubview:titleLabel];
    
    
    UIImage* catchImage = [UIImage imageNamed:@"inputcatch.png"];
    UIImageView* catchImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                      ((self.view.frame.size.width - usernameImage.size.width)/2.0,
                                       130.0 ,
                                       catchImage.size.width,
                                       catchImage.size.height)];
    catchImageView.userInteractionEnabled = YES;
    catchImageView.image = catchImage;
    [self.view addSubview:catchImageView];
    
    UITextField* catchField = [[UITextField alloc]initWithFrame:
                                  CGRectMake(5.0, 10.0, 160, 30)];
    catchField.userInteractionEnabled = YES;
    catchField.textColor = UIColorFromRGB(210.0, 210.0, 210.0);
    catchField.tag = 1;
    catchField.font = [UIFont systemFontOfSize:14.0];
    catchField.placeholder = @"请输入验证码";
    [catchField setBorderStyle:UITextBorderStyleNone];
    [catchImageView addSubview:catchField];
    
    
    
    UIImage* getcatchImage = [UIImage imageNamed:@"getcatch.png"];
    UIImageView* getcatchImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                   ((self.view.frame.size.width - usernameImage.size.width)/2.0+catchImage.size.width+8.0,
                                    130.0,
                                    getcatchImage.size.width,
                                    getcatchImage.size.height)];
    getcatchImageView.userInteractionEnabled = YES;
    getcatchImageView.image = getcatchImage;
    [self.view addSubview:getcatchImageView];
    
    
    UIImage* getpasswordImage = [UIImage imageNamed:@"getpassword.png"];
    UIImageView* getpasswordImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                      ((self.view.frame.size.width - getpasswordImage.size.width)/2.0,
                                       130.0+getcatchImage.size.height+40.0,
                                       getpasswordImage.size.width,
                                       getpasswordImage.size.height)];
    getpasswordImageView.userInteractionEnabled = YES;
    getpasswordImageView.image = getpasswordImage;
    [self.view addSubview:getpasswordImageView];
    
    
}

- (void)backButtonMethod{

    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
