//
//  PickUpTableViewController.m
//  InMallVTracking
//
//  Created by Liyana Roslie on 16/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "PickUpTableViewController.h"
#import "Order.h"
#import "DetailViewController.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface PickUpTableViewController ()

@end

@implementation PickUpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = RGBCOLOR(53,123,253);
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(get_order)
                  forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(scanBarcode:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
//    self.pickupListArray = [NSArray arrayWithObjects:@"Check List",@"Location-call",@"NRIC",@"FMIP OFF",@"IMEI",@"Defect-free",@"COD",@"Completed",@"Pre-Call Next Customer", nil];
    
}

- (void) get_order {
    RKObjectMapping *OrderMapping = [RKObjectMapping mappingForClass:[Order class]];
    [OrderMapping addAttributeMappingsFromDictionary:@{
                                                       @"id" : @"web_id",
                                                       @"do_number" : @"do_number",
                                                       @"order_type" : @"order_type",
                                                       @"cod_amount" : @"cod_amount",
                                                       @"exchange_code" : @"exchange_code",
                                                       @"payment_term" : @"payment_term",
                                                       @"sender" : @"sender",
                                                       @"receiver" : @"receiver",
                                                       @"latest_status" : @"latest_status",
                                                       @"remarks" : @"remarks",
                                                       @"sender_name" : @"sender_name",
                                                       @"sender_addr" : @"sender_addr",
                                                       @"sender_unit_no" : @"sender_unit_no",
                                                       @"sender_postcode" : @"sender_postcode",
                                                       @"sender_contact_no" : @"sender_contact_no",
                                                       @"receiver_name" : @"receiver_name",
                                                       @"receiver_addr" : @"receiver_addr",
                                                       @"receiver_contact_no" : @"receiver_contact_no",
                                                       @"receiver_unit_no" : @"receiver_unit_no",
                                                       @"receiver_postcode" : @"receiver_postcode" }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:OrderMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/hpapi/borders.json"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/hpapi/borders.json"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.pickupListArray = mappingResult.array;
                                                  [self reloadData];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
}

- (void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self get_order];
}

- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.pickupListArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Order *order = self.pickupListArray[indexPath.row];
    
    UILabel *doNumber = (UILabel *)[cell viewWithTag:100];
    [doNumber setText:order.do_number];
    
    UILabel *address = (UILabel *)[cell viewWithTag:200];
    NSString *addressString = [order.receiver_addr stringByAppendingString:@" "];
    addressString = [addressString stringByAppendingString:order.receiver_unit_no];
    addressString = [addressString stringByAppendingString:@" "];
    addressString = [addressString stringByAppendingString:order.receiver_postcode];
    [address setText:addressString];
    
    UILabel *status= (UILabel *)[cell viewWithTag:300];
    [status setText:order.latest_status];
    
}

#pragma mark - Reload Data

- (void)reloadData {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"goToDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        UINavigationController *navigationController = segue.destinationViewController;
        DetailViewController *detailVC = [[navigationController viewControllers] objectAtIndex:0];
        
        Order *order = self.pickupListArray[indexPath.row];
        detailVC.order = order;
    }
}

@end
