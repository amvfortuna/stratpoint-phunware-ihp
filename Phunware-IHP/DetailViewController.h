//
//  DetailViewController.h
//  Phunware-IHP
//
//  Created by Anna Fortuna on 5/13/15.
//  Copyright (c) 2015 AVF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UILabel *contentName;
@property (weak, nonatomic) IBOutlet UILabel *contentAddress;
@property (weak, nonatomic) IBOutlet UILabel *contentSched;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *noInfoLabel;



@end

