//
//  com_blumfreddav_funcAppDelegate.m
//  allforyou
//
//  Created by Rakefet Tsabari on 5/26/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "com_blumfreddav_funcAppDelegate.h"
#import "EDViewController.h"


NSString * const ADD_BUTTON_IMAGE = @"add.png";


@interface com_blumfreddav_funcAppDelegate ()

- (UIViewController *)newViewControllerForExposeController:(LIExposeController *)exposeController;

@end

@implementation com_blumfreddav_funcAppDelegate

NSCondition *_myCondition;
BOOL _someCheckIsTrue;

static int _viewControllerId = 0;
@synthesize sharedManager;
@synthesize working;
@synthesize ppp;

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)dealloc
{
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    sharedManager = [MyManager sharedManager];
    LIExposeController *exposeController = [[LIExposeController alloc] init] ;
    exposeController.exposeDelegate = self;
    exposeController.exposeDataSource = self;
    exposeController.editing = YES;
    exposeController.managedObjectContext = self.managedObjectContext ;
    exposeController.viewControllers = [NSMutableArray arrayWithObjects:
/*
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
  */
                                    
    
    
                                        
                                       nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    
    self.window.rootViewController = exposeController;
    [self.window makeKeyAndVisible];
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"allforyou" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"allforyou.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


///////////////////
/// david /////////
///////////////////

- (BOOL)canAddViewControllersForExposeController:(LIExposeController *)exposeController {
    return YES;
}

- (BOOL)exposeController:(LIExposeController *)exposeController canDeleteViewController:(UIViewController *)viewController {
    return YES;
}

#pragma mark - LIExposeControllerDataSource Methods

- (UIView *)backgroundViewForExposeController:(LIExposeController *)exposeController {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 
                                                          0, 
                                                          exposeController.view.frame.size.width, 
                                                          exposeController.view.frame.size.height)] ;
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed: @"Wood.jpg"]];
    //   UIColor *mycolor= [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:6.3];
    v.backgroundColor = background;
    return v;
}

- (void)shouldAddViewControllerForExposeController:(LIExposeController *)exposeController {
 // ici 3 3 3 popopo initlalala  
    
    
[exposeController addNewViewController:[self newViewControllerForExposeController:exposeController] 
                                  animated:YES];
}

- (UIView *)addViewForExposeController:(LIExposeController *)exposeController {
    UIView *addView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ADD_BUTTON_IMAGE]] ;
    
    _someCheckIsTrue = NO;
    _myCondition = [[NSCondition alloc] init];
    
    return addView;
}

- (UIView *)exposeController:(LIExposeController *)exposeController overlayViewForViewController:(UIViewController *)viewController {
    
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = [(UINavigationController *)viewController topViewController];
    }
    if ([viewController isKindOfClass:[EDViewController class]]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 
                                                                    0, 
                                                                    viewController.view.bounds.size.width, 
                                                                    viewController.view.bounds.size.height)] ;
        
        
        
        
        
        NSDate *currentDateTime = [NSDate date];
        
        // Instantiate a NSDateFormatter
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        // Set the dateFormatter format
        
        //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        // or this format to show day of the week Sat,11-12-2011 23:27:09
        
        [dateFormatter setDateFormat:@"EEE,MM-dd-yyyy HH:mm:ss"];
        
        // Get the date time in NSString
        
        NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
        
        sharedManager.someProperty = dateInStringFormated;
    
        // Release the dateFormatter
        
               
        
        label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        //        label.text = [@"Memo " stringByAppendingString: dateInStringFormated];//viewController.title;

        NSString * condition111 = @"NO";
        if(sharedManager.flag == condition111)
        {
          label.text =  sharedManager.label1;//viewController.title;
        }
        else 
        {
           label.text =  dateInStringFormated;//viewController.title;  
        }
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:48];
        label.adjustsFontSizeToFitWidth = YES;
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(1, 1);
        return label;
    } else {
        return nil;
    }
}

