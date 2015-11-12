//
//  Cell1.h
//  domcom.Goclay
//
//  Created by Apple on 14-3-14.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  enum cellControllerStyle  {
    kfilterControllerType = 0,
    knewGoodsControllerType = 1
    
} cellControllerType ;

@interface Cell1 : UITableViewCell



@property (nonatomic,strong) UIImageView *FirstArrowImageView;


@property(nonatomic) cellControllerType type;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellControllerType:(cellControllerType)type;


//- (void)changeArrowWithUp:(BOOL)up;




@end
