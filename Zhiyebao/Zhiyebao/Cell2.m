//
//  Cell2.m
//  domcom.Goclay
//
//  Created by Apple on 14-3-14.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "Cell2.h"
#import "Macros.h"

@implementation Cell2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellControllerType:(cellType)type

{
   
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    self.type = type;

    if (self) {
        
        self.textLabel.textColor = UIColorFromRGB(160.0, 166.0, 166.0);
        
        UIView* separatorColor = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                    self.frame.size.height - 0.5,
                                            self.contentView.frame.size.width,
                                                                         0.5)];
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            
            
         separatorColor.frame = CGRectMake(0,
                                           self.frame.size.height - 1.0,
                                           self.contentView.frame.size.width,
                                           1.0);
            
        }
        

        if (self.type == kfiltControllerType) {
            separatorColor.backgroundColor = UIColorFromRGB(25.0, 25.0, 25.0);
        } else {
            separatorColor.backgroundColor = UIColorFromRGB(25.0, 25.0, 25.0);
        }
        
        
        [self addSubview:separatorColor];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(self.frame.size.width - 200.0 + 30.0,
                                      0.0,
                                      self.frame.size.width,
                                      self.frame.size.height);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];

}

@end
