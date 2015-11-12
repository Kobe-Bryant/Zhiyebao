//
//  SubSwtableCell.h
//  Zhiyebao
//
//  Created by Apple on 14-6-4.
//
//

#import "SWTableViewCell.h"
#import "House.h"

@interface SubSwtableCell : SWTableViewCell

@property(nonatomic,retain) UIImageView* cellImageView;

- (void)setCellInfo:(House*)house indexPath:(NSIndexPath*)indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath*)indexPath;


@end
