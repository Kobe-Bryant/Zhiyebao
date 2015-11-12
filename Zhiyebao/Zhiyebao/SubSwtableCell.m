//
//  SubSwtableCell.m
//  Zhiyebao
//
//  Created by Apple on 14-6-4.
//
//

#import "SubSwtableCell.h"
#import "Macros.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DACircularProgressView.h"
#import "CustomMarcos.h"

@interface SubSwtableCell ()

@property (nonatomic, retain) UILabel *priceLabel;
@property(nonatomic,assign) BOOL isChange;



@end

@implementation SubSwtableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath*)indexPath
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
       
        self.contentView.userInteractionEnabled = YES;
        

        [[NSNotificationCenter defaultCenter]addObserver:self selector:
                 @selector(changeCellFrame:) name:CHANGE_CELL_FRAME object:nil];
        
        UIImage* deleteCellImage = [UIImage imageNamed:@"deleteHouseImage.png"];
        
        self.cellImageView = [[UIImageView alloc]init];
        self.cellImageView.frame = CGRectMake(-26.0,
                                                         self.frame.size.height/2.0+10.0,
                                                         deleteCellImage.size.width,
                                                         deleteCellImage.size.height);
        self.cellImageView.tag = 100;
        self.cellImageView.image = deleteCellImage;
        self.cellImageView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        [self.contentView addSubview:self.cellImageView];
        
       
        self.imageView.frame = CGRectMake(10.0, 15.0, 105.0, 70.0);
        self.imageView.image = [UIImage imageNamed:@"Transparent"];
        self.imageView.layer.cornerRadius = 4.0;
        self.imageView.clipsToBounds = YES;
        self.imageView.backgroundColor = [UIColor lightGrayColor];
        
        self.textLabel.frame = CGRectMake(130.0, 5.0, 180.0, 50.0);
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 2;
        self.textLabel.font = [UIFont systemFontOfSize:13.0];
        self.textLabel.textColor = UIColorFromRGB(66.0, 66.0, 66.0);
        
        
        
        self.detailTextLabel.frame = CGRectMake(130.0, 48.0, 180.0, 20.0);
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:10.0];
        self.detailTextLabel.textColor = UIColorFromRGB(153.0, 153.0, 153.0);
        
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 80.0, 180.0, 15.0)];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.font = [UIFont systemFontOfSize:15];
         self.priceLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB(244.0, 127.0, 64.0).CGColor];
        [self.contentView addSubview:self.priceLabel];
        
        
        
    }
    return self;
}

- (void)changeCellFrame:(NSNotification*)notification
{
    

    UIButton* rightButton =(UIButton*)notification.object;
    self.isChange = !self.isChange;
    [UIView animateWithDuration:0.25 animations:^{
        if (self.isChange) {
            self.contentView.frame = CGRectMake(30.0, 0.0, self.frame.size.width, self.frame.size.height);
               [rightButton setTitle:@"完成" forState:UIControlStateNormal];
            
        } else {
            self.contentView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
             [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        }
    } completion:^(BOOL finished) {
        [self layoutSubviews];
    }];

}

- (void)setCellInfo:(House*)house indexPath:(NSIndexPath*)indexPath
{
    
    if (house.thumbImageURLString) {
        NSLog(@"house.thumbImageURLString %@", house.thumbImageURLString);
        DACircularProgressView *progressView = [[DACircularProgressView alloc] init];
        progressView.frame = CGRectMake((self.imageView.frame.size.width - 20.0) / 2.0,
                                        (self.imageView.frame.size.height - 20.0) / 2.0,
                                        20.0,
                                        20.0);
        progressView.progress = 0.0;
        [self.imageView addSubview:progressView];
        
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:house.thumbImageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
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
    
    self.textLabel.text = house.title;
    self.detailTextLabel.text = house.houseTypeTitle;
    self.priceLabel.text = house.price;
    
    
    
}




- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10.0, 15.0, 105.0, 67.0);
    self.textLabel.frame = CGRectMake(130.0, 5.0, 180.0, 50.0);
    self.detailTextLabel.frame = CGRectMake(130.0, 48.0, 180.0, 20.0);
    self.priceLabel.frame = CGRectMake(130.0, 69.0, 180.0, 15.0);
    
    if (self.isChange) {
        
        self.contentView.frame = CGRectMake(30.0, 0.0, self.frame.size.width, self.frame.size.height);
        
    }else {
    
    
        self.contentView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);

    
    }
    

}

@end