/*
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{ 
 NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
 NSString *ppp =  [[alertView textFieldAtIndex:0] text];
 
 }
 
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Click Me!"
 message:@"Fill out the text field..." 
 delegate:self 
 cancelButtonTitle:@"Cancel" 
 otherButtonTitles:@"Ok", nil];
 
 alert.alertViewStyle = UIAlertViewStylePlainTextInput;
 
 [alert show];    
 */    



- (UILabel *)exposeController:(LIExposeController *)exposeController labelForViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = [(UINavigationController *)viewController topViewController];
    }
    if ([viewController isKindOfClass:[EDViewController class]]) {
        
        working = YES;
        
        //////////////////
        
        
        
        // [_myCondition lock];
        //  [_myCondition unlock];
        
        //////////////////        
        //  while (working) {
        // sleep(0.3);
        //  }
        UILabel *label = [[UILabel alloc] init] ;
        label.backgroundColor = [UIColor clearColor];
        label.text =  @"Memo ";//viewController.title;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14];
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(1, 1);
        [label sizeToFit];
        CGRect frame = label.frame;
        frame.origin.y = 8;
        label.frame = frame;
        
        
        return label;
    } else {
        return nil;
    }
}

/**
 Optional Header View
 */
//- (UIView *)headerViewForExposeController:(LIExposeController *)exposeController {
//    UINavigationBar *headerBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 
//                                                                                    0,
//                                                                                    exposeController.view.frame.size.width,
//                                                                                    44)] autorelease];
//    UILabel *titleView = [[[UILabel alloc] init] autorelease];
//    titleView.backgroundColor = [UIColor clearColor];
//    titleView.text = NSLocalizedString(@"expose_title", @"expose_title");
//    titleView.textColor = [UIColor whiteColor];
//    titleView.shadowColor = [UIColor darkGrayColor];
//    titleView.shadowOffset = CGSizeMake(0, -0.5);
//    titleView.userInteractionEnabled = YES;
//    titleView.font = [UIFont boldSystemFontOfSize:20];
//    [titleView sizeToFit];
//    UITapGestureRecognizer *exposeGesture = [[[UITapGestureRecognizer alloc] initWithTarget:exposeController action:@selector(toggleExpose)] autorelease];
//    [titleView addGestureRecognizer:exposeGesture];
//    UINavigationItem *navItem = [[[UINavigationItem alloc] init] autorelease];
//    navItem.titleView = titleView;
//    headerBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        headerBar.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
//    }
//    headerBar.items = [NSArray arrayWithObject:navItem];
//    return headerBar;
//}

/**
 Optional Footer View
 */
//- (UIView *)footerViewForExposeController:(LIExposeController *)exposeController {
//    UIToolbar *toolBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0,
//                                                                      0,
//                                                                      exposeController.view.frame.size.width,
//                                                                      44)] autorelease];
//    toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        toolBar.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
//    }
//    toolBar.items = [NSArray arrayWithObject:exposeController.editButtonItem];
//    return toolBar;
//}

#pragma mark - Helper Methods

- (UIViewController *)newViewControllerForExposeController:(LIExposeController *)exposeController {
    UIViewController *vc = [[EDViewController alloc] init] ;
    vc.title = [NSString stringWithFormat:NSLocalizedString(@"view_title_format_string", @"view_title_format_string"), _viewControllerId];
    _viewControllerId++;
    return [[UINavigationController alloc] initWithRootViewController:vc] ;
}

#pragma mark - UIApplicationDelegate Methods
/*
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    LIExposeController *exposeController = [[[LIExposeController alloc] init] autorelease];
    exposeController.exposeDelegate = self;
    exposeController.exposeDataSource = self;
    exposeController.editing = YES;
    
    exposeController.viewControllers = [NSMutableArray arrayWithObjects:
                                        
                                        nil];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    self.window.rootViewController = exposeController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}
*/

@end
