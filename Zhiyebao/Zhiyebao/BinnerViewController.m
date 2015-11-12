//
//  BinnerViewController.m
//  domcom.Goclay
//
//  Created by 马峰 on 14-3-12.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "BinnerViewController.h"
#import "HouseImage.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DACircularProgressView.h"

@interface BinnerViewController ()

@property (nonatomic, retain) HouseImage *houseImage;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) NSUInteger count;
@property (nonatomic) BOOL isViewWillAppeared;

@end

@implementation BinnerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithDataObject:(id)dataObject currentIndex:(NSUInteger)currentIndex count:(NSUInteger)count
{
    self = [super init];
    if (self) {
        self.houseImage = dataObject;
        _dataObject = dataObject;
        self.currentIndex = currentIndex;
        self.count = count;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isViewWillAppeared) {
        return;
    } else {
        self.isViewWillAppeared = YES;
    }
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bannerBackImage.png"]];
    
    self.imageView = [[UIImageView alloc]init];
    //    self.imageView.image = [UIImage imageNamed:self.dataObject];
    self.imageView.frame = CGRectMake(10.0,
                                      10.0,
                                      self.view.frame.size.width - 2 * 10.0,
                                      205.0);
    self.imageView.backgroundColor = [UIColor lightGrayColor];
    self.imageView.layer.cornerRadius = 4.0;
    self.imageView.clipsToBounds = YES;
    [self.view addSubview:self.imageView];
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        DACircularProgressView *progressView = [[DACircularProgressView alloc] init];
        progressView.frame = CGRectMake((self.imageView.frame.size.width - 20.0) / 2.0,
                                        (self.imageView.frame.size.height - 20.0) / 2.0,
                                        20.0,
                                        20.0);
        progressView.progress = 0.0;
        [self.imageView addSubview:progressView];

//    });
    
    
    if (self.houseImage.thumbImageURLString) {
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:self.houseImage.thumbImageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (finished) {
                [progressView setProgress:1.0 animated:YES];
                [progressView removeFromSuperview];
            }
            if (finished && !error) {
                self.imageView.image = image;
            }
        }];
    }

    
    
//    NSLog(@"show count");
    //透明的view
//    UIImage* image = [UIImage imageNamed:@"blackViewImage.png"];
//    UIView* blackView = [[UIView alloc] init];
//    blackView.frame = CGRectMake((self.view.frame.size.width - image.size.width) / 2.0,
//                                 185.0,
//                                 image.size.width,
//                                 image.size.height);
//    blackView.backgroundColor = [UIColor colorWithPatternImage:image];
//    [self.view addSubview:blackView];
//    
//    
//    UILabel *countLabel = [[UILabel alloc] init];
//    countLabel.frame = CGRectMake(0.0,
//                                  0.0,
//                                  blackView.frame.size.width,
//                                  blackView.frame.size.height);
////    countLabel.center = blackView.center;
//    countLabel.font = [UIFont systemFontOfSize:12];
//    countLabel.textColor = [UIColor whiteColor];
//    countLabel.backgroundColor = [UIColor clearColor];
//    countLabel.alpha = 1;
////    countLabel.backgroundColor = [UIColor greenColor];
//    countLabel.textAlignment = NSTextAlignmentCenter;
//    countLabel.text = [[NSString alloc] initWithFormat:@"%i / %i", (self.currentIndex + 1), self.count];
//    [blackView addSubview:countLabel];

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    NSDictionary *dict = @{@"dataObject": self.dataObject};
    //    [[NSNotificationCenter defaultCenter] postNotificationName:
    //                                            @"ChangeBannerIndex" object:dict];
    
}

- (NSUInteger)currentSelectedIndex
{
    return self.currentIndex;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
