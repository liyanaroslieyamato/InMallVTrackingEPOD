//
//  ViewController.m
//  InMallVTracking
//
//  Created by Liyana Roslie on 13/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

#import <RestKit/RestKit.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isScanned = NO;
    [self displayVersion];
}

- (void)displayVersion
{
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString * versionBuildString = [NSString stringWithFormat:@"Version: %@ (%@)", appVersionString, appBuildString];
    
    self.versionLabel.text = versionBuildString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    if (self.isScanned == YES) {
        [self check_id];
    }
}

#pragma Storyboard prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ScanView"])
    {
        UINavigationController *navigationController =
        segue.destinationViewController;
        BarcodeScanViewController
        *ViewController =
        [[navigationController viewControllers]
         objectAtIndex:0];
        ViewController.delegate = self;
    }
}

#pragma mark - BarcodeScanViewControllerDelegate

- (void)BarcodeScanViewControllerDidCancel:(BarcodeScanViewController *)controller
{
    NSLog(@"cancel---2");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)BarcodeScanViewController:(BarcodeScanViewController *)controller scanDone:(NSString *)scanResult
{
    NSLog(@"done---2");
    self.scanned_text = scanResult;
    self.isScanned = YES;
    [self check_id];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)check_id
{
    [self.activityIndicatorView startAnimating];
    
    // setup object mappings
    RKObjectMapping *UserMapping = [RKObjectMapping mappingForClass:[User class]];
    [UserMapping addAttributeMappingsFromDictionary:@{ @"handset_user_id": @"handset_user_id",
                                                       @"work_id": @"work_id",
                                                       @"name": @"name",
                                                       @"status": @"status"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:UserMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/hpapi/check_id.json"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSDictionary *queryParams = @{@"work_id" : self.scanned_text};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/hpapi/check_id.json"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  _users = mappingResult.array;
                                                  [self.activityIndicatorView stopAnimating];
                                                  [self loginSuccess];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:@"Server Unavailble. Please contact the admin."
                                                                                                 delegate:self
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                              }];
}

- (void)loginSuccess {
    if (_users.count == 1) {
        User *user = _users[0];
        if ([user.status isEqualToString:@"exist"]) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:user.name forKey:@"user_name"];
            [defaults setObject:user.work_id forKey:@"user_work_id"];
            [defaults setObject:user.handset_user_id forKey:@"handset_user_id"];
            [defaults synchronize];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:user.name
                                                            message:@"Login Successfully!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            alert.tag = 1;
            
        }else if ([user.status isEqualToString:@"none"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Sorry this account can't access!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            alert.tag = 2;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == [alertView cancelButtonIndex]) {
        if (alertView.tag == 1) {
            [self performSegueWithIdentifier: @"goToDashboard" sender: self];
        }
        if (alertView.tag == 2) {
            [self dismissViewControllerAnimated:YES completion:nil];
            self.isScanned = NO;
        }
    }
}

- (IBAction)unwindFromDashboard:(UIStoryboardSegue *)segue {
    self.isScanned = NO;
}

@end
