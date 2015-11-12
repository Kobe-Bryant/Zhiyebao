//
//  RentDetailViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-4-29.
//
//

#import "RentDetailViewController.h"
#import "BinnerViewController.h"
#import "Macros.h"
#import "BannerModel.h"
#import "MainViewController.h"
#import "House.h"
#import "ManagerMember.h"
#import "Result.h"
#import "MemberLoginViewController.h"
#import "RentGalleryViewController.h"
#import "Member.h"
#import "CustomMarcos.h"



@interface RentDetailViewController ()
{
    
    UIScrollView* mainScrollView;
    NSMutableArray* bannerImageArray;
    NSMutableArray* bannerArray;
    UILabel* countLabel;
    UIView* blackView;
    UIView* whiteView;
    
    UIView* collectBlackView;
    UIView* collectWhiteView;
    
    
    House *house;
    BOOL isViewWillAppeared;
    
    UILabel* collectLabel;
  
    UIPageControl *pageControl;
    House* collectHouse;
    
}

//判断房子是否存在
- (void)memberCollectHouseIsExisted;



@end

@implementation RentDetailViewController
@synthesize pageController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        

        
        
    }
    return self;
}

- (id)initWithDataObject:(id)dataObject
{
    self = [super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
        
        self.houseID = dataObject;

        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (self.changeBarColor) {
        UIImage* navigationBarImage = [UIImage imageNamed:@"ios7tabbarImage.png"];

        [self.navigationController.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"Transparent.png"]];
        
    }
    
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
    
    self.view.backgroundColor = UIColorFromRGB(252.0, 243.0, 234.0);
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"RentDetailViewController viewWillAppear");
    
    if (isViewWillAppeared) {
        return;
    } else {
        isViewWillAppeared = YES;
    }
    
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100.0) / 2.0,
                                             (self.view.frame.size.height - 100.0) / 2.0,
                                             100.0,
                                             100.0);
    activityIndicatorView.backgroundColor = [UIColor blackColor];
    activityIndicatorView.layer.cornerRadius = 10.0;
    activityIndicatorView.alpha = 0.7;
    [activityIndicatorView startAnimating];
    [self.view addSubview:activityIndicatorView];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        
        NSString* userID = [[NSUserDefaults standardUserDefaults] objectForKey:MEMBER_ID];
        
        NSLog(@"%@",userID);
        
        NSLog(@"%@",self.houseID);
        
        Result* result = [House requestOneWithHouseID:self.houseID userID:userID flag:0];
        
        if (result.isSuccess) {
            house = (House *)result.data;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showView];
                
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
    
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        
        [activityIndicatorView removeFromSuperview];
    });
}

//判断房子是否存在
- (void)memberCollectHouseIsExisted
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
        
            Member* member = [Member shareMember];
        
            if ([member isLogined]) {
            
            NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_USER_NAME];
            NSString* password = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_PASSWORD];
            
            Result* result = [ManagerMember getIsCollectHouseExsited:username loginPassword:password houseId:[self.houseID intValue]];
            
            
            if (result.isSuccess) {
                
                collectHouse = (House*)result.data;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (collectHouse.isCollectHouseExsited) {
                        
                        collectLabel.text = @"取消收藏";
                        
                    } else {
                        
                        
                        collectLabel.text = @"收藏房源";
                        
                    }
                    
                });
                
            }
            
        }
    });
 
}
- (void)showView
{
    
    
    if (self.house.houseMessageType == HouseMessageTypeRent) {
        self.title = @"租房详情";
    } else if (self.house.houseMessageType == HouseMessageTypeSell) {
        self.title = @"买房详情";
    }
    
    //创建scrollview
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0,
                                                                   0.0,
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height)];
    //            mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 700.0);
    mainScrollView.showsHorizontalScrollIndicator = YES;
    mainScrollView.delegate = self;
    mainScrollView.userInteractionEnabled = YES;
    //            mainScrollView.backgroundColor = [UIColor colorWithCGColor:
    //                                              UIColorFromRGB(252.0, 243.0, 234.0).CGColor];
    [self.view addSubview:mainScrollView];
    
    
    
    if ([house.houseImageArray count] > 0) {
        //创建pageController
        NSDictionary* dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                        forKey:UIPageViewControllerOptionSpineLocationKey];
        
        self.pageController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                             navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                           options:dic];
        self.pageController.dataSource = self;
        self.pageController.delegate = self;
        self.pageController.view.frame = CGRectMake(0.0,
                                                    0.0,
                                                    self.view.frame.size.width,
                                                    225.0);
        
        
        BinnerViewController* binnerView = [self viewControllerAtIndex:0];
        
        if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            
            binnerView.edgesForExtendedLayout = NO;
            
        }

        
        NSArray* viewcontrollers = [NSArray arrayWithObject:binnerView];
        [self.pageController setViewControllers:viewcontrollers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
        [self addChildViewController:self.pageController];
        [mainScrollView addSubview:self.pageController.view];
        
        
        UITapGestureRecognizer *tapGallery = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(tapGallery:)];
        tapGallery.numberOfTapsRequired = 1;
        tapGallery.numberOfTouchesRequired = 1;
        [self.pageController.view addGestureRecognizer:tapGallery];
        
        
        
        // Page control
        pageControl = [[UIPageControl alloc] init];
        pageControl.frame = CGRectMake(0.0,
                                       self.pageController.view.frame.size.height - 50.0,
                                       self.pageController.view.frame.size.width,
                                       50.0);
        
        if ([pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
            NSLog(@"TTTTTTTTTT");
            pageControl.pageIndicatorTintColor = UIColorFromRGB(149.0, 149.0, 149.0);
        }
        if ([pageControl respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)]) {
            pageControl.currentPageIndicatorTintColor = UIColorFromRGB(237.0, 120.0, 51.0);
        }
        pageControl.currentPage = 0;
        pageControl.numberOfPages = [house.houseImageArray count];
        pageControl.hidesForSinglePage = YES;
