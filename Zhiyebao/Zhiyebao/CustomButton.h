//
//  CoustomButton.h
//  Zhiyebao
//
//  Created by Apple on 14-5-3.
//
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect;
- (CGRect)titleRectForContentRect:(CGRect)contentRect;

@end
