//
//  ExchangeViewController.m
//  InMallVTracking
//
//  Created by Liyana Roslie on 25/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "ExchangeViewController.h"
#import "DeliveryScanViewController.h"
#import "StatusUpdateResponse.h"

@interface ExchangeViewController ()

@end

@implementation ExchangeViewController {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isValidExchangeCode = NO;
    
    self.doNumberLabel.text = self.order.do_number;
    
    self.web_id = self.order.web_id;
    
    self.remarksTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.remarksTextView.layer.borderWidth = 1.0;
    self.remarksTextView.layer.cornerRadius = 7;
    
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
}

- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
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
    if ([scanResult hasPrefix:@"YE"]) {
        self.isValidExchangeCode = YES;
        self.exchangeCode = scanResult;
        self.exchangeCodeTextField.text = self.exchangeCode;
    }
    if (self.isValidExchangeCode == NO) {
        [self showErrorMessage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showErrorMessage {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"This is not a valid exchange code. Please scan again."
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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
//    else if ([segue.identifier isEqualToString:@"backToScanPage"]) {
//        
//        UINavigationController *navigationController =segue.destinationViewController;
//        DeliveryScanViewController *destViewController =  [[navigationController viewControllers]objectAtIndex:0];
//        
//        destViewController.tenantNameTextField.text = @"";
//        
//    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.exchangeCodeTextField resignFirstResponder];
        [self.remarksTextView resignFirstResponder];
    }
}

- (IBAction)scan:(id)sender {
    [self performSegueWithIdentifier: @"ScanView" sender: self];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submit:(id)sender {
    if ([self.exchangeCode length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please ensure that you have successfully scanned the Exchange Code."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    self.remarks = self.remarksTextView.text;
    
    [self UpdateStatusWithServer:11];
}

- (IBAction)editExchangeCode:(id)sender {
    self.exchangeCode = self.exchangeCodeTextField.text;
    NSLog(@"Edited Exchange Code : %@", self.exchangeCode);
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
    if ([self.exchangeCode length] == 0) {
        self.exchangeCode=@"";
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
                                  @"exchange_code": self.exchangeCode,
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
             [self performSegueWithIdentifier:@"scanPage" sender:self];
        }
    }
//    else {
//        if (alertView.tag == 1) {
//            [self UpdateStatusWithServer:3];
//        }
//    }
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
