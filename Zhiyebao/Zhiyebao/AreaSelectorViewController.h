//
//  AreaSelectorViewController.h
//  Zhiyebao
//
//  Created by LaiZhaowu on 14-5-15.
//
//

#import <UIKit/UIKit.h>

@protocol AreaSelectorViewControllerDelegate <NSObject>

- (void)setAreaIDArrayAtSelector:(NSArray *)updateAreaIDArray;

@end

@interface AreaSelectorViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) id<AreaSelectorViewControllerDelegate>delegate;
- (id)initWithBackgroundImage:(UIImage *)backgroundImage;

@end
