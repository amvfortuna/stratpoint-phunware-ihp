//
//  MasterViewController.m
//  Phunware-IHP
//
//  Created by Anna Fortuna on 5/13/15.
//  Copyright (c) 2015 AVF. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController () {
    NSURL *jsonURL;
    NSMutableData *responseData;
}

@property NSMutableArray *objects;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    jsonURL = [NSURL URLWithString:@"https://s3.amazonaws.com/jon-hancock-phunware/nflapi-static.json"];
    
    [self retrieveDateFromURL:jsonURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    responseData = nil;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
        NSDictionary *selectedContent = (NSDictionary *)[_objects objectAtIndex:[indexPath row]];
        
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        
        [controller setDetailItem:selectedContent];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_objects) {
        return 1;
    }
    else {
        return [_objects count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *jsonContent = (NSDictionary *)[_objects objectAtIndex:[indexPath row]];
    
    
    [[cell textLabel] setText:[jsonContent objectForKey:@"name"]];
    [[cell detailTextLabel] setText:[self displayFullAddressWithAddress:[jsonContent objectForKey:@"address"] city:[jsonContent objectForKey:@"city"] state:[jsonContent objectForKey:@"state"] zip:[jsonContent objectForKey:@"zip"]]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark RETRIEVE DATA (NSURLCONNECT DELEGATES)

- (void)retrieveDateFromURL:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // In order to remove the warning about "unused variables", I decided to manually start
    // the request.
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    [conn start];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [_errorLabel setText:@"Sorry! An error occurred while retrieving list of venues."];
    [_fetchingDataView setHidden:YES];
    [_errorLabel setHidden:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (!responseData) {
        responseData = [NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"Connection finished loading.");
    
    connection = nil;
    
    if (responseData != nil) {
        
        NSError *error = nil;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        
        if (error == nil) {
            
            if ([arr count] > 0) {
                _objects = [NSMutableArray arrayWithArray:arr];
                [_loadingView setHidden:YES];
                [[self tableView] reloadData];
            }
            else {
                [_errorLabel setText:@"No venues to display."];
                [_fetchingDataView setHidden:YES];
                [_errorLabel setHidden:NO];
            }
        }
        else {
            [_errorLabel setText:@"Sorry! We cannot display the list of venues."];
            [_fetchingDataView setHidden:YES];
            [_errorLabel setHidden:NO];
        }
        
        responseData = nil;
    }
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    
    return nil;
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
