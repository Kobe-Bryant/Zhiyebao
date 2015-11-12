//
//  RentImageViewController.m
//  Zhiyebao
//
//  Created by LaiZhaowu on 14-5-29.
//
//

#import "RentImageViewController.h"
#import "DACircularProgressView.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Macros.h"
#import "CustomMarcos.h"


@interface RentImageViewController ()

@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic) NSUInteger currentSelectedIndex;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) TapDetectingImageView *imageView;
@property (nonatomic) BOOL isViewWillAppeared;

@end

@implementation RentImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithImageURLString:(NSString *)imageURLString currentSelectedIndex:(NSUInteger)currentSelectedIndex
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.imageURLString = imageURLString;
        self.currentSelectedIndex = currentSelectedIndex;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (self.isViewWillAppeared) {
        return;
    } else {
        self.isViewWillAppeared = YES;
    }
    
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.scrollsToTop = YES;
    self.scrollView.delegate = self;
    self.scrollView.bouncesZoom = YES;
    self.scrollView.frame = CGRectMake(0.0,
                                       0.0,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height);
//    self.scrollView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.scrollView];
    
    
    
    // Image
    self.imageView = [[TapDetectingImageView alloc] init];
    self.imageView.delegate = self;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.frame = self.scrollView.frame;
    [self.scrollView addSubview:self.imageView];
    
    
    self.scrollView.contentSize = self.imageView.frame.size;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 1.0;
    //    self.scrollView.backgroundColor = [UIColor greenColor];
    
    
    DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
    dispatch_async(dispatch_get_main_queue(), ^{
        progressView.trackTintColor = UIColorFromRGB(105.0, 105.0, 105.0);
        progressView.progressTintColor = UIColorFromRGB(237.0, 120.0, 51.0);
        progressView.center = self.view.center;
        progressView.progress = 0.0;
        if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.imageURLString] != nil) {
            progressView.hidden = YES;
        }
        [self.view addSubview:progressView];
    });
    
    
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:self.imageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [progressView setProgress:((CGFloat)receivedSize / (CGFloat)expectedSize) animated:YES];
        });
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [progressView setProgress:1.0 animated:YES];
                [progressView removeFromSuperview];
            });
            if (!error) {
                NSLog(@"self.view.frame %@", NSStringFromCGRect(self.view.frame));
                
                NSLog(@"image.size %@", NSStringFromCGSize(image.size));
                
                self.imageView.image = image;
                CGSize minImageSize = [self minImageSize:image.size frameSize:self.view.frame.size];
                CGSize maxImageSize = [self maxImageSize:image.size frameSize:self.view.frame.size];
                NSLog(@"minImageSize %@", NSStringFromCGSize(minImageSize));
                NSLog(@"maxImageSize %@", NSStringFromCGSize(maxImageSize));

                self.imageView.frame = CGRectMake(0.0,
                                                  0.0,
                                                  minImageSize.width,
                                                  minImageSize.height);
                
                NSLog(@"self.view.bounds.size %@", NSStringFromCGSize(self.view.bounds.size));
                
                self.scrollView.frame = CGRectMake((self.view.frame.size.width - self.imageView.frame.size.width) / 2.0,
                                                   (self.view.frame.size.height - self.imageView.frame.size.height) / 2.0,
                                                   self.imageView.frame.size.width,
                                                   self.imageView.frame.size.height);
                self.scrollView.contentSize = maxImageSize;
                NSLog(@"self.scrollView.frame %@", NSStringFromCGRect(self.scrollView.frame));
                self.scrollView.minimumZoomScale = 1.0;
                if (minImageSize.height > maxImageSize.height) {
                    self.scrollView.maximumZoomScale = minImageSize.height / maxImageSize.height;
                } else {
                    self.scrollView.maximumZoomScale = maxImageSize.height / minImageSize.height;
                }
                
                self.scrollView.contentSize = self.imageView.frame.size;
//                self.scrollView.contentOffset = CGPointZero;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGSize)minImageSize:(CGSize)currentImageSize frameSize:(CGSize)frameSize
{
    CGSize newSize = CGSizeZero;
    newSize.width = currentImageSize.width * frameSize.height / currentImageSize.height;
    if (newSize.width >= frameSize.width) {
        newSize.width = frameSize.width;
        newSize.height = currentImageSize.height * frameSize.width / currentImageSize.width;
    } else {
        newSize.height = frameSize.height;
    }
    return newSize;
}


- (CGSize)maxImageSize:(CGSize)currentImageSize frameSize:(CGSize)frameSize
{
    CGSize newSize = CGSizeZero;
    newSize.width = (currentImageSize.width * frameSize.height / currentImageSize.height) * 2.0;
    newSize.height = frameSize.height * 2.0;
    return newSize;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
    
    if (scrollView.contentSize.width > 0.0 && scrollView.contentSize.height > 0.0) {
        CGRect rect;
        
        CGSize imageSize = [self minImageSize:self.imageView.frame.size frameSize:self.view.frame.size];
        if (scrollView.contentSize.width >= self.view.frame.size.width) {
            rect.origin.x = 0.0;
        } else if (scrollView.contentSize.width < self.view.frame.size.width
                   && scrollView.contentSize.width >= imageSize.width) {
            rect.origin.x = (self.view.frame.size.width - scrollView.contentSize.width) / 2.0;
        } else {
            rect.origin.x = (self.view.frame.size.width - imageSize.width) / 2.0;
        }
        
        if (scrollView.contentSize.height >= self.view.frame.size.height) {
            rect.origin.y = 0.0;
        } else if (scrollView.contentSize.height < self.view.frame.size.height
                   && scrollView.contentSize.height >= imageSize.height) {
            rect.origin.y = (self.view.frame.size.height - scrollView.contentSize.height) / 2.0;
        } else {
            rect.origin.y = (self.view.frame.size.height - imageSize.height) / 2.0;
        }
        
        if (scrollView.contentSize.width >= self.view.frame.size.width) {
            rect.size.width = self.view.frame.size.width;
        } else if (scrollView.contentSize.width < self.view.frame.size.width
                   && scrollView.contentSize.width > imageSize.width) {
            rect.size.width = scrollView.contentSize.width;
        } else {
            rect.size.width = imageSize.width;
        }
        
        if (scrollView.contentSize.height >= self.view.frame.size.height) {
            rect.size.height = self.view.frame.size.height;
        } else if (scrollView.contentSize.height < self.view.frame.size.height
                   && scrollView.contentSize.height > imageSize.height) {
            rect.size.height = scrollView.contentSize.height;
        } else {
            rect.size.height = imageSize.height;
        }
        
        self.scrollView.frame = rect;
//        self.scrollView.contentSize = rect.size;
        NSLog(@"self.scrollView.frame %@", NSStringFromCGRect(self.scrollView.frame));
        if (self.scrollView.contentSize.width == self.scrollView.frame.size.width) {
            [self.delegate didZoomAnimate:YES];
        } else {
            [self.delegate didZoomAnimate:NO];
        }
    }
}


#pragma mark -
#pragma mark TapDetectingImageViewDelegate methods
- (void)tapDetectingImageView:(TapDetectingImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint
{
    
  //发送隐藏NavigationBar的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:HIDDEN_NAVIGATION_BAR object:nil];
     NSLog(@"gotSingleTapAtPoint");
    
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint
{
    // double tap zooms in
    NSLog(@"tapDetectingImageView");
    NSLog(@"self.scrollView.zoomScale %f", self.scrollView.zoomScale);
    NSLog(@"maximumZoomScale %f", self.scrollView.maximumZoomScale);
    
    if (self.scrollView.zoomScale != self.scrollView.maximumZoomScale)
    {
        CGRect zoomRect = [self zoomRectForScale:self.scrollView.maximumZoomScale withCenter:tapPoint];
        [self.scrollView zoomToRect:zoomRect animated:YES];
        [self.delegate didZoomAnimate:NO];
    }
    else
    {
        CGRect zoomRect = [self zoomRectForScale:self.scrollView.minimumZoomScale withCenter:tapPoint];
        [self.scrollView zoomToRect:zoomRect animated:YES];
        [self.delegate didZoomAnimate:YES];
    }
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint
{
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark -
#pragma mark Utility methods
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    
    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the
    // imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible,
    // the size of the rect grows.
    zoomRect.size.height = self.scrollView.frame.size.height / scale;
    zoomRect.size.width  = self.scrollView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

@end
