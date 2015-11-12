//
//  MemberCell.m
//  Zhiyebao
//
//  Created by Apple on 14-5-2.
//
//

#import "MemberCell.h"
#import "Macros.h"

@implementation MemberCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
        
        
    
    
    }
    return self;
}


-(void)layoutSubviews{

    [super layoutSubviews];
    
    
    
    
    self.contentView.frame =  CGRectMake(0.0, 0.0, self.frame.size.width, 48.0);
    
    self.backgroundColor = UIColorFromRGB(255.0, 253.0, 250.0);
        
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.contentView.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