//        pageControl.userInteractionEnabled = NO;
        [self.pageController.view addSubview:pageControl];


    }
    
    
    
    
    UILabel* houseProjectLabel = [[UILabel alloc] init];
    if ([house.houseImageArray count] > 0) {
        houseProjectLabel.frame = CGRectMake(15.0,
                                             CGRectGetMaxY(self.pageController.view.frame) + 10.0,
                                             300.0,
                                             houseProjectLabel.frame.size.height);
    } else {
        houseProjectLabel.frame = CGRectMake(15.0,
                                             10.0,
                                             300.0,
                                             houseProjectLabel.frame.size.height);
    }
    houseProjectLabel.font = [UIFont systemFontOfSize:18.0];
    houseProjectLabel.textColor = UIColorFromRGB(40.0, 40.0, 40.0);
    houseProjectLabel.backgroundColor = [UIColor clearColor];
    houseProjectLabel.numberOfLines = 5;
    houseProjectLabel.text = house.title;
    [houseProjectLabel sizeToFit];
    [mainScrollView addSubview:houseProjectLabel];
    
    
    UILabel* timerLabel = [[UILabel alloc] init];
    timerLabel.frame = CGRectMake(15.0,
                                  CGRectGetMaxY(houseProjectLabel.frame),
                                  300.0,
                                  20.0);
    timerLabel.font = [UIFont systemFontOfSize:10.0];
    timerLabel.textColor = UIColorFromRGB(121.0, 123.0, 123.0);
    timerLabel.backgroundColor = [UIColor clearColor];
    timerLabel.text = [NSString stringWithFormat:@"发布时间:%@",@"2014.2.5"];
    [mainScrollView addSubview:timerLabel];
    
    UILabel* momeyLabel = [[UILabel alloc] init];
    momeyLabel.frame = CGRectMake(15.0,
                                  CGRectGetMaxY(timerLabel.frame),
                                  300.0,
                                  20.0);
    momeyLabel.font = [UIFont systemFontOfSize:15.0];
    momeyLabel.textColor = UIColorFromRGB(244.0, 127.0, 64.0);
    momeyLabel.backgroundColor = [UIColor clearColor];
    momeyLabel.text = house.price;
    [mainScrollView addSubview:momeyLabel];
    
    
    UIImage* lineImage = [UIImage imageNamed:@"detailLine.png"];
    UIImageView* lineImageView = [[UIImageView alloc] init];
    lineImageView.frame = CGRectMake((self.view.frame.size.width - lineImage.size.width) / 2.0,
                                     CGRectGetMaxY(momeyLabel.frame) + 10.0,
                                     lineImage.size.width,
                                     lineImage.size.height);
    lineImageView.image = lineImage;
    [mainScrollView addSubview:lineImageView];
    
    
    UILabel* identifyLabel = [[UILabel alloc] init];
    identifyLabel.frame = CGRectMake(15.0,
                                      CGRectGetMaxY(lineImageView.frame) + 10.0,
                                      identifyLabel.frame.size.width,
                                      identifyLabel.frame.size.height);
    identifyLabel.font = [UIFont systemFontOfSize:13.0];
    identifyLabel.textColor = UIColorFromRGB(66.0, 66.0, 66.0);
    identifyLabel.backgroundColor = [UIColor clearColor];
    identifyLabel.text = @"编号：";
    [identifyLabel sizeToFit];
    [mainScrollView addSubview:identifyLabel];
    
    UILabel* identifylText = [[UILabel alloc] init];
    identifylText.frame = CGRectMake(CGRectGetMaxX(identifyLabel.frame),
                                          identifyLabel.frame.origin.y,
                                          identifylText.frame.size.width,
                                          identifylText.frame.size.height);
    identifylText.font = [UIFont systemFontOfSize:13.0];
    identifylText.textColor = UIColorFromRGB(120.0, 119.0, 119.0);
    identifylText.backgroundColor = [UIColor clearColor];
    identifylText.text = house.houseIdentifier;
    [identifylText sizeToFit];
    [mainScrollView addSubview:identifylText];
    
    
    
    UILabel* houseNameLabel = [[UILabel alloc] init];
    houseNameLabel.frame = CGRectMake(164.0,
                                      CGRectGetMaxY(lineImageView.frame) + 10.0,
                                      houseNameLabel.frame.size.width,
                                      houseNameLabel.frame.size.height);
    houseNameLabel.font = [UIFont systemFontOfSize:13.0];
    houseNameLabel.textColor = UIColorFromRGB(66.0, 66.0, 66.0);
    houseNameLabel.backgroundColor = [UIColor clearColor];
    houseNameLabel.text = @"小区名称：";
    [houseNameLabel sizeToFit];
    [mainScrollView addSubview:houseNameLabel];
    
    
    UILabel* houseNameLabelText = [[UILabel alloc] init];
    houseNameLabelText.frame = CGRectMake(CGRectGetMaxX(houseNameLabel.frame),
                                          houseNameLabel.frame.origin.y,
                                          houseNameLabelText.frame.size.width,
                                          houseNameLabelText.frame.size.height);
    houseNameLabelText.font = [UIFont systemFontOfSize:13.0];
    houseNameLabelText.textColor = UIColorFromRGB(120.0, 119.0, 119.0);
    houseNameLabelText.backgroundColor = [UIColor clearColor];
    houseNameLabelText.text = house.projectTitle;
    [houseNameLabelText sizeToFit];
    [mainScrollView addSubview:houseNameLabelText];
    
    
    
    UILabel* apartmentLabel = [[UILabel alloc] init];
    apartmentLabel.frame = CGRectMake(15.0,
                                      CGRectGetMidY(houseNameLabel.frame) + 14.0,
                                      apartmentLabel.frame.size.width,
                                      apartmentLabel.frame.size.height);
    apartmentLabel.font = [UIFont systemFontOfSize:13.0];
    apartmentLabel.textColor = UIColorFromRGB(66.0, 66.0, 66.0);
    apartmentLabel.backgroundColor = [UIColor clearColor];
    apartmentLabel.text = @"户型：";
    [apartmentLabel sizeToFit];
    [mainScrollView addSubview:apartmentLabel];
    
    
    UILabel* apartmentSizeLabel = [[UILabel alloc] init];
    apartmentSizeLabel.frame = CGRectMake(CGRectGetMaxX(apartmentLabel.frame),
                                          apartmentLabel.frame.origin.y,
                                          apartmentSizeLabel.frame.size.width,
                                          apartmentSizeLabel.frame.size.height);
    apartmentSizeLabel.font = [UIFont systemFontOfSize:13.0];
    apartmentSizeLabel.textColor = UIColorFromRGB(120.0, 119.0, 119.0);
    apartmentSizeLabel.backgroundColor = [UIColor clearColor];
    apartmentSizeLabel.text = house.houseTypeTitle;
    [apartmentSizeLabel sizeToFit];
    [mainScrollView addSubview:apartmentSizeLabel];
    
    
    UILabel* buildLabel = [[UILabel alloc] init];
    buildLabel.frame = CGRectMake(164.0,
                                  CGRectGetMaxY(houseNameLabel.frame) + 6.0,
                                  buildLabel.frame.size.width,
                                  buildLabel.frame.size.height);
    buildLabel.font = [UIFont systemFontOfSize:13.0];
    buildLabel.textColor = UIColorFromRGB(66.0, 66.0, 66.0);
    buildLabel.backgroundColor = [UIColor clearColor];
    buildLabel.text = @"栋号：";
    [buildLabel sizeToFit];
    [mainScrollView addSubview:buildLabel];

    
    UILabel* buildNumberLabel = [[UILabel alloc] init];
    buildNumberLabel.frame = CGRectMake(CGRectGetMaxX(buildLabel.frame),
                                        buildLabel.frame.origin.y,
                                        buildNumberLabel.frame.size.width,
                                        buildNumberLabel.frame.size.height);
    buildNumberLabel.font = [UIFont systemFontOfSize:13.0];
    buildNumberLabel.textColor = UIColorFromRGB(120.0, 119.0, 119.0);
    buildNumberLabel.backgroundColor = [UIColor clearColor];
    buildNumberLabel.text = [NSString stringWithFormat:@"%@H",house.building];
    [buildNumberLabel sizeToFit];
    [mainScrollView addSubview:buildNumberLabel];

    
    
    UILabel* areaLabel = [[UILabel alloc] init];
    areaLabel.frame = CGRectMake(15.0,
                                 CGRectGetMaxY(apartmentLabel.frame) + 6.0,
                                 areaLabel.frame.size.width,
                                 areaLabel.frame.size.height);
    areaLabel.font = [UIFont systemFontOfSize:13.0];
    areaLabel.textColor = UIColorFromRGB(66.0, 66.0, 66.0);
    areaLabel.backgroundColor = [UIColor clearColor];
    areaLabel.text = @"面积：";
    [areaLabel sizeToFit];
    [mainScrollView addSubview:areaLabel];
    
    UILabel* areaSizeLabel = [[UILabel alloc] init];
    areaSizeLabel.frame = CGRectMake(CGRectGetMaxX(areaLabel.frame),
                                     areaLabel.frame.origin.y,
                                     areaSizeLabel.frame.size.width,
                                     areaSizeLabel.frame.size.height);
    areaSizeLabel.font = [UIFont systemFontOfSize:13.0];
    areaSizeLabel.textColor = UIColorFromRGB(120.0, 119.0, 119.0);
    areaSizeLabel.backgroundColor = [UIColor clearColor];
    areaSizeLabel.text = house.proportion;
    [areaSizeLabel sizeToFit];
    [mainScrollView addSubview:areaSizeLabel];

    
    UILabel* floorLabel = [[UILabel alloc] init];
    floorLabel.frame = CGRectMake(164.0,
                                  CGRectGetMaxY(buildLabel.frame) + 6.0,
                                  floorLabel.frame.size.width,
                                  floorLabel.frame.size.height);
    floorLabel.font = [UIFont systemFontOfSize:13.0];
    floorLabel.textColor = UIColorFromRGB(66.0, 66.0, 66.0);
    floorLabel.backgroundColor = [UIColor clearColor];
    floorLabel.text = @"楼层：";
    [floorLabel sizeToFit];
    [mainScrollView addSubview:floorLabel];

    
    UILabel* floorSizeLabel = [[UILabel alloc] init];
    floorSizeLabel.frame = CGRectMake(CGRectGetMaxX(floorLabel.frame),
                                      floorLabel.frame.origin.y,
                                      floorSizeLabel.frame.size.width,
                                      floorSizeLabel.frame.size.height);
    floorSizeLabel.font = [UIFont systemFontOfSize:13.0];
    floorSizeLabel.textColor = UIColorFromRGB(120.0, 119.0, 119.0);
    floorSizeLabel.backgroundColor = [UIColor clearColor];
    floorSizeLabel.text = house.level;
    [floorSizeLabel sizeToFit];
    [mainScrollView addSubview:floorSizeLabel];

    
    UILabel* fixLabel = [[UILabel alloc] init];
    fixLabel.frame = CGRectMake(15.0,
                                CGRectGetMaxY(areaLabel.frame) + 6.0,
                                fixLabel.frame.size.width,
                                fixLabel.frame.size.height);
    fixLabel.font = [UIFont systemFontOfSize:13.0];
    fixLabel.textColor = UIColorFromRGB(66.0, 66.0, 66.0);
    fixLabel.backgroundColor = [UIColor clearColor];
    fixLabel.text = @"装修年份：";
    [fixLabel sizeToFit];
    [mainScrollView addSubview:fixLabel];

    
    UILabel* fixYearLabel = [[UILabel alloc] init];
    fixYearLabel.frame = CGRectMake(CGRectGetMaxX(fixLabel.frame),
                                    fixLabel.frame.origin.y,
                                    fixYearLabel.frame.size.width,
                                    fixYearLabel.frame.size.height);
    fixYearLabel.font = [UIFont systemFontOfSize:13.0];
    fixYearLabel.textColor = UIColorFromRGB(120.0, 119.0, 119.0);
    fixYearLabel.backgroundColor = [UIColor clearColor];
    fixYearLabel.text = house.decorationYear;
    [fixYearLabel sizeToFit];
    [mainScrollView addSubview:fixYearLabel];

    
    
    UILabel* directionLabel = [[UILabel alloc] init];
    directionLabel.frame = CGRectMake(164.0,
                                      CGRectGetMaxY(floorLabel.frame) + 6.0,
                                      directionLabel.frame.size.width,
                                      directionLabel.frame.size.height);
    directionLabel.font = [UIFont systemFontOfSize:13.0];
    directionLabel.textColor = UIColorFromRGB(66.0, 66.0, 66.0);
    directionLabel.backgroundColor = [UIColor clearColor];
    directionLabel.text = @"房屋朝向：";
    [directionLabel sizeToFit];
    [mainScrollView addSubview:directionLabel];

    
    UILabel* directionTextLabel = [[UILabel alloc] init];
    directionTextLabel.frame = CGRectMake(CGRectGetMaxX(directionLabel.frame),
                                          directionLabel.frame.origin.y,
                                          directionTextLabel.frame.size.width,
                                          directionTextLabel.frame.size.height);
    directionTextLabel.font = [UIFont systemFontOfSize:13.0];
    directionTextLabel.textColor = UIColorFromRGB(120.0, 119.0, 119.0);
    directionTextLabel.backgroundColor = [UIColor clearColor];
    directionTextLabel.text = house.forward;
    [directionTextLabel sizeToFit];
    [mainScrollView addSubview:directionTextLabel];

    
    
    UILabel* sellLabel = [[UILabel alloc] init];
    sellLabel.frame = CGRectMake(15.0,
                                 CGRectGetMaxY(fixLabel.frame) + 6.0,
                                 sellLabel.frame.size.width,
                                 sellLabel.frame.size.height);
    sellLabel.font = [UIFont systemFontOfSize:13.0];
    sellLabel.textColor = UIColorFromRGB(66.0, 66.0, 66.0);
    sellLabel.backgroundColor = [UIColor clearColor];
    sellLabel.text = @"出租年限：";
    [sellLabel sizeToFit];
    [mainScrollView addSubview:sellLabel];

    
    UILabel* sellYearLabel = [[UILabel alloc] init];
    sellYearLabel.frame = CGRectMake(CGRectGetMaxX(sellLabel.frame),
                                     sellLabel.frame.origin.y,
                                     sellYearLabel.frame.size.width,
                                     sellYearLabel.frame.size.height);
    sellYearLabel.font = [UIFont systemFontOfSize:13.0];
    sellYearLabel.textColor = UIColorFromRGB(120.0, 119.0, 119.0);
    sellYearLabel.backgroundColor = [UIColor clearColor];
    NSString* rentYearText = [[NSUserDefaults standardUserDefaults]objectForKey:RENT_YEAR_TEXT];
    if ([rentYearText length]> 0) {
        
        sellYearLabel.text = rentYearText;
     }
    sellYearLabel.text = rentYearText;

    [sellYearLabel sizeToFit];
    [mainScrollView addSubview:sellYearLabel];

    
    UILabel* situationLabel = [[UILabel alloc] init];
    situationLabel.frame = CGRectMake(164.0,
                                      CGRectGetMaxY(directionLabel.frame) + 6.0,
                                      situationLabel.frame.size.width,
                                      situationLabel.frame.size.height);
    situationLabel.font = [UIFont systemFontOfSize:13.0];
    situationLabel.textColor = UIColorFromRGB(66.0, 66.0, 66.0);
    situationLabel.backgroundColor = [UIColor clearColor];
    situationLabel.text = @"装修情况：";
    [situationLabel sizeToFit];
    [mainScrollView addSubview:situationLabel];

    
    
    UILabel* situationTextLabel = [[UILabel alloc] init];
    situationTextLabel.frame = CGRectMake(CGRectGetMaxX(situationLabel.frame),
                                          situationLabel.frame.origin.y,
                                          situationTextLabel.frame.size.width,
                                          situationTextLabel.frame.size.height);
    situationTextLabel.font = [UIFont systemFontOfSize:13.0];
    situationTextLabel.textColor = UIColorFromRGB(120.0, 119.0, 119.0);
    situationTextLabel.backgroundColor = [UIColor clearColor];
    situationTextLabel.text = house.decoration;
    [situationTextLabel sizeToFit];
    [mainScrollView addSubview:situationTextLabel];


    
    UIImageView* lineImageView2 = [[UIImageView alloc] init];
    lineImageView2.frame = CGRectMake((self.view.frame.size.width - lineImage.size.width) / 2.0,
                                      CGRectGetMaxY(sellLabel.frame) + 10.0,
                                      lineImage.size.width,
                                      lineImage.size.height);
    lineImageView2.image = lineImage;
    [mainScrollView addSubview:lineImageView2];

    
    
    UILabel* matingLabel = [[UILabel alloc] init];
    matingLabel.frame = CGRectMake(15.0,
                                   CGRectGetMaxY(lineImageView2.frame) + 10.0,
                                   100.0,
                                   20.0);
    matingLabel.font = [UIFont systemFontOfSize:13.0];
    matingLabel.textColor = UIColorFromRGB(66.0, 66.0, 66.0);
    matingLabel.backgroundColor = [UIColor clearColor];
    matingLabel.text = @"配套家具：";
    [mainScrollView addSubview:matingLabel];
    
    
    UILabel* firstLabel = [[UILabel alloc]init];
    firstLabel.frame = CGRectMake(15.0,
                                  CGRectGetMaxY(matingLabel.frame) + 6.0,
                                  firstLabel.frame.size.width,
                                  firstLabel.frame.size.height);
    firstLabel.font = [UIFont systemFontOfSize:13.0];
    firstLabel.textColor = UIColorFromRGB(120.0, 119.0, 119.0);
    firstLabel.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *facilityArray = [[NSMutableArray alloc] init];
    for (Facility *facility in house.facilityArray) {
        [facilityArray addObject:facility.title];
    }
    firstLabel.text = [facilityArray componentsJoinedByString:@"    "];
    [firstLabel sizeToFit];
    [mainScrollView addSubview:firstLabel];
    
    

    
    
    UIImageView* lineImageView3 = [[UIImageView alloc] init];
    lineImageView3.frame = CGRectMake((self.view.frame.size.width - lineImage.size.width) / 2.0,
                                      CGRectGetMaxY(firstLabel.frame) + 10.0,
                                      lineImage.size.width,
                                      lineImage.size.height);
    lineImageView3.image = lineImage;
    [mainScrollView addSubview:lineImageView3];
    
    
    
    UILabel* infoLabel = [[UILabel alloc] init];
    infoLabel.frame = CGRectMake(15.0,
                                 CGRectGetMaxY(lineImageView3.frame) + 10.0,
                                 infoLabel.frame.size.width,
                                 infoLabel.frame.size.height);
    infoLabel.font = [UIFont systemFontOfSize:13.0];
    infoLabel.textColor = UIColorFromRGB(66.0, 66.0, 66.0);
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.text = [NSString stringWithFormat:@"信息来源：%@", house.ownerPhone];
    [infoLabel sizeToFit];
    infoLabel.hidden = !house.canViewPhone;
    [mainScrollView addSubview:infoLabel];
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width,
                                            CGRectGetMaxY(infoLabel.frame) + 100.0);
    
    

    
    UIImage* saveImage = [UIImage imageNamed:@"collectHouseImage.png"];
    UIButton* collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.frame = CGRectMake((self.view.frame.size.width - saveImage.size.width)/2.0,
                                     CGRectGetMaxY(infoLabel.frame) + 25.0,
                                     saveImage.size.width ,
                                     saveImage.size.height);
    [collectButton setBackgroundImage:saveImage forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(collectMethod:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:collectButton];
    
    
    collectLabel = [[UILabel alloc] init];
    collectLabel.frame = CGRectMake(125.0,
                                          8.0,
                                        100.0,
                                          30.0);
    collectLabel.font = [UIFont systemFontOfSize:17.0];
    collectLabel.textColor = [UIColor redColor];
    collectLabel.textColor = UIColorFromRGB(120.0, 119.0, 119.0);
    collectLabel.backgroundColor = [UIColor clearColor];
    if ([[Member shareMember]isLogined]==NO) {
         collectLabel.text = @"收藏房源";
     }
    [collectButton addSubview:collectLabel];
    
    
    
    
    UIImage*  callImage = [UIImage imageNamed:@"makecall.png"];
    UIButton* callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    callButton.frame = CGRectMake((self.view.frame.size.width - callImage.size.width)/2.0,
                                  CGRectGetMaxY(collectButton.frame) + 8.0,
                                  callImage.size.width ,
                                  callImage.size.height);
    [callButton setBackgroundImage:callImage forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(callMethod:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:callButton];
    
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width,
                                            CGRectGetMaxY(callButton.frame) + 15.0);
    
    
    [self memberCollectHouseIsExisted];
    
    
    
}

