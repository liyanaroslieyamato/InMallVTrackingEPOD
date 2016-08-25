//
//  DeliveryTableViewController.h
//  InMallVTracking
//
//  Created by Liyana Roslie on 13/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryTableViewController : UITableViewController

@property NSArray *deliveryListArray;
@property NSArray *orderListArray;

@property NSString *tenantCodeString;

@property int index;

@end
