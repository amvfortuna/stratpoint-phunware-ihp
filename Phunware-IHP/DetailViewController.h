//
//  DetailViewController.h
//  Phunware-IHP
//
//  Created by Anna Fortuna on 5/11/15.
//  Copyright (c) 2015 AVF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

