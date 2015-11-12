//
//  EnterViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-6-3.
//
//

#import "EnterViewController.h"
#import "CoustomPageControl.h"
#import "Macros.h"


@interface EnterViewController ()
{

    UIScrollView* mainScrollView;
    CoustomPageControl* coustomPageControl;
    UIImageView* imageView ;
    NSArray* enterImageArray;
    

}
@end

@implementation EnterViewController

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

}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
 
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0,
                                                                   0.0,
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height)];
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width*3, self.view.frame.size.height);
    mainScrollView.pagingEnabled = YES;
    mainScrollView.delegate = self;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainScrollView];
    
    
    
    if ([UIScreen mainScreen].bounds.size.height == 568.0) {
        enterImageArray = @[@"first-320-568.png",@"second-320-568.png",@"third-320-568.png"];
    } else {
        enterImageArray = @[@"first-320-480.png",@"second-320-480.png",@"third-320-480.png"];
    }
    

    
    
     for (int i = 0; i < 3; i++) {
     
        imageView = [[UIImageView alloc]initWithFrame:
                                    CGRectMake(0.0+320*i,
                                               0.0,
                                               self.view.frame.size.width,
                                               self.view.frame.size.height)];
         imageView.image = [UIImage imageNamed:enterImageArray[i]];
         imageView.userInteractionEnabled = YES;
         [mainScrollView addSubview:imageView];
         
         //自定义UIPageControl
         coustomPageControl = [[CoustomPageControl alloc] init] ;
         if ([UIScreen mainScreen].bounds.size.height < 481 ) {
             
             coustomPageControl.frame = CGRectMake(140+320*i, 380, 120, 30);
 
         }else {
         
             coustomPageControl.frame = CGRectMake(140+320*i, 460, 120, 30);

         }
         [coustomPageControl setNumberOfPages: 3] ;
         coustomPageControl.tag = 100+i;
         [coustomPageControl setDefersCurrentPageDisplay: NO] ;
         [coustomPageControl setType: DDPageControlTypeOnFullOffFull] ;
         [coustomPageControl setOnColor: [UIColor colorWithWhite: 1.0f alpha:1.0f]] ;
         [coustomPageControl setOffColor: UIColorFromRGB(230.0,177.0,146.0)] ;
         [coustomPageControl setIndicatorDiameter: 4.0f] ;
         [coustomPageControl setIndicatorSpace: 5.0f] ;
         [mainScrollView addSubview:coustomPageControl];
         
         if (i ==2) {
             
             if ([UIScreen mainScreen].bounds.size.height > 481) {
                 
                 UILabel* beginLable = [[UILabel alloc]initWithFrame:CGRectMake(120.0, 500.0, 100.0, 30.0)];
                 beginLable.font = [UIFont systemFontOfSize:13.0];
                 beginLable.textColor = [UIColor whiteColor];
                 beginLable.text = @"开始体验";
                 [imageView addSubview:beginLable];
                 
                 UIButton* enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
                 enterButton.frame = CGRectMake(90.0, 486.0, 200.0, 60.0);
                 [enterButton setImage:[UIImage imageNamed:
                                        @"enterHomeImage.png"]  forState:UIControlStateNormal];
                 [enterButton addTarget:self action:@selector(enterHomeMethod)
                       forControlEvents:UIControlEventTouchUpInside];
                 [imageView addSubview:enterButton];
                 
                 
             } else {
             
                 UILabel* beginLable = [[UILabel alloc]initWithFrame:CGRectMake(120.0, 420.0, 100.0, 30.0)];
                 beginLable.font = [UIFont systemFontOfSize:13.0];
                 beginLable.textColor = [UIColor whiteColor];
                 beginLable.text = @"开始体验";
                 [imageView addSubview:beginLable];
                 
                 UIButton* enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
                 enterButton.frame = CGRectMake(90.0, 406.0, 200.0, 60.0);
                 [enterButton setImage:[UIImage imageNamed:
                                        @"enterHomeImage.png"]  forState:UIControlStateNormal];
                 [enterButton addTarget:self action:@selector(enterHomeMethod)
                       forControlEvents:UIControlEventTouchUpInside];
                 [imageView addSubview:enterButton];
            }
             
          
             
         }
  
    }
 
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
    int currentPage = scrollView.contentOffset.x/320.0;
    NSLog(@"currentPage = %d",currentPage);
    CoustomPageControl* pagecontrol = (CoustomPageControl*)[mainScrollView viewWithTag:currentPage+100];
    [pagecontrol setCurrentPage: currentPage];

}


- (void)enterHomeMethod
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnterHomeVCMethod"
                                                        object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];


}


@end
