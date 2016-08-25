//
//  SignViewController.m
//  InMallVTracking
//
//  Created by Liyana Roslie on 25/8/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import "SignViewController.h"
#import "UploadImageResponse.h"

#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>

@interface SignViewController ()

@end

@implementation SignViewController

NSString *_entity_id;
NSString *_entity_type;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.signatureView.layer.borderColor = [UIColor blackColor].CGColor;
    self.signatureView.layer.borderWidth = 1.0f;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.nameTextField resignFirstResponder];
    }
}

- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _entity_id = [self.signPicDataDict objectForKey:@"entity_id"];
    _entity_type = [self.signPicDataDict objectForKey:@"entity_type"];
    
    NSLog(@"The detail remark is %@", _entity_id);
    NSLog(@"The signPic remark is %@", _entity_type);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startSampleProcess:(NSString*)text {
    UIImage *captureImage = [self.signatureView signatureImage:CGPointMake(self.signatureView.frame.origin.x+10 , self.signatureView.frame.size.height-25) text:@""];
    //UIImageWriteToSavedPhotosAlbum(captureImage, nil, nil, nil);
    [self.delegate processCompleted:captureImage remark:text];
}

- (IBAction)save:(id)sender {
    if ([self.nameTextField hasText]) {
        [self.signatureView captureSignature];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *signedDate  = [dateFormatter stringFromDate:[NSDate date]];
        [self startSampleProcess: self.nameTextField.text];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Signature and other details could not be saved.Please ensure that signature and name field are not empty."  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

- (IBAction)reset:(id)sender {
    [self.signatureView erase];
}

@end