#pragma mark UIPageViewControllerDataSource Method
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    BinnerViewController* binnerVC =(BinnerViewController*) viewController;
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        binnerVC.edgesForExtendedLayout = NO;
        
    }
    NSUInteger index = [self indexOfViewController:binnerVC];
    
    if (index == NSNotFound) {
        
        return nil;
    }
    
    index--;
    
    if (index == -1) {
        
        index = [house.houseImageArray count] - 1;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    BinnerViewController *moreVC = (BinnerViewController *)viewController;
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        moreVC.edgesForExtendedLayout = NO;
        
    }
    NSInteger index = [house.houseImageArray indexOfObject:moreVC.dataObject];
    
    
    
    if (index == NSNotFound) {
        
        return nil;
    }
    
    index++;
    
    if (index == [house.houseImageArray count]) {
        
        index = 0;
    }
    
    return [self viewControllerAtIndex:index];
    
    
}

- (BinnerViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([house.houseImageArray count] == 0) || (index >= [house.houseImageArray count])) {
        return nil;
    }
    
    // 创建一个新的控制器类，并且分配给相应的数据
    HouseImage *houseImage = [house.houseImageArray objectAtIndex:index];
    BinnerViewController *dataViewController = [[BinnerViewController alloc] initWithDataObject:houseImage currentIndex:index count:[house.houseImageArray count]];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        dataViewController.edgesForExtendedLayout = NO;
    }

