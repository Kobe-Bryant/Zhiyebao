//
//  MainViewController.h
//  Zhiyebao
//
//  Created by Apple on 14-4-29.
//
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController

//切换试图控制器的方法，外面需要调用该方法
//- (void)changeViewController:(CoustomButton*)sender;
- (void)changeTabBarSelectedIndex:(NSUInteger)currentSelectedIndex;

//隐藏自定义的TabBar
//- (void)hiddenTabbar;

//显示自定义的TabBar
//- (void)showTabbar;

//左右移动TabBar
//- (void)toggleTabBarLeftRightMove;


@end
