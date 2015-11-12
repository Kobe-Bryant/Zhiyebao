//
//  ContactViewController.h
//  Zhiyebao
//
//  Created by Apple on 14-5-2.
//
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UIViewController* mainController;

@end
