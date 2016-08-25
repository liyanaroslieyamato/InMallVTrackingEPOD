//
//  SignViewController.h
//  InMallVTracking
//
//  Created by Liyana Roslie on 25/8/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UviSignatureView.h"

// Protocol definition starts here
@protocol CaptureSignatureViewDelegate <NSObject>
@required
- (void)processCompleted:(UIImage*)signImage remark:(NSString *)remark;
@end

@interface SignViewController : UIViewController <UIActionSheetDelegate>

@property (nonatomic, weak) id <CaptureSignatureViewDelegate> delegate;

-(void)startSampleProcess:(NSString*)text;

- (IBAction)save:(id)sender;
@property (strong, nonatomic) IBOutlet UviSignatureView *signatureView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;


@property (nonatomic, strong) NSDictionary *signPicDataDict;

@end
