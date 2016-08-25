//
//  DeliveryScanViewController.m
//  InMallVTracking
//
//  Created by Liyana Roslie on 13/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//
#import <RestKit/RestKit.h>

#import "DeliveryScanViewController.h"
#import "DeliveryTableViewController.h"
#import "DetailViewController.h"
#import "Tenant.h"
#import "Order.h"

@interface DeliveryScanViewController ()

@end

@implementation DeliveryScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isScanTenantCode = NO;
    self.isTenantCodeFound = NO;
    self.isDONumberFound = NO;
    
    self.tenantNameTextField.enabled = NO;
    
    //    self.tenantListArray = [NSMutableArray arrayWithObjects:@"Carl Zeiss",@"YamatoAsia",@"Canon",@"Nespresso",@"Tenant 5",@"Tenant 6",@"Tenant 7",@"Tenant 8",@"Tenant 9", @"Tenant 10", @"Tenant 11", @"Tenant 12", nil];
    //    self.searchTenantNameArray = [[NSMutableArray alloc]  init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(scanBarcode:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.isScanTenantCode = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Dashboard" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self get_tenant_list];
    [self get_order_list];
    
    if (self.isTenantCodeFound == YES) {
        self.isTenantCodeFound = NO;
    }
    
    if (self.isDONumberFound == YES) {
        [self.navigationController popViewControllerAnimated:YES];
        [self performSegueWithIdentifier: @"toDetail" sender: self];
        self.isDONumberFound = NO;
    }
    
}

- (void) get_tenant_list {
    
    RKObjectMapping *TenantMapping = [RKObjectMapping mappingForClass:[Tenant class]];
    [TenantMapping addAttributeMappingsFromDictionary:@{ @"address" : @"address",
                                                         @"shop_name" : @"name",
                                                         @"contact_no" : @"contact",
                                                         @"unit_no" : @"unit_num",
                                                         @"postcode" : @"postal_code",
                                                         @"remarks" : @"remarks",
                                                         @"b2b_shop_code" : @"b2b_code",
                                                         @"shop_qr_code" : @"qr_code",
                                                         @"customer_shop_code" : @"shop_code" }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor2 =
    [RKResponseDescriptor responseDescriptorWithMapping:TenantMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/hpapi/all_shops.json"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor2];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/hpapi/all_shops.json"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.tenantListArray = mappingResult.array;
                                                  
                                                  //                                                  for (Tenant *tenant in self.tenantListArray) {
                                                  //                                                      NSLog(@"Tenant Names %@", tenant.name);
                                                  //                                                  }
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
    
}

- (void) get_order_list {
    
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

- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_tenantNameTextField resignFirstResponder];
}

#pragma mark - BarcodeScanViewControllerDelegate

- (void)BarcodeScanViewControllerDidCancel:(BarcodeScanViewController *)controller
{
    NSLog(@"cancel---2");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)BarcodeScanViewController:(BarcodeScanViewController *)controller scanDone:(NSString *)scanResult
{
    if (_isScanTenantCode == NO) {
        NSString *doNumberString = scanResult;
        for (Order *order in self.orderListArray) {
            if ([order.do_number isEqualToString:doNumberString]) {
                self.isDONumberFound= YES;
                NSUInteger arrayIndex = [self.orderListArray indexOfObject: order];
                self.index = (int) arrayIndex;
            }
        }
        if (self.isDONumberFound == NO) {
            [self showErrorMessage2];
        }
    }
    else if (_isScanTenantCode == YES) {
        NSString *tenantCodeString = scanResult;
        for (Tenant *tenant in self.tenantListArray) {
            if ([tenant.b2b_code isEqualToString:tenantCodeString]) {
                self.tenantNameTextField.text = tenant.name;
                self.tenantCode = tenant.b2b_code;
                self.isTenantCodeFound = YES;
            }
        }
        if (self.isTenantCodeFound == NO) {
            self.tenantNameTextField.text = @"";
            [self showErrorMessage];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showErrorMessage {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Tenant Code cannot be found"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
}

- (void)showErrorMessage2 {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Do Number cannot be found"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
}


- (IBAction)scanTenant:(id)sender {
    self.isScanTenantCode = YES;
    [self performSegueWithIdentifier: @"ScanView" sender: self];
}

- (IBAction)next:(id)sender {
    if ([self.tenantNameTextField.text length] > 0) {
        [self performSegueWithIdentifier:@"toDeliveryTable" sender:sender];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                       message:@"Please ensure that you have scan the tenant code"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)editTenantNameTextField:(id)sender {
    NSString * match = _tenantNameTextField.text;
    NSMutableArray *listFiles = [[NSMutableArray alloc]  init];
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:
                               @"SELF CONTAINS[cd] %@", match];
    listFiles = [NSMutableArray arrayWithArray:[self.tenantListArray
                                                filteredArrayUsingPredicate:sPredicate]];
    // Now if you want to sort search results Array
    //Sorting NSArray having NSString as objects
    self.searchTenantNameArray = [[NSMutableArray alloc]initWithArray: [listFiles
                                                                        sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    [_tableView reloadData];
    
}

- (void)scanBarcode:(id)sender {
    [self performSegueWithIdentifier: @"ScanView" sender: self];
}

#pragma mark - Storyboard Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ScanView"])
    {
        UINavigationController *navigationController =
        segue.destinationViewController;
        BarcodeScanViewController
        *ViewController =
        [[navigationController viewControllers]
         objectAtIndex:0];
        ViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"toDeliveryTable"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        DeliveryTableViewController *deliveryTableVC = [[navigationController viewControllers] objectAtIndex:0];
        
        deliveryTableVC.tenantCodeString = self.tenantCode;
    }
    else if ([[segue identifier] isEqualToString:@"toDetail"])
    {
        // Get reference to the destination view controller
        UINavigationController *navigationController = segue.destinationViewController;
        DetailViewController *detailVC = [[navigationController viewControllers] objectAtIndex:0];
        
        Order *order = self.orderListArray[_index];
        detailVC.order = order;
        detailVC.key = @"doDelivery";
    }
}

- (IBAction)unwindFromDetailPage:(UIStoryboardSegue *)segue {
    self.tenantNameTextField.text = @"";
}

#pragma mark - Tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.tenantNameTextField.text length] > 0) {
        return [self.searchTenantNameArray count];
    }
    return [self.tenantListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if ([self.tenantNameTextField.text length] > 0) {
        cell.textLabel.text = [self.searchTenantNameArray objectAtIndex:indexPath.row ];
    }
    else {
        cell.textLabel.text = [self.tenantListArray objectAtIndex:indexPath.row ];
    }
    
    return cell;
}

@end
