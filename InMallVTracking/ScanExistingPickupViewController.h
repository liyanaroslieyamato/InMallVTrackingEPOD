//
//  ScanExistingPickupViewController.h
//  InMallVTracking
//
//  Created by Liyana Roslie on 24/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BarcodeScanViewController.h"

@interface ScanExistingPickupViewController : UIViewController <BarcodeScanViewControllerDelegate>

- (IBAction)scanDO:(id)sender;

@property NSArray * allOrderArray;

@property BOOL isDOFound;

@property int index;

@end
