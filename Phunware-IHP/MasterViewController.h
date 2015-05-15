//
//  MasterViewController.h
//  Phunware-IHP
//
//  Created by Anna Fortuna on 5/13/15.
//  Copyright (c) 2015 AVF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UIViewController <NSURLConnectionDataDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIView *fetchingDataView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

