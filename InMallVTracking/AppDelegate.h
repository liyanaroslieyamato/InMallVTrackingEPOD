//
//  AppDelegate.h
//  InMallVTracking
//
//  Created by Liyana Roslie on 13/5/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>
#import "GlobalHelp.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (retain) NSURL *baseURL;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

