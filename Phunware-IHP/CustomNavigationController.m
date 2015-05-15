//
//  CustomNavigationController.m
//  Phunware-IHP
//
//  Created by Anna Fortuna on 5/15/15.
//  Copyright (c) 2015 AVF. All rights reserved.
//

#import "CustomNavigationController.h"

@implementation CustomNavigationController

- (NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    }
    else {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
}

@end
