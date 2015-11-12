//
//  ViewDeckController.m
//  Zhiyebao
//
//  Created by LaiZhaowu on 14-5-28.
//
//

#import "ViewDeckController.h"
#import "CustomMarcos.h"

@interface ViewDeckController ()

@end

@implementation ViewDeckController

- (void)notifyDidOpenSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    NSLog(@"notifyDidOpenSide");
    [[NSNotificationCenter defaultCenter] postNotificationName:FILTER_SIDEBR_DID_OPENED_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];

}

- (void)notifyDidCloseSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    NSLog(@"notifyDidCloseSide");
    [[NSNotificationCenter defaultCenter] postNotificationName:FILTER_SIDEBR_DID_CLOSED_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];

}

@end
