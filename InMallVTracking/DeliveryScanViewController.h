//
//  DeliveryScanViewController.h
//  InMallVTracking
//
//  Created by Liyana Roslie on 13/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RSBarcodes/RSBarcodes.h>

#import "BarcodeScanViewController.h"

@interface DeliveryScanViewController : UIViewController <BarcodeScanViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    RSScannerViewController *scanner;
}

@property NSString * tenantCode;

@property int index;

@property BOOL isScanTenantCode;
@property BOOL isTenantCodeFound;
@property BOOL isDONumberFound;

@property NSMutableArray *tenantListArray;
@property NSMutableArray *orderListArray;
@property NSMutableArray *searchTenantNameArray;

@property (weak, nonatomic) IBOutlet UIButton *scanTenantBtnOutlet;
@property (weak, nonatomic) IBOutlet UITextField *tenantNameTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)scanTenant:(id)sender;
- (IBAction)next:(id)sender;

- (IBAction)editTenantNameTextField:(id)sender;

@end
