//
//  DetailViewController.m
//  Phunware-IHP
//
//  Created by Anna Fortuna on 5/13/15.
//  Copyright (c) 2015 AVF. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () {
    BOOL hasDetail;
}

@property (weak, nonatomic) IBOutlet UILabel *noImg;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        hasDetail = YES;
        // Update the view.
        // [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem && [self.detailItem isKindOfClass:[NSDictionary class]]) {
        
        [_noImg setHidden:YES];
        [_contentImg setHidden:YES];
        
        if (![[[self detailItem] objectForKey:@"image_url"] isEqualToString:@""]) {
            [_noImg setText:@"Loading image..."];
            [_noImg setHidden:NO];
            [self displayImageFromURL:[NSURL URLWithString:[[self detailItem] objectForKey:@"image_url"]]];
        }
        else {
            [_noImg setText:@"No image."];
            [_noImg setHidden:NO];
        }
        
        [_contentName setText:[_detailItem objectForKey:@"name"]];
        [_contentAddress setText:[self displayFullAddressWithAddress:[_detailItem objectForKey:@"address"] city:[_detailItem objectForKey:@"city"] state:[_detailItem objectForKey:@"state"] zip:[_detailItem objectForKey:@"zip"]]];
        
        if ([[_detailItem objectForKey:@"schedule"] count] > 0) {
            [self displaySchedule:[_detailItem objectForKey:@"schedule"]];
        }
        else {
            [_contentSched setText:@"No schedule."];
        }
    }
}

- (void)displaySchedule:(NSArray *)sched {
    NSMutableString *schedules = [NSMutableString string];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    for (NSDictionary *time in sched) {
        NSString *start = nil;
        NSString *end = nil;
        
        if ([time objectForKey:@"start_date"]) {
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
            [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            NSDate *startDate = [dateFormat dateFromString:[time objectForKey:@"start_date"]];
            
            [dateFormat setDateFormat:@"eeee M/dd h:mm a"];
            [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
            
            start = [dateFormat stringFromDate:startDate];
            
        }
        
        if ([time objectForKey:@"end_date"]) {
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
            [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            NSDate *endDate = [dateFormat dateFromString:[time objectForKey:@"end_date"]];
            
            [dateFormat setDateFormat:@"h:mm a"];
            [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
            
            end = [dateFormat stringFromDate:endDate];
        }
        
        if (start != nil) {
            [schedules appendString:start];
        }
        
        if (end != nil) {
            [schedules appendString:[NSString stringWithFormat:@" to %@\n", end]];
        }
    }
    
    [_contentSched setText:schedules];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (hasDetail == YES) {
        [_noInfoLabel setHidden:YES];
        [_contentName setHidden:NO];
        [_contentAddress setHidden:NO];
        [_contentSched setHidden:NO];
    }
    else {
        [_noInfoLabel setHidden:NO];
        [_contentName setHidden:YES];
        [_contentAddress setHidden:YES];
        [_contentSched setHidden:YES];
        [_contentImg setHidden:YES];
        [_noImg setHidden:YES];
    }
    
    [self configureView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    if (_contentName != nil) {
        [_contentSched setPreferredMaxLayoutWidth:_scrollView.bounds.size.width];
        [self updateImageViewConstraints];
    }
}

- (void)displayImageFromURL:(NSURL *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error)
    {
       if ( !error )
       {
           UIImage *image = [UIImage imageWithData:data];
           [_contentImg setImage:image];
           [_contentImg setContentMode:UIViewContentModeScaleAspectFit];
           
           [_noImg setHidden:YES];
           [_contentImg setHidden:NO];
           
       } else{
           [_noImg setText:@"Error downloading image."];
           [_noImg setHidden:NO];
           [_contentImg setHidden:YES];
       }
        
        [self updateImageViewConstraints];
    }];
}

- (void)updateImageViewConstraints {
    for (NSLayoutConstraint *constraint in _scrollView.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth && constraint.secondAttribute == NSLayoutAttributeNotAnAttribute) {
            
            [_scrollView removeConstraint:constraint];
        }
    }
    
    NSLayoutConstraint *cons = nil;
    
    if (![_contentImg isHidden]) {
        cons = [NSLayoutConstraint constraintWithItem:_contentImg
                                            attribute:NSLayoutAttributeWidth
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:nil
                                            attribute:NSLayoutAttributeNotAnAttribute
                                           multiplier:1.0f
                                             constant:_scrollView.bounds.size.width];
        
    }
    else {
        cons = [NSLayoutConstraint constraintWithItem:_noImg
                                            attribute:NSLayoutAttributeWidth
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:nil
                                            attribute:NSLayoutAttributeNotAnAttribute
                                           multiplier:1.0f
                                             constant:_scrollView.bounds.size.width];
    }
    
    [_scrollView addConstraint:cons];
    [_scrollView updateConstraints];
}

- (NSMutableString *)displayFullAddressWithAddress:(NSString *)address city:(NSString *)city state:(NSString *)state zip:(NSString *)zip {
    
    NSMutableString *fullAddress = [NSMutableString string];
    
    if (![address isEqualToString:@""]) {
        [fullAddress appendString:address];
        
        if (![city isEqualToString:@""]) {
            [fullAddress appendString:[NSString stringWithFormat:@", %@", city]];
        }
        
        if (![state isEqualToString:@""]) {
            [fullAddress appendString:[NSString stringWithFormat:@", %@", state]];
        }
        
        if (![zip isEqualToString:@""]) {
            [fullAddress appendString:[NSString stringWithFormat:@" %@", zip]];
        }
    }
    else {
        if (![city isEqualToString:@""]) {
            [fullAddress appendString:city];
            
            if (![state isEqualToString:@""]) {
                [fullAddress appendString:[NSString stringWithFormat:@", %@", state]];
            }
            
            if (![zip isEqualToString:@""]) {
                [fullAddress appendString:[NSString stringWithFormat:@", %@", zip]];
            }
        }
        else if (![state isEqualToString:@""]) {
            [fullAddress appendString:state];
            
            if (![zip isEqualToString:@""]) {
                [fullAddress appendString:[NSString stringWithFormat:@", %@", zip]];
            }
        }
        else if (![zip isEqualToString:@""]) {
            [fullAddress appendString:zip];
        }
    }
    
    return fullAddress;
}


@end
