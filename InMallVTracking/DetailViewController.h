//
//  DetailViewController.h
//  InMallVTracking
//
//  Created by Liyana Roslie on 13/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Order.h"
#import "OrderBaseOnTenantCode.h"

@interface DetailViewController : UIViewController <CLLocationManagerDelegate>

- (IBAction)hideKeyboard1:(id)sender;
- (IBAction)hideKeyboard2:(id)sender;
- (IBAction)hideKeyboard3:(id)sender;
- (IBAction)hideKeyboard4:(id)sender;
- (IBAction)hideKeyboard5:(id)sender;
- (IBAction)hideKeyboard6:(id)sender;
- (IBAction)hideKeyboard7:(id)sender;
- (IBAction)hideKeyboard8:(id)sender;
- (IBAction)hideKeyboard9:(id)sender;
- (IBAction)hideKeyboard10:(id)sender;
- (IBAction)hideKeyboard11:(id)sender;
- (IBAction)hideKeyboard12:(id)sender;
- (IBAction)delivered:(id)sender;
- (IBAction)undelivered:(id)sender;
//- (IBAction)exchange:(id)sender;
- (IBAction)pickup:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *doNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *remarksTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *lspNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *lspAddressTextView;
@property (weak, nonatomic) IBOutlet UITextField *lspContactTextField;
@property (weak, nonatomic) IBOutlet UITextField *tenantNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *tenantAddressTextView;
@property (weak, nonatomic) IBOutlet UITextField *tenantContactTextField;
@property (weak, nonatomic) IBOutlet UITextField *orderTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *codAmtTextField;
@property (weak, nonatomic) IBOutlet UITextField *latestStatusTextField;
@property (weak, nonatomic) IBOutlet UITextField *exchangeCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *paymentTermTextField;

@property (weak, nonatomic) IBOutlet UIButton *deliveredBtnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *UndeliveredBtnOutlet;
//@property (weak, nonatomic) IBOutlet UIButton *exchangeBtnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *pickupBtnOutlet;

@property (strong, nonatomic) Order *order;
@property (strong, nonatomic) OrderBaseOnTenantCode *deliveryOrder;

@property (nonatomic, strong) NSArray *responseStatus;

@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *exchange_code;
@property (strong, nonatomic) NSString *remarks;
@property (strong, nonatomic) NSString *reason;
@property (strong, nonatomic) NSString *web_id;
@property (strong, nonatomic) NSString *key;

@end
