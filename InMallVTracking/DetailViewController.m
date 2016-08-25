//
//  DetailViewController.m
//  InMallVTracking
//
//  Created by Liyana Roslie on 13/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "DetailViewController.h"
#import "Order.h"
#import "StatusUpdateResponse.h"
#import "ExchangeViewController.h"
#import "DeliveryScanViewController.h"
#import "SignPicViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([self.key isEqualToString:@"Pickup"]) {
        _deliveredBtnOutlet.hidden = YES;
        _UndeliveredBtnOutlet.hidden = YES;
        //_exchangeBtnOutlet.hidden = YES;
    }
    
    if ([self.key isEqualToString:@"Delivery"] || [self.key isEqualToString:@"doDelivery"]) {
        _pickupBtnOutlet.hidden = YES;
    }
    
    if ((self.order && [self.key isEqualToString:@"Pickup"]) || (self.order && [self.key isEqualToString:@"doDelivery"])) {
        _doNumTextField.text = _order.do_number;
        _lspNameTextField.text = _order.sender_name;
        NSString *lspAddress  = [_order.sender_addr stringByAppendingString:@" "];
        lspAddress = [lspAddress stringByAppendingString: _order.sender_unit_no];
        lspAddress = [lspAddress stringByAppendingString:@" "];
        lspAddress = [lspAddress stringByAppendingString:_order.sender_postcode];
        _lspAddressTextView.text = lspAddress;
        _lspContactTextField.text = _order.sender_contact_no;
        _tenantNameTextField.text = _order.receiver_name;
        NSString *tenantAddress = [_order.receiver_addr stringByAppendingString:@" "];
        tenantAddress = [tenantAddress stringByAppendingString:_order.receiver_unit_no];
        tenantAddress = [tenantAddress stringByAppendingString:@" "];
        tenantAddress = [tenantAddress stringByAppendingString:_order.receiver_postcode];
        _tenantAddressTextView.text = tenantAddress;
        _tenantContactTextField.text = _order.receiver_contact_no;
        _orderTypeTextField.text = _order.order_type;
        _codAmtTextField.text = _order.cod_amount;
        _latestStatusTextField.text = _order.latest_status;
        _exchangeCodeTextField.text = _order.exchange_code;
        _paymentTermTextField.text = _order.payment_term;
        
        self.web_id = _order.web_id;
    }
    
    if (self.deliveryOrder && [self.key isEqualToString:@"Delivery"]) {
        _doNumTextField.text = _deliveryOrder.do_number;
        _lspNameTextField.text = _deliveryOrder.principal_name;
        //        if ([_deliveryOrder.order_type isEqualToString:@"1"]) {
        //            _orderTypeTextField.text = @"Prepaid";
        //        }
        //        else if ([_deliveryOrder.order_type isEqualToString:@"2"]) {
        //            _orderTypeTextField.text = @"COD";
        //        }
        //        else if ([_deliveryOrder.order_type isEqualToString:@"3"]) {
        //            _orderTypeTextField.text = @"Exchange";
        //        }
        _orderTypeTextField.text = _deliveryOrder.order_type;
        _codAmtTextField.text = _deliveryOrder.cod_amount;
        _latestStatusTextField.text = _deliveryOrder.latest_status;
        _exchangeCodeTextField.text = _deliveryOrder.exchange_code;
        _paymentTermTextField.text = _deliveryOrder.payment_term;
        
        self.web_id = _deliveryOrder.shop_id;
        //        NSLog(@"Web id : %@", self.web_id);
        
    }
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Pic Detail" style:UIBarButtonItemStyleBordered target:self action:@selector(AddPicDetail:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
}

- (IBAction)AddPicDetail:(id)sender {
    [self performSegueWithIdentifier:@"signPicSegue" sender:sender];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toExchange"]) {
        UINavigationController *navigationController =segue.destinationViewController;
        ExchangeViewController *destViewController =  [[navigationController viewControllers]objectAtIndex:0];
        
        //destViewController.doNumber = self.doNumTextField.text;
        destViewController.order = self.order;
    }
    else if ([[segue identifier] isEqualToString:@"signPicSegue"])
    {
        // Get reference to the destination view controller
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        SignPicViewController *signPicViewController = [[navController viewControllers]objectAtIndex:0];
        signPicViewController.detailDataDict = @{@"entity_id":self.web_id, @"entity_type":@"border"};
        
    }
//    else if ([segue.identifier isEqualToString:@"backToScanPage"]) {
//        
//        UINavigationController *navigationController =segue.destinationViewController;
//        DeliveryScanViewController *destViewController =  [[navigationController viewControllers]objectAtIndex:0];
//        DeliveryScanViewController *vc = [segue destinationViewController];
//        vc.tenantNameTextField.text = @"";
//    }
}

