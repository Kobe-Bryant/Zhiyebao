//
//  PostRentViewController.h
//  Zhiyebao
//
//  Created by Apple on 14-5-2.
//
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface PostRentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>



@property(nonatomic, strong) UIViewController* mainController;

@end
