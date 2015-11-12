//
//  FilterViewController.h
//  Zhiyebao
//
//  Created by Apple on 14-4-30.
//
//

#import <UIKit/UIKit.h>



@interface FilterViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) BOOL isRent;

- (void)refreshData;

- (id)initWithIsRent:(BOOL)newIsRent;

@end
