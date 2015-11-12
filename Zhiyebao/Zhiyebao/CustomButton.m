 //
//  CoustomButton.m
//  Zhiyebao
//
//  Created by Apple on 14-5-3.
//
//

#define kImageWidth 17.0
#define kImageHeight 21.0

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect;
{
    CGFloat imageWidth = contentRect.size.width;
    CGFloat imageHeight = contentRect.size.height * 0.5;
    return CGRectMake(0.0, 8.0, imageWidth, imageHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height * 0.55;
    CGFloat titleWidth = contentRect.size.width;
    CGFloat titleHeight = contentRect.size.height - titleY;
    return CGRectMake(0.0, titleY, titleWidth, titleHeight);
}

@end
