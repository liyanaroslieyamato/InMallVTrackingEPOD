//
//  SignPicViewController.h
//  InMallVTracking
//
//  Created by Liyana Roslie on 25/8/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignViewController.h"

@interface SignPicViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,CaptureSignatureViewDelegate, UIImagePickerControllerDelegate>

- (IBAction)sign:(id)sender;
- (IBAction)takePic:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *imageCollection;
@property (strong, nonatomic) IBOutlet UITextView *remarksTextView;
@property (nonatomic, strong) NSDictionary *detailDataDict;

@end
