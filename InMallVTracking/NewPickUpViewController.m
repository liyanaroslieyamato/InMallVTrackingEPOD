//
//  PickUpViewController.m
//  InMallVTracking
//
//  Created by Liyana Roslie on 13/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>

#import "NewPickUpViewController.h"
#import "StatusUpdateResponse.h"
#import "LSP.h"
#import "Tenant.h"

@interface NewPickUpViewController ()

@end

@implementation NewPickUpViewController {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //adjust scrollview position
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //initialize location services
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
    //initialize all parameter variables to null
    _latitude = @"";
    _longitude = @"";
    _location = @"";
    
    _lspCode = @"";
    _tenantCode = @"";
    
    _doNumber = @"";
    _lspName = @"";
    _lspAddr = @"";
    _lspRemarks = @"";
    _tenantName = @"";
    _tenantAddr = @"";
    _tenantRemarks = @"";
    _orderType = @"";
    
    _statusID = @"";
    _responsible = @"";
    _codAmt = @"";
    _remarks = @"";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self download_lspInfo];
}

- (void) download_lspInfo {
    
    RKObjectMapping *LSPMapping = [RKObjectMapping mappingForClass:[LSP class]];
    [LSPMapping addAttributeMappingsFromDictionary:@{@"id" : @"principal_id",
                                                     @"name" : @"name",
                                                     @"address" : @"address",
                                                     @"principal_code" : @"principal_code",
                                                     @"postcode" : @"postal_code",
                                                     @"unit_no" : @"unit_num",
                                                     @"remarks" : @"remarks",
                                                     @"industry_id" : @"industry_id"
                                                     }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:LSPMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/hpapi/principals.json"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/hpapi/principals.json"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.lspArray = mappingResult.array;
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
    
}

- (void) download_tenantInfo:(NSString *)code {
    
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
                                            pathPattern:@"/hpapi/shops_by_principal.json"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor2];
    
    NSDictionary *params = @{@"principal_code" : code};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/hpapi/shops_by_principal.json"
                                           parameters:params
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.tenantArray = mappingResult.array;
                                                  [self displayTenantInfo];
                                                  
//                                                  for (Tenant * tenant in self.tenantArray)
//                                                  {
//                                                      NSLog(@"Test Tenant Name %@ ", tenant.name);
//                                                  }
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
}

- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
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

- (IBAction)selectOrderType:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please select an order type"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Prepaid"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed Prepaid");
                                                              _orderLabel.text=@"Prepaid";
                                                              _orderType = @"1";
                                                          }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"COD"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               NSLog(@"You pressed COD");
                                                               _orderLabel.text=@"COD";
                                                               _orderType = @"2";
                                                               [self enterCODAmt];
                                                           }]; // 3
//    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Exchange"
//                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                              NSLog(@"You pressed Exchange");
//                                                              _orderLabel.text=@"Exchange";
//                                                              _orderType = @"3";
//                                                          }]; // 4
    
    [alert addAction:firstAction]; // 5
    [alert addAction:secondAction]; // 6
//    [alert addAction:thirdAction]; // 7
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
}

- (IBAction)scanLSPCode:(id)sender {
    [self performSegueWithIdentifier: @"ScanView" sender: self];
}

- (IBAction)scanTenantCode:(id)sender {
    [self performSegueWithIdentifier: @"ScanView" sender: self];
}

