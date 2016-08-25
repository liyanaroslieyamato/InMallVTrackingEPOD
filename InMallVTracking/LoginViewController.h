//
//  ViewController.h
//  InMallVTracking
//
//  Created by Liyana Roslie on 13/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RSBarcodes/RSBarcodes.h>

#import "BarcodeScanViewController.h"

@interface LoginViewController : UIViewController<BarcodeScanViewControllerDelegate>
{
    RSScannerViewController *scanner;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction)login:(id)sender;

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSString *scanned_text;
@property BOOL isScanned;

@end

