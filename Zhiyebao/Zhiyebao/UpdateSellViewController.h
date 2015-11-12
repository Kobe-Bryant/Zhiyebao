//
//  PublishSellViewController.h
//  Zhiyebao
//
//  Created by Apple on 14-5-5.
//
//

#import <UIKit/UIKit.h>
@class House;

@interface UpdateSellViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *postSellScrollview;
@property (weak, nonatomic) IBOutlet UIView *sellPictureView;
@property (weak, nonatomic) IBOutlet UIView *furnitureView;

@property(nonatomic,strong) House* sellHouse;

-(id)initWithHouse:(House*)house;

@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *uploadImageViewArray;

@end
