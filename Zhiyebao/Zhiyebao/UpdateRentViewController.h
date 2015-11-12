//
//  PostViewController.h
//  Zhiyebao
//
//  Created by Apple on 14-4-30.
//
//

#import <UIKit/UIKit.h>
@class House;

@interface  UpdateRentViewController: UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollview;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIView *furnitureView;


@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *uploadImageViewArray;
@property(nonatomic,strong) House* rentHouse;

-(id)initWithHouse:(House*)house;


@end