//    dataViewController.dataObject = houseImage;
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(BinnerViewController *)viewController
{
    return [house.houseImageArray indexOfObject:viewController.dataObject];
}

- (void)callMethod:(UIButton*)callButton
{
    
    blackView = [[UIView alloc]init];
    blackView.frame = CGRectMake(0.0,
                                 0.0,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height);
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.3;
    [self.view addSubview:blackView];
    
    
    whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 3.0;
    whiteView.frame = CGRectMake((self.view.frame.size.width - 270.0)/2.0,
                                 220.0,
                                 270.0,
                                 125.0);
    [self.view addSubview:whiteView];
    
    
    UILabel* calllabel = [[UILabel alloc]init];
    calllabel.font = [UIFont systemFontOfSize:16.0];
    calllabel.textColor = UIColorFromRGB(244.0,127.0,64.0);
    calllabel.frame = CGRectMake(55.0,
                                 20.0,
                                 190.0,
                                 30.0);
    calllabel.text = @"您确定要拨打电话吗 ?";
    [whiteView addSubview:calllabel];
    
    
    UIImage* sureCallImage = [UIImage imageNamed:@"suremakecall.png"];
    UIImage* cancelcallImage = [UIImage imageNamed:@"cancelmakecall.png"];
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake((whiteView.frame.size.width - cancelcallImage.size.width - sureCallImage.size.width)/3.0,
                                    60.0,
                                    cancelcallImage.size.width ,
                                    cancelcallImage.size.height);
    [cancelButton setBackgroundImage:cancelcallImage forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelMethod:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:cancelButton];
    
    
    UIButton* sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake((whiteView.frame.size.width - cancelcallImage.size.width - sureCallImage.size.width)/3.0*2+cancelcallImage.size.width,
                                  60.0,
                                  sureCallImage.size.width ,
                                  sureCallImage.size.height);
    [sureButton setBackgroundImage:sureCallImage forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureMethod:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:sureButton];
    
    
}

