//
//  PostViewController.h
//  Zhiyebao
//
//  Created by Apple on 14-4-30.
//
//

#import <UIKit/UIKit.h>



@interface PostViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollview;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIView *furnitureView;


@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *uploadImageViewArray;
@property (readwrite, nonatomic, copy) void (^uploadProgress)(NSUInteger bytes, NSInteger totalBytes, NSInteger totalBytesExpected);


@end