- (IBAction)hideKeyboard1:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)hideKeyboard2:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)hideKeyboard3:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)hideKeyboard4:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)hideKeyboard5:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)hideKeyboard6:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)hideKeyboard7:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)hideKeyboard8:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)hideKeyboard9:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)hideKeyboard10:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)hideKeyboard11:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)hideKeyboard12:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)delivered:(id)sender {
    if (([self.order.order_type isEqualToString:@"Exchange"] && [self.order.exchange_code length] == 0 )|| ([self.deliveryOrder.order_type isEqualToString:@"Exchange"] && [self.deliveryOrder.exchange_code length] == 0)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                       message:@"This order can't be delivered without exchange"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Confirm Delivery Status"
                                                       message:@"Please press OK to confirm that you have delivered the item"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK", nil];
        [alert show];
        alert.tag = 1;
    }
}

- (IBAction)undelivered:(id)sender {
    if ([self.remarksTextFeild.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                       message:@"Please enter the remarks for this undelivered status"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else {
        //self.remarks = self.remarksTextFeild.text;
        [self UpdateStatusWithServer:7];
    }
    
}

- (IBAction)exchange:(id)sender {
    if ([_deliveryOrder.order_type isEqualToString:@"Exchange"] || [_order.order_type isEqualToString:@"Exchange"]) {
        [self performSegueWithIdentifier: @"toExchange" sender: self];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                       message:@"This is not an Exchange item"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)pickup:(id)sender {
    [self UpdateStatusWithServer:2];
}

//pragma mark - Update Status to Server

- (void)UpdateStatusWithServer:(NSInteger)StatusID{
    //Check if string is nil, if yes initialize the parameters
    if ([self.longitude length] == 0) {
        self.longitude =@"";
    }
    if ([self.latitude length] == 0) {
        self.latitude =@"";
    }
    if ([self.location length] == 0) {
        self.location=@"";
    }
    if ([self.exchange_code length] == 0) {
        self.exchange_code=@"";
    }
    if ([self.remarks length] == 0) {
        self.remarks=@"";
    }
    if ([self.reason length] == 0) {
        self.reason=@"";
    }
    if ([self.web_id length] == 0) {
        self.web_id=@"";
    }
    
    self.remarks = self.remarksTextFeild.text;
    
    //status id: 3 = delivered, undelivered = 7, exchange = 11, take job = 13
    
    RKObjectMapping *UserMapping = [RKObjectMapping mappingForClass:[StatusUpdateResponse class]];
    [UserMapping addAttributeMappingsFromDictionary:@{ @"status": @"status" }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:UserMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/hpapi/b_lswtal.json"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *queryParams = @{@"id" : self.web_id,
                                  @"status_id" : [NSString stringWithFormat:@"%ld",(long)StatusID],
                                  @"responsible" : [defaults objectForKey:@"user_work_id"],
                                  @"handset_user_id" : [defaults objectForKey:@"handset_user_id"],
                                  @"longitude" : self.longitude,
                                  @"latitude" : self.latitude,
                                  @"location": self.location,
                                  @"exchange_code": self.exchange_code,
                                  @"remarks": self.remarks,
                                  @"reason": self.reason
                                  };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/hpapi/b_lswtal.json"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.responseStatus = mappingResult.array;
                                                  [self showUpdateStatusSuccess:StatusID];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
    
}

- (void)showUpdateStatusSuccess :(NSInteger)StatusID{
    
    if (_responseStatus.count == 1) {
        StatusUpdateResponse *status = _responseStatus[0];
        if ([status.status isEqualToString:@"success"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success"
                                                           message:@"The status is updated"
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
            alert.tag = 2;
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Some error happened. Please try again!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == [alertView cancelButtonIndex]) {
        if (alertView.tag == 2) {
            if ([self.key isEqualToString:@"Pickup"]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                //[self performSegueWithIdentifier: @"backToScanPage" sender: self];
                [self performSegueWithIdentifier:@"scanPage" sender:self];
            }
        }
    }
    else {
        if (alertView.tag == 1) {
            [self UpdateStatusWithServer:3];
        }
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        _longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        //NSLog(@"Longitude is %@ and latitude is %@", _longitude, _latitude);
    }
    
    // Reverse Geocoding
    //NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            _location = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                         placemark.subThoroughfare, placemark.thoroughfare,
                         placemark.postalCode, placemark.locality,
                         placemark.administrativeArea,
                         placemark.country];
            //NSLog(@"Location is %@", _location);
        } else {
            //NSLog(@"%@", error.debugDescription);
        }
    } ];
}

@end