-(void)backButtonMethod
{
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

-(void)cancelMethod:(UIButton*)cancelButton
{
    
    [blackView removeFromSuperview];
    [whiteView removeFromSuperview];
    
}

//打电话
-(void)sureMethod:(UIButton*)sureButton
{
   
    
    NSLog(@"house.contact =  %@",house.ownerPhone);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"tel:%@", house.ownerPhone]]];

    [blackView removeFromSuperview];
    [whiteView removeFromSuperview];
    
    
    //添加联系记录。
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(queue, ^{
     
    NSString* userId = [[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_ID];
 
        
        Result* result = [ManagerMember addContactList:[userId intValue] infomationId:[self.houseID intValue]];
        
        
        if (result.isSuccess) {
            
            
         dispatch_async(dispatch_get_main_queue(), ^{
             
            
             NSLog(@"添加联系记录成功");
             
        });
            
     }
        
  });
    

}

-(void)collectMethod:(UIButton*)collectButton
{
    Member* member = [Member shareMember];
    
    if (![member isLogined]) {
        
        //login
        MemberLoginViewController* loginVC = [[MemberLoginViewController alloc]init];
        UINavigationController* na = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:na animated:YES completion:nil];
        
        return;
        
    }
    
    dispatch_queue_t queue  =  dispatch_queue_create("collectHouseQueue", NULL);
    
     dispatch_group_t group =  dispatch_group_create();
    
      dispatch_group_async(group, queue, ^{
        
        NSNumber* userId = [[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_ID];
          
          
          NSLog(@"collectHouse.isCollectHouseExsited =  %d",collectHouse.isCollectHouseExsited);
          
          
          
        if (collectHouse.isCollectHouseExsited==NO) {
      
        //收藏房源
        Result* result = [ManagerMember collectHouse:[userId intValue]  houseId:[self.houseID intValue]];
    
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (result.isSuccess) {
                    
                    
                    collectBlackView = [[UIView alloc]init];
                    collectBlackView.frame = CGRectMake(0.0,
                                                        0.0,
                                                        self.view.frame.size.width,
                                                        self.view.frame.size.height);
                    collectBlackView.backgroundColor = [UIColor blackColor];
                    collectBlackView.alpha = 0.3;
                    [self.view addSubview:collectBlackView];
                    
                    collectWhiteView = [[UIView alloc]init];
                    collectWhiteView.backgroundColor = [UIColor whiteColor];
                    collectWhiteView.layer.cornerRadius = 5.0;
                    collectWhiteView.frame = CGRectMake((self.view.frame.size.width - 250.0)/2.0,
                                                        315.0,
                                                        250.0,
                                                        57.0);
                    [self.view addSubview:collectWhiteView];
                    
                    
                    UILabel* calllabel = [[UILabel alloc]init];
                    calllabel.font = [UIFont systemFontOfSize:16.0];
                    calllabel.textColor = UIColorFromRGB(244.0, 127.0, 64.0);
                    calllabel.frame = CGRectMake(60.0,
                                                 12.0,
                                                 190.0,
                                                 30.0);
                    calllabel.text = @"房源信息已收藏 !";
                    [collectWhiteView addSubview:calllabel];
                    
                    [self performSelector:@selector(cancelCollectHouse) withObject:nil afterDelay:2];
                    
                    
                    collectLabel.text = @"取消收藏";
                    
                    [self memberCollectHouseIsExisted];
                    
                    
                }
                
            });
            
        } else {
            
        
       NSString* userId = [[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_ID];
            

        //取消收藏房源
        Result* result = [ManagerMember cancelCollectHouse:userId houseId:[self.houseID intValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
            if (result.isSuccess) {
                    
            collectBlackView = [[UIView alloc]init];
            collectBlackView.frame = CGRectMake(0.0,
                                                0.0,
                                                self.view.frame.size.width,
                                                self.view.frame.size.height);
            collectBlackView.backgroundColor = [UIColor blackColor];
            collectBlackView.alpha = 0.3;
            [self.view addSubview:collectBlackView];
            
            collectWhiteView = [[UIView alloc]init];
            collectWhiteView.backgroundColor = [UIColor whiteColor];
            collectWhiteView.layer.cornerRadius = 5.0;
            collectWhiteView.frame = CGRectMake((self.view.frame.size.width - 250.0)/2.0,
                                                315.0,
                                                250.0,
                                                57.0);
            [self.view addSubview:collectWhiteView];
            
            
            UILabel* calllabel = [[UILabel alloc]init];
            calllabel.font = [UIFont systemFontOfSize:16.0];
            calllabel.textColor = UIColorFromRGB(244.0, 127.0, 64.0);
            calllabel.frame = CGRectMake(60.0,
                                         12.0,
                                         190.0,
                                         30.0);
            calllabel.text = @"房源信息已取消 !";
            [collectWhiteView addSubview:calllabel];
            
            [self performSelector:@selector(cancelCollectHouse) withObject:nil afterDelay:2];
            
            
        
            collectLabel.text = @"收藏房源";
                
            [self memberCollectHouseIsExisted];

                }
        });
            
        
      }
  });
    
}

- (void)cancelCollectHouse{
    
    
    [collectBlackView removeFromSuperview];
    [collectWhiteView removeFromSuperview];
    
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        BinnerViewController *currentVC = (BinnerViewController *)[pageViewController.viewControllers lastObject];
        pageControl.currentPage = [currentVC currentSelectedIndex];
    }
}

- (void)tapGallery:(UITapGestureRecognizer *)tapGestureRecognizer
{
    NSLog(@"tapGallery %@", tapGestureRecognizer);
    
    RentGalleryViewController *rentGalleryVC = [[RentGalleryViewController alloc] initWithHouseImageArray:house.houseImageArray currentSelectedIndex:pageControl.currentPage];
    [self.navigationController pushViewController:rentGalleryVC animated:YES];
}


@end
