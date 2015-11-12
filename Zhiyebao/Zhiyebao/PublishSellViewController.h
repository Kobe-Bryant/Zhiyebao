//
//  PublishSellViewController.h
//  Zhiyebao
//
//  Created by Apple on 14-5-5.
//
//

#import <UIKit/UIKit.h>

@interface PublishSellViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *postSellScrollview;
@property (weak, nonatomic) IBOutlet UIView *sellPictureView;
@property (weak, nonatomic) IBOutlet UIView *furnitureView;

//@property (weak, nonatomic) IBOutlet UIView *noView;

//下面的view是选中前面的小矩形
//@property (weak, nonatomic) IBOutlet UIView *furnitureView;
//@property (weak, nonatomic) IBOutlet UIView *bedView;
//@property (weak, nonatomic) IBOutlet UIView *watchView;
//@property (weak, nonatomic) IBOutlet UIView *AirView;
//@property (weak, nonatomic) IBOutlet UIView *refrigeratorView;
//@property (weak, nonatomic) IBOutlet UIView *furniView;
//@property (weak, nonatomic) IBOutlet UIView *onlineView;
//@property (weak, nonatomic) IBOutlet UIView *hotwaterView;
//@property (weak, nonatomic) IBOutlet UIView *microwaveView;
//@property (weak, nonatomic) IBOutlet UIView *machineView;
//@property (weak, nonatomic) IBOutlet UIView *gasView;
//@property (weak, nonatomic) IBOutlet UIView *bigView;

@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *uploadImageViewArray;

@end
