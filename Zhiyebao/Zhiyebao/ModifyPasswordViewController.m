//
//  ModifyPasswordViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-5-31.
//
//

#import "ModifyPasswordViewController.h"
#import "Macros.h"
#import "Result.h"
#import "Member.h"

@interface ModifyPasswordViewController ()
{

    UIScrollView* mainScrollView;
    UITextField*  oldPasswordField;
    UITextField*  newPasswordField;
    UITextField*  againNewPasswordField;


}
@end

@implementation ModifyPasswordViewController

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
    
    
    UIImage* passwordImage = [UIImage imageNamed:@"passwordImage.png"];
    UIImageView* oldPasswordImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                      ((self.view.frame.size.width - passwordImage.size.width)/2.0,
                                       20.0,
                                       passwordImage.size.width,
                                       passwordImage.size.height)];
    oldPasswordImageView.userInteractionEnabled = YES;
    oldPasswordImageView.image = passwordImage;
    [mainScrollView addSubview:oldPasswordImageView];
    
    
    oldPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(40,
                                                                    10,
                                                                    160,
                                                                    30)];
    oldPasswordField.userInteractionEnabled = YES;
    oldPasswordField.textColor = UIColorFromRGB(181.0, 181.0, 181.0);
    oldPasswordField.tag = 1;
    oldPasswordField.font = [UIFont systemFontOfSize:14];
    oldPasswordField.placeholder = @"请输入原密码";
    [oldPasswordField setBorderStyle:UITextBorderStyleNone];
    oldPasswordField.secureTextEntry = YES;
    [oldPasswordImageView addSubview:oldPasswordField];
    
    
    UIImageView* newPasswordImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                         ((self.view.frame.size.width - passwordImage.size.width)/2.0,
                                          20.0+ passwordImage.size.height+5.0,
                                          passwordImage.size.width,
                                          passwordImage.size.height)];
    newPasswordImageView.userInteractionEnabled = YES;
    newPasswordImageView.image = passwordImage;
    [mainScrollView addSubview:newPasswordImageView];
    
    newPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(40,
                                                                    10,
                                                                    160,
                                                                    30)];
    newPasswordField.userInteractionEnabled = YES;
    newPasswordField.textColor = UIColorFromRGB(181.0, 181.0, 181.0);
    newPasswordField.tag = 2;
    newPasswordField.font = [UIFont systemFontOfSize:14];
    newPasswordField.placeholder = @"请输入新密码";
    [newPasswordField setBorderStyle:UITextBorderStyleNone];
    newPasswordField.secureTextEntry = YES;
    [newPasswordImageView addSubview:newPasswordField];

    
    
    UIImageView* againNewPasswordImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                         ((self.view.frame.size.width - passwordImage.size.width)/2.0,
                                          20.0+ passwordImage.size.height+5.0+ passwordImage.size.height+5.0,
                                          passwordImage.size.width,
                                          passwordImage.size.height)];
    againNewPasswordImageView.userInteractionEnabled = YES;
    againNewPasswordImageView.image = passwordImage;
    [mainScrollView addSubview:againNewPasswordImageView];
    
    againNewPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(40,
                                                                         10,
                                                                         160,
                                                                         30)];
    againNewPasswordField.userInteractionEnabled = YES;
    againNewPasswordField.textColor = UIColorFromRGB(181.0, 181.0, 181.0);
    againNewPasswordField.tag = 3;
    againNewPasswordField.font = [UIFont systemFontOfSize:14];
    againNewPasswordField.placeholder = @"请再次输入新密码";
    [againNewPasswordField setBorderStyle:UITextBorderStyleNone];
    againNewPasswordField.secureTextEntry = YES;
    [againNewPasswordImageView addSubview:againNewPasswordField];
    

    UIImage* saveImage = [UIImage imageNamed:@"savepasswordImage.png"];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.view.frame.size.width - saveImage.size.width)/2.0,
                              30+passwordImage.size.height*3+10.0,
                              saveImage.size.width,
                              saveImage.size.height);
    [button setBackgroundImage:saveImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(savePassword) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:button];
    
    UILabel* saveLable = [[UILabel alloc]init];
    saveLable.frame = CGRectMake(140.0, 8.0, 40.0, 30.0);
    saveLable.text = @"保存";
    saveLable.textColor = [UIColor whiteColor];
    [button addSubview:saveLable];
    
}
- (void)savePassword
{

    if (oldPasswordField.text.length == 0) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:oldPasswordField.placeholder
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (newPasswordField.text.length == 0) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:newPasswordField.placeholder
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (![newPasswordField.text isEqualToString:againNewPasswordField.text]) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"两次输入的密码不一致，请重新输入"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    dispatch_queue_t queue = dispatch_queue_create("modifyQueue", NULL);
    dispatch_async(queue, ^{
        
        Member* member = [Member shareMember];
        
        Result* result = [Member resetPassword:member.memberID oldPassword:oldPasswordField.text newPassword:newPasswordField.text];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.isSuccess) {
          
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
- (void)backButtonMethod
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [oldPasswordField resignFirstResponder];
    [newPasswordField resignFirstResponder];
    [againNewPasswordField resignFirstResponder];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];


}


@end
