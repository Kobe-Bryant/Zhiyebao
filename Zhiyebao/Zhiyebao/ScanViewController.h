//
//  ScanViewController.h
//  Zhiyebao
//
//  Created by Apple on 14-5-2.
//
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong) UIViewController* mainController;
@property(nonatomic,assign) int userId;



@end
