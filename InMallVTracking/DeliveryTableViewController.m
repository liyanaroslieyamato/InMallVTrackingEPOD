//
//  DeliveryTableViewController.m
//  InMallVTracking
//
//  Created by Liyana Roslie on 13/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//
#import <RestKit/RestKit.h>

#import "DeliveryTableViewController.h"
#import "DetailViewController.h"
#import "OrderBaseOnTenantCode.h"
#import "Order.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface DeliveryTableViewController ()

@end

@implementation DeliveryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(scanBarcode:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    //     self.deliveryListArray = [NSArray arrayWithObjects:@"Check List",@"Location-call",@"NRIC",@"FMIP OFF",@"IMEI",@"Defect-free",@"COD",@"Completed",@"Pre-Call Next Customer", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    NSLog(@"Tenant code is %@", self.tenantCodeString);
    
    [self get_orders_from_tenantCode];
    [self get_orderList];
    
    //Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = RGBCOLOR(53,123,253);
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(get_orders_from_tenantCode)
                  forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
}

- (void) get_orders_from_tenantCode {
    
    RKObjectMapping *OrderMapping = [RKObjectMapping mappingForClass:[OrderBaseOnTenantCode class]];
    [OrderMapping addAttributeMappingsFromDictionary:@{ @"id" : @"shop_id",
                                                        @"do_number" : @"do_number",
                                                        @"order_type" : @"order_type",
                                                        @"cod_amount" : @"cod_amount",
                                                        @"exchange_code" : @"exchange_code",
                                                        @"payment_term" : @"payment_term",
                                                        @"sender" : @"sender",
                                                        @"receiver" : @"receiver",
                                                        @"latest_status" : @"latest_status",
                                                        @"principal_name" : @"principal_name" }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:OrderMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/hpapi/sasreceiver.json"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSDictionary *params = @{@"receiver" : self.tenantCodeString};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/hpapi/sasreceiver.json"
                                           parameters:params
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.deliveryListArray = mappingResult.array;
                                                  //                                                  for (OrderBaseOnTenantCode *order in self.deliveryListArray) {
                                                  //                                                      NSLog(@"Tenant Names %@", order.principal_name);
                                                  //                                                  }
                                                  [self reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
    
}

- (void) get_orderList {
    
    RKObjectMapping *OrderMapping = [RKObjectMapping mappingForClass:[Order class]];
    [OrderMapping addAttributeMappingsFromDictionary:@{   @"id" : @"web_id",
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
                                                  self.orderListArray = mappingResult.array;
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
    
}

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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.deliveryListArray count];
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
    if ([self.deliveryListArray count] > 0) {
        OrderBaseOnTenantCode *order = self.deliveryListArray[indexPath.row];
        
        UILabel *doNumber = (UILabel *)[cell viewWithTag:100];
        [doNumber setText:order.do_number];
        
        UILabel *lspName = (UILabel *)[cell viewWithTag:200];
        [lspName setText:order.principal_name];
        
        UILabel *status= (UILabel *)[cell viewWithTag:300];
        [status setText:order.latest_status];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toDetail"]) {
        UINavigationController *navigationController =segue.destinationViewController;
        DetailViewController *destViewController =  [[navigationController viewControllers]objectAtIndex:0];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        OrderBaseOnTenantCode *selectedOrder = self.deliveryListArray[indexPath.row];
        for (Order *order in self.orderListArray) {
            if ([selectedOrder.do_number isEqualToString:order.do_number]) {
                NSUInteger arrayIndex = [self.orderListArray indexOfObject: order];
                self.index = (int) arrayIndex;
                destViewController.order = self.orderListArray[self.index];
                destViewController.key = @"doDelivery";
            }
        }
    }
}


@end
