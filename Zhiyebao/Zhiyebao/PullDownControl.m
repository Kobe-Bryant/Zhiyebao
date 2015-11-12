//
//  PullDownControl.m
//  Zhiyebao
//
//  Created by LaiZhaowu on 14-5-25.
//
//

#import "PullDownControl.h"
#import "Macros.h"

@interface PullDownControl()

@property (nonatomic) PullDownControlStatus status;
@property (nonatomic, retain) UIImageView *pullDownImageView;
@property (nonatomic, retain) UILabel *pullDownTipsLabel;
@property (nonatomic, retain) UILabel *releaseTipsLabel;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) UILabel *refreshTipsLabel;

@end

@implementation PullDownControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        self.pullDownImageView = [[UIImageView alloc] init];
        self.pullDownImageView.image = [UIImage imageNamed:@"refreshupImage"];
        [self addSubview:self.pullDownImageView];
        
        self.pullDownTipsLabel = [[UILabel alloc] init];
        self.pullDownTipsLabel.textColor = UIColorFromRGB(153.0, 153.0, 153.0);
        self.pullDownTipsLabel.font = [UIFont systemFontOfSize:10.0];
        self.pullDownTipsLabel.backgroundColor = [UIColor clearColor];
        self.pullDownTipsLabel.textAlignment = NSTextAlignmentLeft;
        self.pullDownTipsLabel.text = @"下拉刷新";
        [self.pullDownTipsLabel sizeToFit];
        [self addSubview:self.pullDownTipsLabel];
        
        self.releaseTipsLabel = [[UILabel alloc] init];
        self.releaseTipsLabel.textColor = UIColorFromRGB(153.0, 153.0, 153.0);
        self.releaseTipsLabel.font = [UIFont systemFontOfSize:10.0];
        self.releaseTipsLabel.backgroundColor = [UIColor clearColor];
        self.releaseTipsLabel.textAlignment = NSTextAlignmentLeft;
        self.releaseTipsLabel.text = @"释放更新...";
        [self.releaseTipsLabel sizeToFit];
        self.releaseTipsLabel.hidden = YES;
        [self addSubview:self.releaseTipsLabel];
        
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        self.activityIndicatorView.color = UIColorFromRGB(233.0, 116.0, 44.0);
        self.activityIndicatorView.hidden = YES;
        [self addSubview:self.activityIndicatorView];
        
        self.refreshTipsLabel = [[UILabel alloc] init];
        self.refreshTipsLabel.textColor = UIColorFromRGB(153.0, 153.0, 153.0);
        self.refreshTipsLabel.font = [UIFont systemFontOfSize:10.0];
        self.refreshTipsLabel.backgroundColor = [UIColor clearColor];
        self.refreshTipsLabel.textAlignment = NSTextAlignmentLeft;
        self.refreshTipsLabel.text = @"加载中...";
        [self.refreshTipsLabel sizeToFit];
        self.refreshTipsLabel.hidden = YES;
        [self addSubview:self.refreshTipsLabel];

    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.pullDownImageView.frame = CGRectMake(135.0,
                                              (self.frame.size.height - self.pullDownImageView.image.size.height) / 2.0,
                                              self.pullDownImageView.image.size.width,
                                              self.pullDownImageView.image.size.height);
    
    self.pullDownTipsLabel.frame = CGRectMake(CGRectGetMaxX(self.pullDownImageView.frame) + 5.0,
                                              (self.frame.size.height - self.pullDownTipsLabel.frame.size.height) / 2.0,
                                              self.pullDownTipsLabel.frame.size.width,
                                              self.pullDownTipsLabel.frame.size.height);

    self.releaseTipsLabel.frame = CGRectMake(CGRectGetMaxX(self.pullDownImageView.frame) + 5.0,
                                             (self.frame.size.height - self.releaseTipsLabel.frame.size.height) / 2.0,
                                             self.releaseTipsLabel.frame.size.width,
                                             self.releaseTipsLabel.frame.size.height);

    self.activityIndicatorView.frame = CGRectMake(135.0,
                                                  (self.frame.size.height - 20.0) / 2.0,
                                                  20.0,
                                                  20.0);
    
    self.refreshTipsLabel.frame = CGRectMake(CGRectGetMaxX(self.activityIndicatorView.frame) + 5.0,
                                             (self.frame.size.height - self.refreshTipsLabel.frame.size.height) / 2.0,
                                             self.refreshTipsLabel.frame.size.width,
                                             self.refreshTipsLabel.frame.size.height);
    
}

- (void)changeStatus:(PullDownControlStatus)status
{
    if (status == PullDownControlNormalStatus) {
        NSLog(@"111111");
        self.status = status;
        self.pullDownImageView.hidden = NO;
        self.pullDownTipsLabel.hidden = NO;
        self.releaseTipsLabel.hidden = YES;
        self.activityIndicatorView.hidden = YES;
        [self.activityIndicatorView stopAnimating];
        self.refreshTipsLabel.hidden = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DRotate(transform, M_PI, 0.0, 0.0, 1.0);
            self.pullDownImageView.layer.transform = transform;
        } completion:^(BOOL finished) {
        }];
        
    } else if (status == PullDownControlReleaseStatus) {
        NSLog(@"222222");
        self.status = status;
        self.pullDownImageView.hidden = NO;
        self.pullDownTipsLabel.hidden = YES;
        self.releaseTipsLabel.hidden = NO;
        self.activityIndicatorView.hidden = YES;
        [self.activityIndicatorView stopAnimating];
        self.refreshTipsLabel.hidden = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DRotate(transform, M_PI * 2.0, 0.0, 0.0, 1.0);
            self.pullDownImageView.layer.transform = transform;            
        } completion:^(BOOL finished) {
        }];
        
    } else if (status == PullDownControlRefreshingStatus) {
        NSLog(@"3333333");
        self.status = status;
        self.pullDownImageView.hidden = YES;
        self.pullDownTipsLabel.hidden = YES;
        self.releaseTipsLabel.hidden = YES;
        self.activityIndicatorView.hidden = NO;
        [self.activityIndicatorView startAnimating];
        self.refreshTipsLabel.hidden = NO;
    }
}

@end