- (IBAction)scanDONumber:(id)sender {
    [self performSegueWithIdentifier: @"ScanView" sender: self];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submit:(id)sender {
    
    if ([_lspNameTextField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please ensure that you have successfully scanned the LSP Code."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    if ([_tenantNameTextField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please ensure that you have successfully scanned the Tenant Code."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([_doNumberTextField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please ensure that you have successfully scanned the DO Number."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    if ([_orderType length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please ensure that you have selected the order type"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //check if order type entered is COD
    if ([_orderType isEqualToString:@"2"]) {
        if ([_codAmt length] == 0) {
            [self displayCODAmtErrorMsg];
            [self enterCODAmt];
            return;
        }
    }
    
    [self uploadOrderToServer:2];
    
}

- (void) displayCODAmtErrorMsg {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing COD Amount"
                                                    message:@"Please enter the COD amount"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void) uploadOrderToServer:(NSInteger)StatusID {
    
    RKObjectMapping *UserMapping = [RKObjectMapping mappingForClass:[StatusUpdateResponse class]];
    [UserMapping addAttributeMappingsFromDictionary:@{ @"status": @"status" }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:UserMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/hpapi/create_order.json"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _responsible = [defaults objectForKey:@"handset_user_id"];
    _statusID = [NSString stringWithFormat:@"%ld",(long)StatusID];
    
    NSDictionary *queryParams = @{@"do_number" : _doNumber,
                                  @"sender" : _lspCode,
                                  @"receiver" : _tenantCode,
                                  @"order_type" : _orderType,
                                  @"cod_amount" : _codAmt,
                                  @"responsible" : _responsible,
                                  @"status_id" : _statusID,
                                  @"longitude" : _longitude,
                                  @"latitude" : _latitude,
                                  @"location" : _location,
                                  @"remarks" : _remarks,
                                  };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/hpapi/create_order.json"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  _responseStatus = mappingResult.array;
                                                  
                                                  [self showSuccess];
                                                  
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Nil parameter");
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
}

- (void)showSuccess
{
    if (_responseStatus.count == 1) {
        StatusUpdateResponse *status = _responseStatus[0];
        if ([status.status isEqualToString:@"1"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"The DO is submitted. Please proceed to scan the next DO Number."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            //reset do number, remarks and order type values
            _doNumber = @"";
            _doNumberTextField.text = @"";
            _remarks = @"";
            _remarksTextField.text = @"";
            _orderType = @"";
            _orderLabel.text = @"";
            
            //[self.navigationController popViewControllerAnimated:YES];
            
        }else if ([status.status isEqualToString:@"2"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Duplicate DO Number. Please try again!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
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


- (IBAction)editDoNumber:(id)sender {
    _doNumber = _doNumberTextField.text;
    NSLog(@"DO number now is : %@", _doNumber);
}

- (IBAction)editRemarks:(id)sender {
    _remarks = _remarksTextField.text;
    NSLog(@"Remarks now is : %@", _remarks);
}

- (void) enterCODAmt {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"COD Amount"
                                  message:@"Enter User Credentials"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   //Do Some action here
                                                   _codAmt = alert.textFields.firstObject.text;
                                                   
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Input COD Amount";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
    //    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        _longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        //NSLog(@"Longitude is %@ and latitude is %@", _longitude, _latitude);
    }
    
    // Reverse Geocoding
    //    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            _location = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                         placemark.subThoroughfare, placemark.thoroughfare,
                         placemark.postalCode, placemark.locality,
                         placemark.administrativeArea,
                         placemark.country];
            //            NSLog(@"Location is %@", _location);
        } else {
            //            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

#pragma mark - BarcodeScanViewControllerDelegate

- (void)BarcodeScanViewControllerDidCancel:(BarcodeScanViewController *)controller
{
    NSLog(@"cancel---2");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)BarcodeScanViewController:(BarcodeScanViewController *)controller scanDone:(NSString *)scanResult
{
    //Scan first time for LSP code
    if ([scanResult hasPrefix:@"IMLSPB"]) {
        _lspCode = scanResult;
        NSLog(@"LSP Code: %@", _lspCode);
        
        //        _lspName = @"Tampines Mall";
        //        _lspAddr = @"4 Tampines Central 5, 529510";
        //        _lspRemarks = @"None";
        for (LSP * lsp in _lspArray) {
            if ([lsp.principal_code isEqualToString:_lspCode]) {
                _lspName = lsp.name;
                _lspAddr = [lsp.address stringByAppendingString:@" "];
                _lspAddr = [_lspAddr stringByAppendingString:lsp.unit_num];
                _lspAddr = [_lspAddr stringByAppendingString:@" "];
                _lspAddr = [_lspAddr stringByAppendingString:lsp.postal_code];
                _lspRemarks = lsp.remarks;
            }
        }
        
        _lspNameTextField.text = _lspName;
        _lspAddrTextView.text = _lspAddr;
        _lspRemarksTextField.text = _lspRemarks;
    }
    
    //Scan second time for tenant code
    else if ([_lspCode length] > 0 && [scanResult hasPrefix:@"IMTENRB"]){
        _tenantCode = scanResult;
        NSLog(@"Tenant Code: %@", _tenantCode);
        [self download_tenantInfo:_lspCode];
        
        //                _tenantName = @"Aldo";
        //                _tenantAddr = @"4 Tampines Central 5, 01-08/09 Tampines Mall, 529510";
        //                _tenantRemarks = @"Aldo specialize in footwear";
        //        for (Tenant * tenant in _tenantArray) {
        //            if ([tenant.shop_code isEqualToString:_tenantCode]) {
        //                _tenantName = tenant.name;
        //                _tenantAddr = [tenant.address stringByAppendingString:@" "];
        //                _tenantAddr = [_tenantAddr stringByAppendingString:tenant.unit_num];
        //                _tenantAddr = [_tenantAddr stringByAppendingString:@" "];
        //                _tenantAddr = [_tenantAddr stringByAppendingString:tenant.postal_code];
        //                _tenantRemarks = tenant.remarks;
        //            }
        //        }
        //
        //        _tenantNameTextField.text = _tenantName;
        //        _tenantAddrTextView.text = _tenantAddr;
        //        _tenantRemarksTextField.text = _tenantRemarks;
    }
    
    //Scan third time for DO Number
    else if ([_tenantCode length] > 0) {
        _doNumber = scanResult;
        _doNumberTextField.text = _doNumber;
    }
    
    //Invalid Barcode
    else {
        NSLog(@"Invalid Barcode");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Scan Error"
                                                        message:@"There is some problem with the Barcode. Please take a screenshot and contact admin"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) displayTenantInfo {
    for (Tenant * tenant in _tenantArray) {
        if ([tenant.shop_code isEqualToString:_tenantCode]) {
            _tenantName = tenant.name;
            _tenantAddr = [tenant.address stringByAppendingString:@" "];
            _tenantAddr = [_tenantAddr stringByAppendingString:tenant.unit_num];
            _tenantAddr = [_tenantAddr stringByAppendingString:@" "];
            _tenantAddr = [_tenantAddr stringByAppendingString:tenant.postal_code];
            _tenantRemarks = tenant.remarks;
        }
    }
    _tenantNameTextField.text = _tenantName;
    _tenantAddrTextView.text = _tenantAddr;
    _tenantRemarksTextField.text = _tenantRemarks;
    
}

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
}

@end
