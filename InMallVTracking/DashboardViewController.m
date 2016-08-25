//
//  DashboardViewController.m
//  InMallVTracking
//
//  Created by Liyana Roslie on 13/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import "DashboardViewController.h"
#import "LoginViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    LoginViewController *loginView = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    
//    [self presentViewController:loginView
//                       animated:YES
//                     completion:nil];
    
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

- (void)viewWillAppear:(BOOL)animated
{
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
//    self.navigationItem.leftBarButtonItem = backButton;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.nameLabel.text = [defaults objectForKey:@"user_name"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd-MMM-yyyy";
    self.dateLabel.text = [formatter stringFromDate:[NSDate date]];
}

//- (IBAction)Back
//{
//    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
