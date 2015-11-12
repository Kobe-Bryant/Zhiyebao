//
//  Cell1.m
//  domcom.Goclay
//
//  Created by Apple on 14-3-14.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "Cell1.h"
#import "Macros.h"

@implementation Cell1

@synthesize FirstArrowImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellControllerType:(cellControllerType)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.textLabel.frame = CGRectMake(15.0, 12.0, 40.0, 25.0);
        self.textLabel.textColor = UIColorFromRGB(160.0, 166.0, 166.0);
        self.textLabel.font = [UIFont systemFontOfSize:15.0];
        self.textLabel.backgroundColor = [UIColor clearColor];

        
        self.type = type;
        
        
        if (self.type == kfilterControllerType) {
            
//            self.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                
                UIView* separatorColor = [[UIView alloc]initWithFrame:CGRectMake
                                          (0, 43.0+0.5, self.contentView.frame.size.width, 0.5)];
                separatorColor.backgroundColor = UIColorFromRGB(40.0, 40.0, 40.0);
                [self.contentView addSubview:separatorColor];
                
            } else {
                
                UIView* linebackView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                               self.contentView.frame.size.height-1,
                                                                               320,0.5)];
                linebackView.backgroundColor = UIColorFromRGB(40.0, 40.0, 40.0);
                [self addSubview:linebackView];
            }
            
        } else  {
            
            
            UIView* separatorColor = [[UIView alloc]initWithFrame:CGRectMake
                                      (0, 150.0-1.0, self.contentView.frame.size.width, 0.5)];
            
            if (IOS_VERSION_LESS_THAN(@"7.0")) {
                
                separatorColor.frame = CGRectMake(0.0,
                                                  150.0 - 1.0,
                                                  self.contentView.frame.size.width,
                                                  1.0);
            }
            
            separatorColor.backgroundColor = UIColorFromRGB(40.0, 40.0, 40.0);
            [self.contentView addSubview:separatorColor];
        }
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.textLabel.frame = CGRectMake(self.frame.size.width - 200.0 + 15.0,
                                      0.0,
                                      self.frame.size.width,
                                      self.frame.size.height);
    
    self.accessoryView.frame = CGRectMake(self.frame.size.width - self.accessoryView.frame.size.width - 5.0,
                                          self.frame.size.height - self.accessoryView.frame.size.height - 5.0,
                                          self.accessoryView.frame.size.width,
                                          self.accessoryView.frame.size.height);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

//- (void)changeArrowWithUp:(BOOL)up
//{
//    if (up) {
////        [UIView animateWithDuration:5 animations:^{
//        self.FirstArrowImageView.image = [UIImage imageNamed:@"accessdown.png"];
////        }];
//    } else {
//        self.FirstArrowImageView.image = [UIImage imageNamed:@"accessviewImage.png"];
//    }
//}

@end
