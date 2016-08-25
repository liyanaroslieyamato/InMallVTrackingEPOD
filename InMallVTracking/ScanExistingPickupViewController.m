//
//  ScanExistingPickupViewController.m
//  InMallVTracking
//
//  Created by Liyana Roslie on 24/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "ScanExistingPickupViewController.h"
#import "Order.h"
#import "DetailViewController.h"

@interface ScanExistingPickupViewController ()

@end

@implementation ScanExistingPickupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isDOFound = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self get_allOrders];
    
    if (self.isDOFound == YES) {
        [self.navigationController popViewControllerAnimated:YES];
        [self performSegueWithIdentifier: @"toDetail" sender: self];
        self.isDOFound = NO;
    }
}

- (void) get_allOrders {
    
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
                                                  self.allOrderArray = mappingResult.array;
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
    
}

- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
}

- (IBAction)scanDO:(id)sender {
    [self performSegueWithIdentifier: @"ScanView" sender: self];
}

#pragma mark - BarcodeScanViewControllerDelegate

- (void)BarcodeScanViewControllerDidCancel:(BarcodeScanViewController *)controller
{
    NSLog(@"cancel---2");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)BarcodeScanViewController:(BarcodeScanViewController *)controller scanDone:(NSString *)scanResult
{
    
    NSLog(@"Scanned code %@", scanResult);
    for (Order *order in _allOrderArray) {
        if ([order.do_number isEqualToString:scanResult]) {
            self.isDOFound = YES;
            NSUInteger arrayIndex = [_allOrderArray indexOfObject: order];
            _index = (int) arrayIndex;
        }
    }
    if (self.isDOFound == NO) {
        [self showErrorMessage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showErrorMessage {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"DO cannot be found"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
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
    else if ([[segue identifier] isEqualToString:@"toDetail"])
    {
        // Get reference to the destination view controller
        UINavigationController *navigationController = segue.destinationViewController;
        DetailViewController *detailVC = [[navigationController viewControllers] objectAtIndex:0];
        
        Order *order = self.allOrderArray[_index];
        detailVC.order = order;
        detailVC.key = @"Pickup";
        
    }

}



@end
