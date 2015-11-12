//
//  RentGalleryViewController.m
//  Zhiyebao
//
//  Created by LaiZhaowu on 14-5-29.
//
//

#import "RentGalleryViewController.h"
#import "Macros.h"
#import "HouseImage.h"
#import "CustomMarcos.h"


@interface RentGalleryViewController ()
{

    UIView* blackView;
    

}
@property (nonatomic, retain) NSArray *homeImageArray;
@property (nonatomic) NSUInteger currentSelectedIndex;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation RentGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithHouseImageArray:(NSArray *)houseImageArray currentSelectedIndex:(NSUInteger)currentSelectedIndex
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.homeImageArray = houseImageArray;
        self.currentSelectedIndex = currentSelectedIndex;
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //监听隐藏NavigationBar的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:
            @selector(hiddenNavigationBar:) name:HIDDEN_NAVIGATION_BAR object:nil];
    
    
    self.title = [[NSString alloc] initWithFormat:@"第 %i 张图（共 %i 张）", (self.currentSelectedIndex + 1), [self.homeImageArray count]];
    
    UIImage* image = [UIImage imageNamed:@"arrowImage.png"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0.0,
                                  0.0,
                                  image.size.width,
                                  image.size.height);
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBack:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;

    
    self.view.backgroundColor = UIColorFromRGB(60.0, 60.0, 60.0);
    
    
    
    
    //返回的leftBarButtonItem
    UIImage* downLoadImage = [UIImage imageNamed:@"downLoadImage.png"];
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0.0,
                                   0.0,
                                  downLoadImage.size.width,
                                  downLoadImage.size.height);
    [rightButton setImage:downLoadImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(downLoadMethod:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
  //  self.view.backgroundColor = UIColorFromRGB(252.0, 243.0, 234.0);
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    // Set page data source
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    self.pageViewController.view.frame = CGRectMake(0.0,
                                                    0.0,
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.height);
    //    self.pageViewController.view.backgroundColor = [UIColor yellowColor];
    NSLog(@"self.pageViewController.view.frame %@", NSStringFromCGRect(self.pageViewController.view.frame));
    
    
    // Load image
    UIViewController *initialViewController = [self viewControllerAtIndex:self.currentSelectedIndex];
    [self.pageViewController setViewControllers:[NSArray arrayWithObject:initialViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    
    
    // Page control
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(0.0,
                                        self.view.frame.size.height - 70.0,
                                        self.view.frame.size.width,
                                        70.0);
    
    if ([self.pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
        NSLog(@"TTTTTTTTTT");
        self.pageControl.pageIndicatorTintColor = UIColorFromRGB(149.0, 149.0, 149.0);
    }
    if ([self.pageControl respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)]) {
        self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(237.0, 120.0, 51.0);
    }
    self.pageControl.currentPage = self.currentSelectedIndex;
    self.pageControl.numberOfPages = [self.homeImageArray count];
    self.pageControl.hidesForSinglePage = YES;
    //        pageControl.userInteractionEnabled = NO;
    [self.view addSubview:self.pageControl];


    
}

//隐藏NavigationBar
- (void)hiddenNavigationBar:(UITapGestureRecognizer*)tap
{
    
    if (self.navigationController.navigationBarHidden) {
        
      [self.navigationController setNavigationBarHidden:NO animated:YES];
 
    } else {
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    }

}

- (void)goBack:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

//下载图片
- (void)downLoadMethod:(UIButton*)bt
{
    
    
    HouseImage* houseImage = [self.homeImageArray objectAtIndex:self.pageControl.currentPage];
    
    if (![houseImage.largeImageURLString isEqualToString:houseImage.lastLargeImageURLString]) {
        
        houseImage.lastLargeImageURLString = houseImage.largeImageURLString;
        
        
        NSURL* houseImageUrl = [NSURL URLWithString:houseImage.lastLargeImageURLString];
        NSData* data = [NSData dataWithContentsOfURL:houseImageUrl];
        UIImage* image = [UIImage imageWithData:data];
        
        //将图片保存到相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    } else {
    
       UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:@"图片已下载!" delegate:nil
                                             cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alertView show];
        
   }
    
}

//保存到相册后回调的方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{

    if (error==nil) {
      
    
        blackView = [[UIView alloc]initWithFrame:CGRectMake(80.0, 400.0, 165.0, 29.0)];
        blackView.layer.cornerRadius= 4.0;
        blackView.backgroundColor = UIColorFromRGB(78.0, 78.0, 78.0);
        [self.view addSubview:blackView];
        
        
        UILabel* saveLable = [[UILabel alloc]init];
        saveLable.frame = CGRectMake(15.0, 0.5, 140.0, 30.0);
        saveLable.font = [UIFont systemFontOfSize:12.0];
        saveLable.textColor = [UIColor whiteColor];
        saveLable.text = @"图片已经保存到截图相册";
        [blackView addSubview:saveLable];
     
        [self performSelector:@selector(cancelBlackView) withObject:nil afterDelay:1.5];
        
        }else {
    
      NSLog(@"error = %@",error);
         
    }
 
}

- (void)cancelBlackView{

    
    [blackView removeFromSuperview];
    
    
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    HouseImage *houseImage = [self.homeImageArray objectAtIndex:index];
    RentImageViewController *controller = [[RentImageViewController alloc] initWithImageURLString:houseImage.largeImageURLString currentSelectedIndex:index];
    controller.view.frame = CGRectMake(0.0,
                                       0.0,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height);
    controller.delegate = self;
    return controller;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    RentImageViewController *controller = (RentImageViewController *)viewController;
    NSUInteger index = controller.currentSelectedIndex;
    if (controller.currentSelectedIndex == 0) {
        index = [self.homeImageArray count];
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    RentImageViewController *controller = (RentImageViewController *)viewController;
    
    NSUInteger index = controller.currentSelectedIndex;
    
    index++;
    
    if (index >= [self.homeImageArray count]) {
        index = 0;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    // The number of items reflected in the page indicator.
    //    return [self.magazineImageArray count];
    return 0;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    // The selected item reflected in the page indicator.
    return 0;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        RentImageViewController *currentVC = (RentImageViewController *)[self.pageViewController.viewControllers lastObject];
        self.pageControl.currentPage = [currentVC currentSelectedIndex];
        self.title = [[NSString alloc] initWithFormat:@"第 %i 张图（共 %i 张）", (self.pageControl.currentPage + 1), [self.homeImageArray count]];
    }
}

- (void)didZoomAnimate:(BOOL)isMinSize
{
    self.pageControl.hidden = !isMinSize;
}

@end
