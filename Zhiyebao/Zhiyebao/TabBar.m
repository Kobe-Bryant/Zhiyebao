//
//  TabBar.m
//  Zhiyebao
//
//  Created by Apple on 14-5-6.
//
//

#import "TabBar.h"

@interface TabBar()


@end

@implementation TabBar



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        self.backgroundColor = [UIColor greenColor];
        self.backgroundImage = [UIImage imageNamed:@"Transparent"];
        self.shadowImage = [UIImage imageNamed:@"Transparent"];
        
        
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Transparent"]];
        self.backgroundImageView = [[UIImageView alloc] init];
        self.backgroundImageView.image = [UIImage imageNamed:@"NewTabBarBackground"];
        [self addSubview:self.backgroundImageView];
    }
    
    return self;
}

- (void)layoutSubviews{
    
    
  [super layoutSubviews];
    
    
    self.frame = CGRectMake(0.0,
                            568.0 - self.backgroundImageView.image.size.height,
                            self.frame.size.width,
                            self.backgroundImageView.image.size.height);
    
    NSLog(@"%f", self.backgroundImageView.image.size.height);
    
    self.backgroundImageView.frame = CGRectMake(0.0,
                                                0.0,
                                                self.frame.size.width,
                                                self.frame.size.height);
    
//    NSLog(@"tabbar.subviews =  %@", self.subviews);

}




@end
