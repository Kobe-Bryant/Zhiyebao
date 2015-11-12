//
//  Cell2.h
//  domcom.Goclay
//
//  Created by Apple on 14-3-14.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  enum cellControllerType  {
    kfiltControllerType = 0,
    knewGoodControllerType = 1
    
} cellType ;

@interface Cell2 : UITableViewCell

@property(nonatomic) cellType type;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellControllerType:(cellType)type;

@end
