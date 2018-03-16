//
//  com_blumfreddav_funcAppDelegate.h
//  allforyou
//
//  Created by Rakefet Tsabari on 5/26/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIExposeController.h"
#import "MyManager.h"

@interface com_blumfreddav_funcAppDelegate : UIResponder <UIApplicationDelegate, LIExposeControllerDelegate, LIExposeControllerDataSource>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MyManager *sharedManager;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSString *ppp;
@property (nonatomic, assign) BOOL working;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

