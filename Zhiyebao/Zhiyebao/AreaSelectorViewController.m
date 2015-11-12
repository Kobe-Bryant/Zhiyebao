//
//  AreaSelectorViewController.m
//  Zhiyebao
//
//  Created by LaiZhaowu on 14-5-15.
//
//

#define CONTAINER_WIDTH 275.0
#define CONTAINER_HEIGHT 380.0

#import "AreaSelectorViewController.h"
#import "Macros.h"
#import "SystemSetting.h"

@interface AreaSelectorViewController ()

@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) UIButton *okButton;
@property (nonatomic) BOOL isViewWillAppeared;
@property (nonatomic, retain) NSArray *areaArray;
@property (nonatomic, retain) NSMutableArray *selectedIndexPathArray;
@property (nonatomic, retain) UIImage *backgroundImage;

@end

@implementation AreaSelectorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithBackgroundImage:(UIImage *)backgroundImage
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.backgroundImage = backgroundImage;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor greenColor];
//    self.navigationController.view.backgroundColor = [UIColor clearColor];
//    self.view.backgroundColor = [UIColor clearColor];
//    self.view.opaque = YES;

    
    self.selectedIndexPathArray = [[NSMutableArray alloc] init];
    

    self.closeButton = [[UIButton alloc] init];
    self.closeButton.frame = CGRectMake(0.0, 0.0, 45.0, 45.0);
    [self.closeButton setImage:[UIImage imageNamed:@"AreaSelectorCloseButton"]
                      forState:UIControlStateNormal];
    [self.closeButton addTarget:self
                         action:@selector(closeButtonPressed:)
               forControlEvents:UIControlEventTouchDown];
    
    
    UIImage *backgroundImage = [UIImage imageNamed:@"AreaSelectorOkButton"];
    self.okButton = [[UIButton alloc] init];
    self.okButton.frame = CGRectMake(0.0, 0.0, backgroundImage.size.width, backgroundImage.size.height);
    NSLog(@"okButton.frame %@", NSStringFromCGRect(self.okButton.frame));
    [self.okButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okButton addTarget:self
                      action:@selector(okButtonPressed:)
            forControlEvents:UIControlEventTouchDown];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isViewWillAppeared) {
        return;
    } else {
        self.isViewWillAppeared = YES;
    }
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    imageView.image = self.backgroundImage;
    [self.view addSubview:imageView];
    
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.7;
   [self.view addSubview:backgroundView];
    
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake((self.view.frame.size.width - CONTAINER_WIDTH) / 2.0,
                                 (self.view.frame.size.height - CONTAINER_HEIGHT) / 2.0,
                                 CONTAINER_WIDTH,
                                 CONTAINER_HEIGHT);
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.layer.cornerRadius = 4.0;
    tableView.clipsToBounds = YES;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.sectionHeaderHeight = 45.0;
    tableView.sectionFooterHeight = 85.0;
    [self.view addSubview:tableView];
    
    
    
    // loadData
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        Result *result = [SystemSetting request];
        if (result.isSuccess) {
            NSLog(@"result.data %@", result.data);
            NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:result.data];
            if ([dict objectForKey:AREA_KEY]) {
                self.areaArray = [dict objectForKey:AREA_KEY];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView reloadData];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


- (void)closeButtonPressed:(UIButton *)button
{
    NSLog(@"closeButtonPressed");
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate setAreaIDArrayAtSelector:[[NSArray alloc] init]];
    }];

}

- (void)okButtonPressed:(UIButton *)button
{
    NSLog(@"okButtonPressed");
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissViewControllerAnimated");
        NSMutableArray *areaIDArray = [[NSMutableArray alloc] init];
        for (NSIndexPath *indexPath in self.selectedIndexPathArray) {
            Area *area = [self.areaArray objectAtIndex:indexPath.row];
            [areaIDArray addObject:area.areaID];
        }
        NSLog(@"areaIDArray %@", areaIDArray);
        [self.delegate setAreaIDArrayAtSelector:areaIDArray];
    }];
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0.0,
                                  0.0,
                                  tableView.frame.size.width,
                                  tableView.sectionHeaderHeight);
    headerView.backgroundColor = UIColorFromRGB(241.0, 116.0, 50.0);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(15.0, 0.0, 200.0, headerView.frame.size.height);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.text = @"请选择租房片区";
    [headerView addSubview:titleLabel];
    
    self.closeButton.frame = CGRectMake(headerView.frame.size.width - self.closeButton.frame.size.width,
                                        0.0,
                                        self.closeButton.frame.size.width,
                                        self.closeButton.frame.size.height);
    [headerView addSubview:self.closeButton];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0.0,
                                  0.0,
                                  tableView.frame.size.width,
                                  tableView.sectionFooterHeight);
    self.okButton.frame = CGRectMake((headerView.frame.size.width - self.okButton.frame.size.width) / 2.0,
                                     (headerView.frame.size.height - self.okButton.frame.size.height) / 2.0,
                                     self.okButton.frame.size.width,
                                     self.okButton.frame.size.height);
    [headerView addSubview:self.okButton];
    return headerView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.areaArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    
    cell.textLabel.textColor = UIColorFromRGB(90.0, 89.0, 89.0);
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    Area *area = [self.areaArray objectAtIndex:indexPath.row];
    cell.textLabel.text = area.title;
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    if ([self.selectedIndexPathArray indexOfObject:indexPath] != NSNotFound) {
        imageView.image = [UIImage imageNamed:@"AreaSelectorSelectedPoint"];
    } else {
        imageView.image = [UIImage imageNamed:@"AreaSelectorUnselectedPoint"];
    }
    imageView.frame = CGRectMake(0.0, 0.0, imageView.image.size.width, imageView.image.size.height);
    cell.accessoryView = imageView;
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedIndexPathArray indexOfObject:indexPath] != NSNotFound) {
        [self.selectedIndexPathArray removeObject:indexPath];
    } else {
        [self.selectedIndexPathArray addObject:indexPath];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
