//
//  PublishViewController.m
//  Zhiyebao
//
//  Created by Apple on 14-5-6.
//
//

#import "PublishViewController.h"
#import "Macros.h"
#import "PostViewController.h"
#import "PublishSellViewController.h"

@interface PublishViewController ()
{
  
    UILabel* rentLabel;
    UILabel* sellLabel;
    UIScrollView* bottomScrollView;
    UIButton* rentButton;
    UIButton* sellButton;
    
    UIImageView* selectedImageView;
//    UIImage* selectedImage;
//    UIImage* unselectedImage;
    UIView* bottomLeftView;
    UIView* bottomRightView;
    UIImageView* runImageView;
    
//    UIButton *rentButton;
//    UIButton *sellButton;
    BOOL isViewWillAppeared;
    NSUInteger selectedTag;
}
@end

@implementation PublishViewController

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
    
    NSLog(@"PublishViewController viewDidLoad");

    
    self.title = @"刊登";

    self.view.backgroundColor = UIColorFromRGB(246.0, 239.0, 229.0);

    
    
    UIImage* closeButtonImage = [UIImage imageNamed:@"CloseIcon"];
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0.0,
                                   0.0,
                                   closeButtonImage.size.width,
                                   closeButtonImage.size.height);
    [rightButton setImage:closeButtonImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"刊登出租", @"刊登出售"]];
    segmentedControl.tintColor = [UIColor whiteColor];
    [segmentedControl setWidth:90.0 forSegmentAtIndex:0];
    [segmentedControl setWidth:90.0 forSegmentAtIndex:1];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl addTarget:self
                         action:@selector(segmentedControlChanged:)
               forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"PublishViewController viewWillAppear");

    if (isViewWillAppeared) {
        if (bottomScrollView != nil) {
            if (selectedTag == 0) {
                bottomScrollView.contentOffset = CGPointMake(0.0, 0.0);
            } else if (selectedTag == 1) {
                bottomScrollView.contentOffset = CGPointMake(bottomScrollView.frame.size.width, 0.0);
            }
        }
        
        
        return;
    } else {
        isViewWillAppeared = YES;
    }
 
    NSLog(@"isViewWillAppeared");
    
    bottomScrollView = [[UIScrollView alloc] init];
    bottomScrollView.frame = CGRectMake(0.0,
                                        0.0,
                                        self.view.frame.size.width,
                                        self.view.frame.size.height);
//    bottomScrollView.contentSize = CGSizeMake(320*2, 1100.0);
    bottomScrollView.pagingEnabled = YES;
    bottomScrollView.scrollEnabled = NO;
    bottomScrollView.showsHorizontalScrollIndicator = NO;
    bottomScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bottomScrollView];
    

    
    
    PostViewController* postRentVC =[[PostViewController alloc] init];
    postRentVC.view.frame = CGRectMake(0.0,
                                       0.0,
                                       bottomScrollView.frame.size.width,
                                       bottomScrollView.frame.size.height);
    [self addChildViewController:postRentVC];
    [bottomScrollView addSubview:postRentVC.view];



    PublishSellViewController* postSellVC = [[PublishSellViewController alloc] init];
    postSellVC.view.frame = CGRectMake(bottomScrollView.frame.size.width,
                                       0.0,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height);
    [self addChildViewController:postSellVC];
    [bottomScrollView addSubview:postSellVC.view];
}

- (void)segmentedControlChanged:(UISegmentedControl *)segmentedControl
{
    NSLog(@"segmentedControlChanged %@", segmentedControl);
    NSLog(@"selectedSegmentIndex %i", segmentedControl.selectedSegmentIndex);
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        selectedTag = 0;
        
        [UIView animateWithDuration:0.25 animations:^{
            bottomScrollView.contentOffset = CGPointMake(0.0, 0.0);
        }];
    } else {
        selectedTag = 1;
        
        [UIView animateWithDuration:0.25 animations:^{
            bottomScrollView.contentOffset = CGPointMake(bottomScrollView.frame.size.width, 0.0);
        }];
    }
}

- (void)closeButtonPressed:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
