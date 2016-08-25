//
//  ExchangeViewController.h
//  InMallVTracking
//
//  Created by Liyana Roslie on 25/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Order.h"
//#import "OrderBaseOnTenantCode.h"
#import "BarcodeScanViewController.h"

@interface ExchangeViewController : UIViewController <BarcodeScanViewControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) Order *order;
//@property (strong, nonatomic) OrderBaseOnTenantCode *deliveryOrder;

@property BOOL isValidExchangeCode;

@property NSString * exchangeCode;
@property NSString * remarks;
@property NSString * longitude;
@property NSString * latitude;
@property NSString * location;
@property NSString * reason;
@property NSString * web_id;

@property (nonatomic, strong) NSArray *responseStatus;

@property (weak, nonatomic) IBOutlet UILabel *doNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *exchangeCodeTextField;
@property (weak, nonatomic) IBOutlet UITextView *remarksTextView;

- (IBAction)scan:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)submit:(id)sender;
- (IBAction)editExchangeCode:(id)sender;

@end
