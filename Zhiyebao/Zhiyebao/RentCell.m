//
//  RentCell.m
//  Zhiyebao
//
//  Created by Apple on 14-4-29.
//
//

#import "RentCell.h"
#import "Macros.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DACircularProgressView.h"

@interface RentCell ()

@property (nonatomic, retain) UILabel *priceLabel;

@end

@implementation RentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
        

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
        
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 69.0, 180.0, 15.0)];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.font = [UIFont systemFontOfSize:15];
        self.priceLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB(244.0, 127.0, 64.0).CGColor];
        [self.contentView addSubview:self.priceLabel];
        
    
    
    }
    return self;
}

-(void)setCellInfo:(House*)house
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
    
}

@end
