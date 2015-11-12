//
//  BinnerViewController.h
//  domcom.Goclay
//
//  Created by 马峰 on 14-3-12.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BinnerViewController : UIViewController

@property(nonatomic,strong) UIImageView* imageView;

@property(nonatomic,strong) id dataObject;
//@property(nonatomic,strong) id titleString;

- (id)initWithDataObject:(id)dataObject currentIndex:(NSUInteger)currentIndex count:(NSUInteger)count;
- (NSUInteger)currentSelectedIndex;

@end
