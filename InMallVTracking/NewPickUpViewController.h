//
//  PickUpViewController.h
//  InMallVTracking
//
//  Created by Liyana Roslie on 13/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "BarcodeScanViewController.h"

@interface NewPickUpViewController : UIViewController <UIActionSheetDelegate, CLLocationManagerDelegate, BarcodeScanViewControllerDelegate>

- (IBAction)hideKeyboard1:(id)sender;
- (IBAction)hideKeyboard2:(id)sender;
- (IBAction)hideKeyboard3:(id)sender;
- (IBAction)hideKeyboard4:(id)sender;
- (IBAction)hideKeyboard5:(id)sender;
- (IBAction)hideKeyboard6:(id)sender;
- (IBAction)hideKeyboard7:(id)sender;

- (IBAction)selectOrderType:(id)sender;

- (IBAction)scanLSPCode:(id)sender;
- (IBAction)scanTenantCode:(id)sender;
- (IBAction)scanDONumber:(id)sender;

- (IBAction)cancel:(id)sender;
- (IBAction)submit:(id)sender;

- (IBAction)editDoNumber:(id)sender;
- (IBAction)editRemarks:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *doNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *lspNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *lspAddrTextView;
@property (weak, nonatomic) IBOutlet UITextField *lspRemarksTextField;
@property (weak, nonatomic) IBOutlet UITextField *tenantNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *tenantAddrTextView;
@property (weak, nonatomic) IBOutlet UITextField *tenantRemarksTextField;
@property (weak, nonatomic) IBOutlet UITextField *remarksTextField;

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) NSString *lspCode;
@property (nonatomic, strong) NSString *tenantCode;

@property (nonatomic, strong) NSString *doNumber;
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, strong) NSString *statusID;
@property (nonatomic, strong) NSString *responsible;
@property (nonatomic, strong) NSString *codAmt;
@property (nonatomic, strong) NSString *remarks;

@property (nonatomic, strong) NSString *lspName;
@property (nonatomic, strong) NSString *lspAddr;
@property (nonatomic, strong) NSString *lspRemarks;

@property (nonatomic, strong) NSString *tenantName;
@property (nonatomic, strong) NSString *tenantAddr;
@property (nonatomic, strong) NSString *tenantRemarks;

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;

@property (nonatomic, strong) NSArray *lspArray;
@property (nonatomic, strong) NSArray *tenantArray;
@property (nonatomic, strong) NSArray *responseStatus;

@end
