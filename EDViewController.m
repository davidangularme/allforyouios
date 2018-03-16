/*
 Copyright 2012 LinkedIn, Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "EDViewController.h"
#import "EDDetailViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "GMGridView.h"
#import "OptionsViewController.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"
#import "OGActionChooser.h"
#import "JPStupidButton.h"

#define NUMBER_ITEMS_ON_LOAD  0 //250
#define NUMBER_ITEMS_ON_LOAD2 30


@class PieMenu;
@class TroisDViewController;
@class MapViewController;


////


////

@interface EDViewController () <UINavigationControllerDelegate,UIPopoverControllerDelegate,UIImagePickerControllerDelegate,AVAudioPlayerDelegate,OGActionChooserDelegate,GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate,addDelegate,UITextViewDelegate>
{
    MapViewController *viewControllermap;
    PieMenu *pieMenu;
	UIButton *btnCamera;
	UISegmentedControl *segmentVideoQuality;
	UIButton *btnSelectFile;
	UIImageView *imageView;
    UIPopoverController *popoverController;
    JPStupidButton *stickyButton;
	
	NSURL *targetURL;
	BOOL isCamera;
    UIBarButtonItem *oooppp;
    UIView *baseViewref;
	UITextField *reminderText;
	UISegmentedControl *scheduleControl;
	UIButton *setButton;
	UIButton *clearButton;
	UIDatePicker *datePicker;
    NSInteger indexto;
    NSInteger indextotakeimage;
    NSInteger indextotakeimage_prev;

    
    __gm_weak GMGridView *_gmGridView;
    UINavigationController *_optionsNav;
    UIPopoverController *_optionsPopOver;
    
    NSMutableArray *_data;
    NSMutableArray *_data2;
    __gm_weak NSMutableArray *_currentData;
    NSInteger _lastDeleteItemIndexAsked;
    OGActionButton *fst ;    
    OGActionButton *snd;
    OGActionButton *fth ;
    OGActionButton *fstnew ;    
    OGActionButton *sndnew;
    OGActionButton *fthnew ;
    
    NSURL *recordedFile;
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    BOOL isRecording;
    IBOutlet UIPopoverController *pop;
}

@property (nonatomic, retain) MapViewController *viewControllermap;
@property (strong, nonatomic) TroisDViewController *TroisDviewController;
@property (nonatomic, retain) UIBarButtonItem *oooppp;
@property (nonatomic, retain) PieMenu *pieMenu;

@property (nonatomic, retain) IBOutlet UIPopoverController *pop;
@property (nonatomic, retain) UIPopoverController *popoverController;

@property (nonatomic,readwrite)  UIView *baseViewref;


@property (nonatomic) BOOL isRecording;

@property (nonatomic,readwrite) OGActionButton *fst ;
@property (nonatomic,readwrite) OGActionButton *snd;
@property (nonatomic,readwrite) OGActionButton *fth ;
@property (nonatomic,readwrite) OGActionButton *fstnew ;
@property (nonatomic,readwrite) OGActionButton *sndnew;
@property (nonatomic,readwrite) OGActionButton *fthnew ;


@property (nonatomic,retain)  UITextField *reminderText;
@property (nonatomic,retain)  UISegmentedControl *scheduleControl;
@property (nonatomic,retain)  UIButton *setButton;
@property (nonatomic,retain)  UIButton *clearButton;
@property (nonatomic,retain)  UIDatePicker *datePicker;
@property (nonatomic)  NSInteger indexto;
@property (nonatomic)  NSInteger indextotakeimage;
@property (nonatomic)  NSInteger indextotakeimage_prev;


@property (nonatomic, retain)  UIButton *btnCamera;
@property (nonatomic, retain)  UISegmentedControl *segmentVideoQuality;
@property (nonatomic, retain)  UIButton *btnSelectFile;
@property (nonatomic, retain)  UIImageView *imageView;




-(IBAction)startCamera:(id)sender;
-(IBAction)selectFile:(id)sender;

-(void)getPreViewImg:(NSURL *)url;

-(NSString *)getFileName:(NSString *)fileName;
-(NSString *)timeStampAsString;

- (void)clearNotification;
- (void)scheduleNotification;
- (void)showReminder:(NSString *)text;

- (void)addMoreItem;
- (void)removeItem;
- (void)refreshItem;
- (void)presentInfo;
- (void)presentOptions:(UIBarButtonItem *)barButton;
- (void)optionsDoneAction;
- (void)dataSetChange:(UISegmentedControl *)control;
- (void)setupDetailButton;
- (void)pushDetailViewController:(id)sender;

@end


#import "PieMenu.h"
#import "TroisDViewController.h"
#import "MapViewController.h"



@implementation EDViewController

@synthesize viewControllermap;
@synthesize TroisDviewController;
@synthesize pieMenu;
@synthesize oooppp;
@synthesize pop;
@synthesize popoverController;
@synthesize btnCamera,btnSelectFile;
@synthesize segmentVideoQuality;
@synthesize imageView;

@synthesize baseViewref;
@synthesize isRecording = _isRecording;

@synthesize  viewController;
@synthesize   window;
@synthesize fst;
@synthesize snd;
@synthesize fth;
@synthesize fstnew;
@synthesize sndnew;
@synthesize fthnew;

@synthesize reminderText;
@synthesize scheduleControl;
@synthesize setButton;
@synthesize clearButton;
@synthesize datePicker;
@synthesize indexto;
@synthesize indextotakeimage;
@synthesize indextotakeimage_prev;

NSString *kRemindMeNotificationDataKey = @"kRemindMeNotificationDataKey";


- (void) itemSelected:(PieMenuItem *)item {
	NSLog(@"Item '%s' selected", [item.title UTF8String]);
	
}


- (void)loadView1111 {
    [super loadView];
    self.view.backgroundColor = [UIColor clearColor];
    
    // Optional button to demonstrate navigation stack
//    [self setupDetailButton];
}

- (void)setupDetailButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:NSLocalizedString(@"detail_button_title", @"detail_button_title")
            forState:UIControlStateNormal];
    [button sizeToFit];
    button.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [button addTarget:self action:@selector(pushDetailViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation = UIInterfaceOrientationPortrait);
}



- (void)viewDidLoad11111 {
    [super viewDidLoad];
    
    
    
    
 //   self.navigationController.navigationBarHidden = YES;
 //   self.navigationController.toolbarHidden = YES;
  /*  self.navigationItem.titleView = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"Close")
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self.navigationController.exposeController
                                                                              action:@selector(toggleExpose)] autorelease].customView;

    
 */
  /*  
    NSArray *itemArray = [NSArray arrayWithObjects:  @"Close", nil];
    UISegmentedControl *chooseAllORSome = [[UISegmentedControl alloc] initWithItems:itemArray];
    
    UIControlEvents capture = UIControlEventTouchDown;
    capture |= UIControlEventTouchDown;
    capture |= UIControlEventTouchUpInside;
    capture |= UIControlEventTouchUpOutside;
    
    chooseAllORSome.segmentedControlStyle = UISegmentedControlStyleBezeled;
    chooseAllORSome.selectedSegmentIndex = 0;
    [chooseAllORSome addTarget:self.navigationController.exposeController action:@selector(toggleExpose)  forControlEvents:capture];
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView: chooseAllORSome];
    self.navigationItem.titleView = segmentBarItem.customView;
    self.navigationItem.title = @"";
    [segmentBarItem release];
   */
    
    UITapGestureRecognizer *navSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.exposeController action:@selector(toggleExpose)];
    navSingleTap.numberOfTapsRequired = 1;
    self.navigationController.navigationBar.tintColor = [UIColor brownColor]; 
    self.navigationController.title = @"Press to close The Memo"; 
    [self setTitle:@"Press to close The Memo"];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
  
    
    [self.navigationController.navigationBar addGestureRecognizer:navSingleTap];
        
    
    
 /* 
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    NSArray * yyyy = [NSArray arrayWithObjects: 
                      [[UINavigationController alloc] initWithRootViewController:[[Demo1ViewController alloc] init]],                    
                      nil];
    [tabBarController setViewControllers:yyyy];
    UIView *view12345 = tabBarController.selectedViewController.view ;
  
    tabBarController.title = @"Press to close The Memo";
 //   self.navigationController.title = @"Press to close The Memo";
    
   [self.view addSubview:[tabBarController view]];*/
   
   // [self.navigationController presentModalViewController:tabBarController animated:YES];
 //   tabBarController.view.bounds = [[self view] bounds];
 //   self.window.rootViewController = self.tabBarController;
    

   
 //   [[self view] setAutoresizesSubviews:YES];
 //   [[self view] addSubview:tabBarController.view  ];
   
    
//    [self.window addSubview:self.tabBarController.view];
}


-(void) hello
{
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear:%d, %@", animated, self);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear:%d, %@", animated, self);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear:%d, %@", animated, self);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear:%d, %@", animated, self);
}

- (void)viewWillShrinkInExposeController:(LIExposeController *)exposeController animated:(BOOL)animated {
    NSLog(@"viewWillShrinkInExposeController:%d, %@", animated, self);
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidShrinkInExposeController:(LIExposeController *)exposeController animated:(BOOL)animated {
    NSLog(@"viewDidShrinkInExposeController:%d, %@", animated, self);
}

- (void)viewWillExpandInExposeController:(LIExposeController *)exposeController animated:(BOOL)animated {
    NSLog(@"viewWillExpandInExposeController:%d, %@", animated, self);
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidExpandInExposeController:(LIExposeController *)exposeController animated:(BOOL)animated {
    NSLog(@"viewDidExpandInExposeController:%d, %@", animated, self);
}

- (void)pushDetailViewController:(id)sender {
    EDDetailViewController *detailViewController = [[EDDetailViewController alloc] init] ;
    [self.navigationController pushViewController:detailViewController animated:YES];
}




///////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// end //////////////////////////////////////////////////////////////////

- (id)init
{
    if ((self =[super init])) 
    {
        self.title = @"";
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showActionSheet:forEvent:)];
        
        
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space.width = 10;
        
        UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeItem)];
        
        UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space2.width = 10;
        
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(toggleExpose)];
        
        
        /*/    
         UIBarButtonItem * topRightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showActionSheet:forEvent:)];
         self.navigationItem.leftBarButtonItem = topRightButton;
         // self.navigationItem.rightBarButtonItem = topRightButton;
         self.navigationController.toolbarHidden = NO;*/
        
        /*   if ([self.navigationItem respondsToSelector:@selector(leftBarButtonItems)]) {
         self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:addButton, space, removeButton, space2, refreshButton, nil];
         }else {
         self.navigationItem.leftBarButtonItem = addButton;
         }
         */
        if ([self.navigationItem respondsToSelector:@selector(leftBarButtonItems)]) {
            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:addButton, space, removeButton,space,refreshButton ,nil];
        }else {
            self.navigationItem.leftBarButtonItem = addButton;
        }
        
        /*
         if ([self.navigationItem respondsToSelector:@selector(leftBarButtonItems)]) {
         self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:addButton, space, removeButton, space2, nil];
         }else {
         self.navigationItem.leftBarButtonItem = addButton;
         }
         */      
        
        
        /*    UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(presentOptions:)];
         
         if ([self.navigationItem respondsToSelector:@selector(rightBarButtonItems)]) {
         self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:optionsButton, nil];
         }else {
         self.navigationItem.rightBarButtonItem = optionsButton;
         }
         */  
        
        
        
          
        MyManager *sharedManager = [MyManager sharedManager];
        NSString *comp = @"NO";
        if (sharedManager.flag == comp) {
            
        
        NSString * ppppww = [NSString stringWithFormat:@"%@", sharedManager.dataplist];

        NSString *plistfile = [ppppww stringByAppendingString:@".plist" ];
        
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString *documentsDirectory = [paths objectAtIndex:0]; 
        NSString *path = [documentsDirectory stringByAppendingPathComponent:plistfile]; NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath: path]) 
        {
            path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: plistfile] ];
        }
        
        
        
        
     
        NSMutableDictionary *data;
        
        if ([fileManager fileExistsAtPath: path]) 
        {
            data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        }
        
        
        
        
        _data = [[NSMutableArray alloc] init];


      //  int counternum = [[data allKeys] count] ;
        if ([[data allKeys] count] == 0) {
            NSLog(@"Your plist is empty");
        }
        else {
            int value1;
            NSString * valtemp;
            if([data objectForKey:@"Notification"] )
            {
                valtemp = [data objectForKey:@"Notification"];
                [_data addObject: valtemp];
            }
            if([data objectForKey:@"Note"] )
            {
                valtemp = [data objectForKey:@"Note"];
                [_data addObject: valtemp];
            }
            if([data objectForKey:@"Yourlocation"] )
            {
                valtemp = [data objectForKey:@"Yourlocation"];
                [_data addObject: valtemp];
            }
            if([data objectForKey:@"Take_Image"] )
            {
                valtemp = [data objectForKey:@"Take_Image"];
                [_data addObject: valtemp];
            }
            if([data objectForKey:@"Voice_record"] )
            {
                valtemp = [data objectForKey:@"Voice_record"];
                [_data addObject: valtemp];
            }
            
        }
//        _data = [[NSMutableArray alloc] init];
        //davidinitlalala
        for (int i = 0; i < NUMBER_ITEMS_ON_LOAD; i ++) 
        {
            [_data addObject:[NSString stringWithFormat:@"A %d", i]];
        }
        
        _data2 = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < NUMBER_ITEMS_ON_LOAD2; i ++) 
        {
            [_data2 addObject:[NSString stringWithFormat:@"B %d", i]];
        }
     }
        else {
            _data = [[NSMutableArray alloc] init];
            _data2 = [[NSMutableArray alloc] init];
        }
        _currentData = _data;
    }
    
    return self;
}

//////////////////////////////////////////////////////////////
#pragma mark controller events
//////////////////////////////////////////////////////////////

- (void)loadView 
{
    [super loadView];
    self.view.backgroundColor = [UIColor clearColor ]; // fondcouleur
    
    NSInteger spacing = INTERFACE_IS_PHONE ? 10 : 15;
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gmGridView];
    _gmGridView = gmGridView;
    
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gmGridView.centerGrid = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    
    /*   UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
     infoButton.frame = CGRectMake(self.view.bounds.size.width - 40, 
     self.view.bounds.size.height - 40, 
     40,
     40);
     infoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
     [infoButton addTarget:self action:@selector(presentInfo) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:infoButton];*/
    
    /*  UISegmentedControl *dataSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"DataSet 1", @"DataSet 2", nil]];
     [dataSegmentedControl sizeToFit];
     dataSegmentedControl.frame = CGRectMake(5, 
     self.view.bounds.size.height - dataSegmentedControl.bounds.size.height - 5,
     dataSegmentedControl.bounds.size.width, 
     dataSegmentedControl.bounds.size.height);
     dataSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
     dataSegmentedControl.tintColor = [UIColor greenColor];
     dataSegmentedControl.selectedSegmentIndex = 0;
     [dataSegmentedControl addTarget:self action:@selector(dataSetChange:) forControlEvents:UIControlEventValueChanged];
     [self.view addSubview:dataSegmentedControl];
     */
    /* 
     OptionsViewController *optionsController = [[OptionsViewController alloc] init];
     optionsController.gridView = gmGridView;
     optionsController.contentSizeForViewInPopover = CGSizeMake(400, 500);
     
     _optionsNav = [[UINavigationController alloc] initWithRootViewController:optionsController];
     
     if (INTERFACE_IS_PHONE)
     {
     UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(optionsDoneAction)];
     optionsController.navigationItem.rightBarButtonItem = doneButton;
     }
     */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
/*    UITapGestureRecognizer *navSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.exposeController action:@selector(toggleExpose)];
    navSingleTap.numberOfTapsRequired = 1;
    self.navigationController.navigationBar.tintColor = [UIColor brownColor]; 
    self.navigationController.title = @"Press to close The Memo"; 
    [self setTitle:@"Press to close The Memo"];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    
    
    [self.navigationController.navigationBar addGestureRecognizer:navSingleTap];
    self.navigationController.title = @"Press to close The Memo";
 */   
    _gmGridView.mainSuperView = self.navigationController.view; //[UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    [self.navigationController.navigationBar setAlpha:0.5];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close This Memo"
                                                                              style:UIBarButtonItemStylePlain target:self.navigationController.exposeController action:@selector(toggleExpose)];;
    //   [self.navigationController.navigationBar setBackgroundColor:[UIColor blueColor]];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    _gmGridView = nil;
}

//////////////////////////////////////////////////////////////
#pragma mark memory management
//////////////////////////////////////////////////////////////

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}

//////////////////////////////////////////////////////////////
#pragma mark orientation management
//////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_currentData count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE) 
    {
        if (UIInterfaceOrientationIsLandscape(orientation)) 
        {
            return CGSizeMake(170, 135);
        }
        else
        {
            return CGSizeMake(140, 110);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation)) 
        {
            return CGSizeMake(285, 205);
        }
        else
        {
            return CGSizeMake(230, 175);
        }
    }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) 
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;
        
        cell.contentView = view;
    }
    
    /// lalala petit carre
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.text = (NSString *)[_currentData objectAtIndex:index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor brownColor];
    label.textColor = [UIColor blackColor];
    label.highlightedTextColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [cell.contentView addSubview:label];
    
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    ////////////////////////////////////////////////////////    
    MyManager *sharedManager = [MyManager sharedManager];
    
    NSString * ppppww = [NSString stringWithFormat:@"%@", sharedManager.dataplist];
    
    
    
    NSString *plistfile = [ppppww stringByAppendingString:@".plist" ];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistfile]; NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) 
    {
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: plistfile] ];
    }
    
    
    
    
    
    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path]) 
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
    }
    
   
   
  NSObject *ooo =  [_currentData objectAtIndex:position];
  NSString *ppp =  [ooo description];
    NSString *tocomp = @"Voicerecord" ;  
    if ([ppp isEqualToString:tocomp]) {
        NSString *speechfile = [data objectForKey:@"speechfile"];
        recordedFile = [NSURL fileURLWithPath:speechfile];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];

        NSError *playerError;
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
        
        if (player == nil) 
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        player.delegate = self;

        [player play];

        
    }  
    tocomp = @"Note" ;  
    if ([ppp isEqualToString:tocomp]) {
        
        NSString *textnote = [data objectForKey:@"notefile"];
        AddNewNoteViewController *addDetail = [[AddNewNoteViewController alloc]initWithNibName:textnote bundle:nil] ;
        addDetail.delegateForAdd = self;
        [self.navigationController pushViewController:addDetail animated:YES];

    }    
    tocomp = @"Take_Image" ;  
    if ([ppp isEqualToString:tocomp]) {
        NSString *filepath1;
        NSString *filepath2;
        NSString *filepath3;
        NSString *filepath4;
        NSString *filepath5;
        NSString *filepath6;
        
        if([data objectForKey:@"imagenewpath1"] )
        {
           filepath1 = [data objectForKey:@"imagenewpath1"];   
        }
        if([data objectForKey:@"imagenewpath2"] )
        {
            filepath2 = [data objectForKey:@"imagenewpath2"];   
        }
        if([data objectForKey:@"imagenewpath3"] )
        {
            filepath3 = [data objectForKey:@"imagenewpath3"];   
        }
        if([data objectForKey:@"imagenewpath4"] )
        {
            filepath4 = [data objectForKey:@"imagenewpath4"];   
        }
        if([data objectForKey:@"imagenewpath5"] )
        {
            filepath5 = [data objectForKey:@"imagenewpath5"];   
        }
        if([data objectForKey:@"imagenewpath6"] )
        {
            filepath6 = [data objectForKey:@"imagenewpath6"];   
        }

      /*  UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 
                                                                    0, 
                                                                    self.view.frame.size.width, 
                                                                    self.view.frame.size.height)] ;*/
     //   UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed: @"Wood.jpg"]];
        //   UIColor *mycolor= [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:6.3];
     //   baseView.backgroundColor = background;
        
        
        
        
        
     //   baseViewref = baseView ;
     //   [self.view addSubview:baseView];
         self.TroisDviewController = [[TroisDViewController alloc] init] ;
        [self.TroisDviewController takethem:filepath1 withArg2:filepath2 withArg3:filepath3 withArg4:filepath4 withArg5:filepath5 withArg6:filepath6];
      //  [self.baseViewref addSubview:self.TroisDviewController.view];
        [self.navigationController pushViewController:self.TroisDviewController animated:YES ];
        
        
    }    
    
    
    tocomp = @"Yourlocation" ;  
    if ([ppp isEqualToString:tocomp]) {
        MyManager *sharedManager = [MyManager sharedManager];
        sharedManager.location = @"NO";

        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 
                                                                    0, 
                                                                    self.view.frame.size.width, 
                                                                    self.view.frame.size.height)] ;
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed: @"Wood.jpg"]];
        //   UIColor *mycolor= [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:6.3];
        baseView.backgroundColor = background;
        
        baseViewref = baseView ;
        
        
        NSString *newItem = [NSString stringWithFormat:@"%d", (int)(arc4random() % 1000)];
        
        [_currentData addObject:@"Yourlocation"];
        [_gmGridView insertObjectAtIndex:[_currentData count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        
        
        [data setObject:@"Yourlocation" forKey:@"Yourlocation"];
        [data writeToFile: path atomically:YES];
        
        MapViewController *controller = [[MapViewController alloc] init];
        self.viewControllermap = controller;
        
        
        [self.baseViewref addSubview:self.viewControllermap.view];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self 
                   action:@selector(finishtakeimage)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:@"Close The Map" forState:UIControlStateNormal];
        button.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height/10);
        UIColor *color = button.currentTitleColor;
        button.titleLabel.layer.shadowColor = [color CGColor];
        button.titleLabel.layer.shadowRadius = 4.0f;
        button.titleLabel.layer.shadowOpacity = .9;
        button.titleLabel.layer.shadowOffset = CGSizeZero;
        button.titleLabel.layer.masksToBounds = NO;
        [button.titleLabel setFont:[UIFont systemFontOfSize:22]];
        [self.baseViewref addSubview:button];
        
        [self.view addSubview:baseViewref];
        
        

        
    }
    
    NSLog(@"Did tap at index %d", position);
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
    
    _lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) 
    {
        [_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor orangeColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     } 
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{  
                         cell.contentView.backgroundColor = [UIColor brownColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    NSObject *object = [_currentData objectAtIndex:oldIndex];
    [_currentData removeObject:object];
    [_currentData insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [_currentData exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}


//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE) 
    {
        if (UIInterfaceOrientationIsLandscape(orientation)) 
        {
            return CGSizeMake(320, 210);
        }
        else
        {
            return CGSizeMake(300, 310);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation)) 
        {
            return CGSizeMake(700, 530);
        }
        else
        {
            return CGSizeMake(600, 500);
        }
    }
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    UIView *fullView = [[UIView alloc] init];
    fullView.backgroundColor = [UIColor yellowColor];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 8;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor brownColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (INTERFACE_IS_PHONE) 
    {
        label.font = [UIFont boldSystemFontOfSize:15];
    }
    else
    {
        label.font = [UIFont boldSystemFontOfSize:20];
    }
    
    [fullView addSubview:label];
    
    
    return fullView;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor blueColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     } 
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor brownColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     } 
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
{
    
}


//////////////////////////////////////////////////////////////
#pragma mark private methods
//////////////////////////////////////////////////////////////
//-(void)showPopover:(id)sender 
-(void)showPopover:(id)sender forEvent:(UIEvent*)event
{
    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableViewController.view.frame = CGRectMake(0,0, 320, 400);
    TSPopoverController *popoverController = [[TSPopoverController alloc] initWithContentViewController:tableViewController];
    
    popoverController.cornerRadius = 5;
    popoverController.titleText = @"change order";
    popoverController.popoverBaseColor = [UIColor lightGrayColor];
    popoverController.popoverGradient= NO;
    //    popoverController.arrowPosition = TSPopoverArrowPositionHorizontal;
    [popoverController showPopoverWithTouch:event];
    
}

-(void)closeforever
{
    CGPoint p = { 150.f, 150.f };
    [pieMenu showInView:baseViewref atPoint:p];

    [baseViewref removeFromSuperview];
}

-(void)finishtakeimage
{
    [baseViewref removeFromSuperview];
   
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}


-(void) showActionSheet:(id)sender forEvent:(UIEvent*)event
{
    
////////////////////////////////////////////////////////    
    MyManager *sharedManager = [MyManager sharedManager];
    
    NSString * ppppww = [NSString stringWithFormat:@"%@", sharedManager.dataplist];
    

    
    NSString *plistfile = [ppppww stringByAppendingString:@".plist" ];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistfile]; NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) 
    {
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: plistfile] ];
    }
    
    
    
    
  
    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path]) 
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
    }
    
  
    int value = (int)(arc4random() % 1000);
    

//////////////////////////////////////////////////////    
    
    TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:@"Please choose your memo"];
    //[actionSheet destructiveButtonWithTitle:@"hoge" block:nil];
    [actionSheet addButtonWithTitle:@"Voice record" block:^{
        // Example: adding object at the last position
        
        OGActionChooser *acSheet = [OGActionChooser actionChooserWithDelegate:self];
        acSheet.title = @"Audio Memo Recorder";
        //	acSheet.dismissAfterwards = YES; // Default: NO
        //	acSheet.shouldDrawShadow = NO;   // Default: YES
        
       
        
        fst = [OGActionButton buttonWithTitle:@"Start Record" imageName:@"actionChooser_Button.png" enabled:YES];
        
        snd = [OGActionButton buttonWithTitle:@"Stop Record" imageName:@"actionChooser_Button.png" enabled:YES];
//        OGActionButton *trd = [OGActionButton buttonWithTitle:@"Next Page" imageName:imgName enabled:YES];
        fth = [OGActionButton buttonWithTitle:@"CANCEL" imageName:@"actionChooser_Button.png" enabled:YES];
        
        fth.block = ^(NSString *title, BOOL *dismiss) {
            NSLog(@"you can now use ^(%@) too …", title);
            *dismiss = YES;
        };
        
        // you can use 'buttonWithTitle:image:enabled:' for example if you like to draw it with Quartz. Or you want to copy from another image etc.
        
        [acSheet setButtonsWithArray:[NSArray arrayWithObjects:
                                      fst, @"", snd, // always three in a row (currently)
                                      @"", fth, @"",
                                       nil]]; // next page

/*        
        [acSheet setButtonsWithArray:[NSArray arrayWithObjects:
                                      fst, @"", snd, // always three in a row (currently)
                                      @"", fth, @"",
                                      trd, nil]]; // next page
  */      
        [acSheet presentInView: self.view];
        
        NSString *newItem = [NSString stringWithFormat:@"%d", value];
        
//        [_currentData addObject:newItem];
        [_currentData addObject:@"Voicerecord"];
        
        [_gmGridView insertObjectAtIndex:[_currentData count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        
        //To insert the data into the plist
//        [data setObject:[NSNumber numberWithInt:value] forKey:@"Voice_record"];
        
        [data setObject:@"Voicerecord" forKey:@"Voice_record"];
        [data writeToFile: path atomically:YES];
        NSLog(@"pushed hoge1 button");
    }];
    
    [actionSheet addButtonWithTitle:@"Take Image" block:^{
        // Example: adding object at the last position
        indextotakeimage = 0 ;
        indextotakeimage_prev = 0 ;
        NSString *newItem = [NSString stringWithFormat:@"%d", (int)(arc4random() % 1000)];
        
        [_currentData addObject:@"Take_Image"];
        [_gmGridView insertObjectAtIndex:[_currentData count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        [data setObject:@"Take_Image" forKey:@"Take_Image"];
        [data writeToFile: path atomically:YES];
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 
                                                                    0, 
                                                                    self.view.frame.size.width, 
                                                                    self.view.frame.size.height)] ;
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed: @"Wood.jpg"]];
        //   UIColor *mycolor= [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:6.3];
        baseView.backgroundColor = background;
       
        
        
        
        baseViewref = baseView ;

 /*       btnCamera = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCamera addTarget:self 
                      action:@selector(startCamera:)
            forControlEvents:UIControlEventTouchDown];
        [btnCamera setTitle:@"Start Camera" forState:UIControlStateNormal];
        btnCamera.frame = CGRectMake(20, 20, 280, 37);
        [baseView addSubview:btnCamera];  */
/*
        segmentVideoQuality = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"High", @"640", @"Medium",@"Low", nil]];
        segmentVideoQuality.frame = CGRectMake(20, 72, 280, 30);
        segmentVideoQuality.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentVideoQuality.selectedSegmentIndex = 4;
        segmentVideoQuality.tintColor = [UIColor colorWithRed:.9 green:.1 blue:.1 alpha:1];
        
        
        
        [segmentVideoQuality addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
        [baseView addSubview:segmentVideoQuality];
        */
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 118, 280, 181)]; 
        [baseView addSubview:imageView];
        
       /* btnSelectFile = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnSelectFile addTarget:self 
                      action:@selector(selectFile:)
            forControlEvents:UIControlEventTouchDown];
        [btnSelectFile setTitle:@"Select File" forState:UIControlStateNormal];
        btnSelectFile.frame = CGRectMake(20, 317, 280, 37);
        [baseView addSubview:btnSelectFile]; */ 
        
      /*  UIButton  *btnClose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnClose addTarget:self 
                          action:@selector(closeforever)
                forControlEvents:UIControlEventTouchDown];
        [btnClose setTitle:@"Close" forState:UIControlStateNormal];
        btnClose.frame = CGRectMake(31, 378, 280, 37);
        [baseView addSubview:btnClose];*/  
        [self.view  addSubview:baseView];
        
        
        
        

        NSLog(@"pushed hoge2 button");
        
        self.pieMenu = [[PieMenu alloc] init];
        PieMenuItem *itemA = [[PieMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Start Camera"]
                                                          label:nil 
                                                         target:self 
                                                       selector:@selector(startCamera:) 
                                                       userInfo:nil 
                                                           icon:nil];
        
        
        PieMenuItem *itemC = [[PieMenuItem alloc] initWithTitle:@"Select File" 
                                                          label:nil 
                                                         target:self 
                                                       selector:@selector(selectfilefromlib) 
                                                       userInfo:nil 
                                                           icon:nil];
        
        
        

        
        PieMenuItem *itemF = [[PieMenuItem alloc] initWithTitle:@"Image Quality" 
                                                          label:nil 
                                                         target:self 
                                                       selector:@selector(qualityvideo) 
                                                       userInfo:nil 
                                                           icon:nil];
        
        PieMenuItem *itemG = [[PieMenuItem alloc] initWithTitle:@"close" 
                                                          label:nil 
                                                         target:self 
                                                       selector:@selector(closeforever) 
                                                       userInfo:nil 
                                                           icon:nil];
        
       
        
        
        //[pieMenu addItem:itemD]; 
        [pieMenu addItem:itemA];
        [pieMenu addItem:itemC];
        //[pieMenu addItem:itemE];
        //[pieMenu addItem:itemB];
        [pieMenu addItem:itemF];
        [pieMenu addItem:itemG];
        
        CGPoint p = { 150.f, 150.f };
        
        [pieMenu showInView:baseView atPoint:p];

        
    }];
    [actionSheet addButtonWithTitle:@"Yourlocation" block:^{
        // Example: adding object at the last position
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 
                                                                    0, 
                                                                    self.view.frame.size.width, 
                                                                    self.view.frame.size.height)] ;
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed: @"Wood.jpg"]];
        //   UIColor *mycolor= [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:6.3];
        baseView.backgroundColor = background;
        
        baseViewref = baseView ;
        
        MyManager *sharedManager = [MyManager sharedManager];
        sharedManager.location = @"YES";
        NSString *newItem = [NSString stringWithFormat:@"%d", (int)(arc4random() % 1000)];
        
        [_currentData addObject:@"Yourlocation"];
        [_gmGridView insertObjectAtIndex:[_currentData count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        
        
        [data setObject:@"Yourlocation" forKey:@"Yourlocation"];
        [data writeToFile: path atomically:YES];

        MapViewController *controller = [[MapViewController alloc] init];
        self.viewControllermap = controller;
      
        
        [self.baseViewref addSubview:self.viewControllermap.view];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self 
                   action:@selector(finishtakeimage)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:@"Close The Map" forState:UIControlStateNormal];
        button.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height/10);
        UIColor *color = button.currentTitleColor;
        button.titleLabel.layer.shadowColor = [color CGColor];
        button.titleLabel.layer.shadowRadius = 4.0f;
        button.titleLabel.layer.shadowOpacity = .9;
        button.titleLabel.layer.shadowOffset = CGSizeZero;
        button.titleLabel.layer.masksToBounds = NO;
        [button.titleLabel setFont:[UIFont systemFontOfSize:22]];
        [self.baseViewref addSubview:button];
        
        [self.view addSubview:baseViewref];
       
       
        
    
        
       
        NSLog(@"pushed hoge1 button");
    }];
    [actionSheet addButtonWithTitle:@"Note" block:^{
        // Example: adding object at the last position
        NSString *newItem = [NSString stringWithFormat:@"%d", (int)(arc4random() % 1000)];
        
        [_currentData addObject:@"Note"];
        [_gmGridView insertObjectAtIndex:[_currentData count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        
        [data setObject:@"Note" forKey:@"Note"];
        [data writeToFile: path atomically:YES];
        
        AddNewNoteViewController *addDetail = [[AddNewNoteViewController alloc]initWithNibName:@"AddNewNoteViewController" bundle:nil] ;
        addDetail.delegateForAdd = self;
        [self.navigationController pushViewController:addDetail animated:YES];
        
        NSLog(@"pushed hoge2 button");
    }];
    [actionSheet addButtonWithTitle:@"Reminde Me" block:^{
        // Example: adding object at the last position
        NSString *newItem = [NSString stringWithFormat:@"%d", (int)(arc4random() % 1000)];
        
        [_currentData addObject:@"Notification"];
        [_gmGridView insertObjectAtIndex:[_currentData count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        
        [data setObject:@"Notification" forKey:@"Notification"];
        [data writeToFile: path atomically:YES];
       
       // UIView *baseView = [[UIView alloc] initWithFrame: CGRectMake ( 0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 
                                                             0, 
                                                             self.view.frame.size.width, 
                                                             self.view.frame.size.height)] ;
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed: @"Wood.jpg"]];
        //   UIColor *mycolor= [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:6.3];
        baseView.backgroundColor = background;
        
        baseViewref = baseView ;
        
        indexto = 4 ;
        reminderText = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width -50 , 31)];
        reminderText.borderStyle = UITextBorderStyleRoundedRect;
        reminderText.font = [UIFont systemFontOfSize:15];
        reminderText.placeholder = @"enter text";
        reminderText.autocorrectionType = UITextAutocorrectionTypeNo;
        reminderText.keyboardType = UIKeyboardTypeDefault;
        reminderText.returnKeyType = UIReturnKeyDone;
        reminderText.clearButtonMode = UITextFieldViewModeWhileEditing;
        reminderText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; 
        
        reminderText.delegate = self.baseViewref;
        
     //   UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"  initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:reminderText action:@selector(resignFirstResponder)] ;
        UIBarButtonItem *clearButton111 = [[UIBarButtonItem alloc] initWithTitle:@"hide keyboard device" style:UIBarButtonItemStyleDone target:reminderText action:@selector(resignFirstResponder)];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] ;
        toolbar.items = [NSArray arrayWithObject:clearButton111];
        
        
        reminderText.inputAccessoryView = toolbar;
        
        reminderText.text = @"Place your text here";
        [self.reminderText resignFirstResponder];
        [baseView endEditing:YES];
        [baseView addSubview:reminderText];
        
        UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(11, 70, self.view.frame.size.width - 11, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
        label.textColor=[UIColor blackColor];
        label.text = @"Repeat Remenider Each :";
        label.font = [UIFont fontWithName:@"Helvetica Neue" size:20.0]; 
        [baseView addSubview:label];
        
        scheduleControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Hour", @"Day", @"Week",@"Month",@"Never", nil]];
        scheduleControl.frame = CGRectMake(11, 100, self.view.frame.size.width-30, 44);
        scheduleControl.segmentedControlStyle = UISegmentedControlStyleBar;
        scheduleControl.selectedSegmentIndex = 4;
        scheduleControl.tintColor = [UIColor colorWithRed:.9 green:.1 blue:.1 alpha:1];
        
        
        
        [scheduleControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
        [baseView addSubview:scheduleControl];
        
        //  scheduleControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"1", @"2", @"3", @"4", nil]];
        
		
        setButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [setButton addTarget:self 
                      action:@selector(scheduleNotification)
            forControlEvents:UIControlEventTouchDown];
        [setButton setTitle:@"Set" forState:UIControlStateNormal];
        setButton.frame = CGRectMake(2*(self.view.frame.size.width/10), 169, 2*(self.view.frame.size.width/10), 38);
        [baseView addSubview:setButton];  
        
        
        
        clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [clearButton addTarget:self 
                        action:@selector(clearNotification)
              forControlEvents:UIControlEventTouchDown];
        [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
        clearButton.frame = CGRectMake(6*(self.view.frame.size.width/10), 169, 2*(self.view.frame.size.width/10), 38);
        [baseView addSubview:clearButton];    
        
        CGRect pickerFrame = CGRectMake(0,224,self.view.frame.size.width,216);
        
        datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
        [datePicker addTarget:self action:@selector(pickerChanged:)               forControlEvents:UIControlEventValueChanged];
        datePicker.minimumDate = [NSDate date];
        datePicker.timeZone = [NSTimeZone localTimeZone];
        [baseView addSubview:datePicker];
        
        
        [self.view addSubview:baseView];
        
        NSLog(@"pushed hoge2 button");
    }];
    
    [actionSheet cancelButtonWithTitle:@"Cancel" block:nil];
    actionSheet.cornerRadius = 5;
    
    [actionSheet showWithTouch:event];
}

- (void)addMoreItem
{
    
    // Example: adding object at the last position
    NSString *newItem = [NSString stringWithFormat:@"%d", (int)(arc4random() % 1000)];
    
    [_currentData addObject:newItem];
    [_gmGridView insertObjectAtIndex:[_currentData count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
}

- (void)removeItem
{
    // Example: removing last item
    if ([_currentData count] > 0) 
    {
        NSInteger index = [_currentData count] - 1;
        
        [_gmGridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        [_currentData removeObjectAtIndex:index];
    }
}

- (void)refreshItem
{
    // Example: reloading last item
    if ([_currentData count] > 0) 
    {
        int index = [_currentData count] - 1;
        
        NSString *newMessage = [NSString stringWithFormat:@"%d", (arc4random() % 1000)];
        
        [_currentData replaceObjectAtIndex:index withObject:newMessage];
        [_gmGridView reloadObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
    }
}

- (void)presentInfo
{
    NSString *info = @"Long-press an item and its color will change; letting you know that you can now move it around. \n\nUsing two fingers, pinch/drag/rotate an item; zoom it enough and you will enter the fullsize mode";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" 
                                                        message:info 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
    
    [alertView show];
}

- (void)dataSetChange:(UISegmentedControl *)control
{
    _currentData = ([control selectedSegmentIndex] == 0) ? _data : _data2;
    
    [_gmGridView reloadData];
}

- (void)presentOptions:(UIBarButtonItem *)barButton
{
    if (INTERFACE_IS_PHONE)
    {
        [self presentModalViewController:_optionsNav animated:YES];
    }
    else
    {
        if(![_optionsPopOver isPopoverVisible])
        {
            if (!_optionsPopOver)
            {
                _optionsPopOver = [[UIPopoverController alloc] initWithContentViewController:_optionsNav];
            }
            
            [_optionsPopOver presentPopoverFromBarButtonItem:barButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            [self optionsDoneAction];
        }
    }
}

- (void)optionsDoneAction
{
    if (INTERFACE_IS_PHONE)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [_optionsPopOver dismissPopoverAnimated:YES];
    }
}


//  ---------------------------------------------------------------
// |
// |  Event handling OGActionChooser
// |
//  ---------------------------------------------------------------

- (void)actionChooser:(OGActionChooser *)ac buttonPressedWithIndex:(NSInteger)index
{
    
    
    
    
    
    
    
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    NSString * ppppww = [NSString stringWithFormat:@"%@", sharedManager.dataplist];
    
    NSString *temp = @"RecordedFile";
    
    NSString *temp1 = [temp stringByAppendingString:ppppww ];

    NSError *playerError;
    self.isRecording = NO;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [documentsDirectory stringByAppendingPathComponent:temp1];
    recordedFile = [NSURL fileURLWithPath:file];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
    
    
    
	// you can create an array of buttons to identify them by index
    NSString *plistfile = [ppppww stringByAppendingString:@".plist" ];
   // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
   // NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistfile]; NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) 
    {
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: plistfile] ];
    }
    
    
    
    
    
    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path]) 
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
    }
    
	
    
    
    switch (index) {
		case 0:
		//	ac.shouldDrawShadow = !ac.shouldDrawShadow; break;

            self.isRecording = YES;
            recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:nil error:nil];
            [recorder prepareToRecord];
            [recorder record];
            player = nil;
            
            ac.title =  @"Recording ...";
            break;
		case 2:
            
            self.isRecording = NO;
            [recorder stop];
            [data setObject:file forKey:@"speechfile"];
            [data writeToFile: path atomically:YES];

            recorder = nil;
             ac.title =  @"Stop Recording Press on X \n\n to close please";
           /*
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
            
            if (player == nil) 
            {
                NSLog(@"ERror creating player: %@", [playerError description]);
            }
            player.delegate = self;
            
           
            [player play];
            */
			break;
		case 6:
			NSLog(@"first button on the second page clicked"); 
            break;
		default:
			NSLog(@"clicked button with index: %i", index);
	}
	
	//[ac dismiss]; // if you like to close it right afterwards
}

- (void)actionChooserFinished:(OGActionChooser *)ac
{
	NSLog(@"cancel button clicked or dismissed programatically");
}


- (void)pickerChanged:(id)sender{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
   	df.dateStyle = NSDateFormatterMediumStyle;
	NSString *temp = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:datePicker.date]];
    NSLog(@"value: %@",temp);
    
}

- (void)valueChangednew:(UISegmentedControl *)segment {
    /* [[segment.subviews objectAtIndex:0] setTintColor:[UIColor blackColor]];
     [[segment.subviews objectAtIndex:1] setTintColor:[UIColor blackColor]];
     [[segment.subviews objectAtIndex:2] setTintColor:[UIColor blackColor]];
     [[segment.subviews objectAtIndex:3] setTintColor:[UIColor blackColor]];
     [[segment.subviews objectAtIndex:4] setTintColor:[UIColor blackColor]];
     */
    
    if(segment.selectedSegmentIndex == 0) {
        indexto = 0 ;
        //    [[segment.subviews objectAtIndex:indexto] setTintColor:[UIColor blueColor]];
        NSLog(@"selectedSegmentIndex index: 0");
    }else if(segment.selectedSegmentIndex == 1){
        indexto = 1 ;
        //  [[segment.subviews objectAtIndex:indexto] setTintColor:[UIColor blueColor]];
        
        NSLog(@"selectedSegmentIndex index: 1");
    }else if(segment.selectedSegmentIndex == 2){
        indexto = 2 ;
        // [[segment.subviews objectAtIndex:indexto] setTintColor:[UIColor blueColor]];
        
        NSLog(@"selectedSegmentIndex index: 2");
    }else if(segment.selectedSegmentIndex == 3){
        indexto = 3 ;
        // [[segment.subviews objectAtIndex:indexto] setTintColor:[UIColor blueColor]];
        
        NSLog(@"selectedSegmentIndex index: 3");
    }
    else if(segment.selectedSegmentIndex == 4){
        indexto = 4 ;
        // [[segment.subviews objectAtIndex:indexto] setTintColor:[UIColor blueColor]];
        
        NSLog(@"selectedSegmentIndex index: 4");
    } 
    else {
        segment.selectedSegmentIndex == 4;
    }
    
    [segmentVideoQuality  removeFromSuperview];
    CGPoint p = { 150.f, 150.f };
    [pieMenu showInView:baseViewref atPoint:p];

}

- (void)valueChanged:(UISegmentedControl *)segment {
    /* [[segment.subviews objectAtIndex:0] setTintColor:[UIColor blackColor]];
     [[segment.subviews objectAtIndex:1] setTintColor:[UIColor blackColor]];
     [[segment.subviews objectAtIndex:2] setTintColor:[UIColor blackColor]];
     [[segment.subviews objectAtIndex:3] setTintColor:[UIColor blackColor]];
     [[segment.subviews objectAtIndex:4] setTintColor:[UIColor blackColor]];
     */
    
    if(segment.selectedSegmentIndex == 0) {
        indexto = 0 ;
        //    [[segment.subviews objectAtIndex:indexto] setTintColor:[UIColor blueColor]];
        NSLog(@"selectedSegmentIndex index: 0");
    }else if(segment.selectedSegmentIndex == 1){
        indexto = 1 ;
        //  [[segment.subviews objectAtIndex:indexto] setTintColor:[UIColor blueColor]];
        
        NSLog(@"selectedSegmentIndex index: 1");
    }else if(segment.selectedSegmentIndex == 2){
        indexto = 2 ;
        // [[segment.subviews objectAtIndex:indexto] setTintColor:[UIColor blueColor]];
        
        NSLog(@"selectedSegmentIndex index: 2");
    }else if(segment.selectedSegmentIndex == 3){
        indexto = 3 ;
        // [[segment.subviews objectAtIndex:indexto] setTintColor:[UIColor blueColor]];
        
        NSLog(@"selectedSegmentIndex index: 3");
    }
    else if(segment.selectedSegmentIndex == 4){
        indexto = 4 ;
        // [[segment.subviews objectAtIndex:indexto] setTintColor:[UIColor blueColor]];
        
        NSLog(@"selectedSegmentIndex index: 4");
    }    
}


#pragma mark -
#pragma mark === View Actions ===
#pragma mark -

- (void)clearNotification {
	
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self.baseViewref removeFromSuperview];
}

- (void)scheduleNotification {
	
	[reminderText resignFirstResponder];
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
     [self.baseViewref removeFromSuperview];
	Class cls = NSClassFromString(@"UILocalNotification");
	if (cls != nil) {
		
		UILocalNotification *notif = [[cls alloc] init];
        datePicker.timeZone = [NSTimeZone systemTimeZone] ;
		notif.fireDate = [datePicker date];
        NSLog(@"notif.fireDate: %@",notif.fireDate);
		notif.timeZone = [NSTimeZone localTimeZone];
		
        
        // NSLog(@"Local Time Zone %@",[[NSTimeZone localTimeZone] name]);
        // NSLog(@"System Time Zone %@",[[NSTimeZone systemTimeZone] name]);
         MyManager *sharedManager = [MyManager sharedManager];
        NSString *op = @"Please Remind the memo:  ";
        NSString *op1 = [op stringByAppendingString:reminderText.text];
        NSString *op2 = [op1 stringByAppendingString:@"   "];
        
		notif.alertBody = [op2 stringByAppendingString:sharedManager.label2];  //@"Did you forget something?";
		notif.alertAction = sharedManager.label1;
		notif.soundName = UILocalNotificationDefaultSoundName;
		notif.applicationIconBadgeNumber = 1;
		
		NSInteger index =  indexto ;
        
		switch (index) {
			case 0:
				notif.repeatInterval = NSHourCalendarUnit;
				break;
			case 1:
				notif.repeatInterval = NSDayCalendarUnit;
				break;
			case 2:
				notif.repeatInterval = NSWeekCalendarUnit;
				break;
			case 3:
				notif.repeatInterval = NSMonthCalendarUnit;
				break;
			case 4:
				notif.repeatInterval = 0;
				break;
			default:
				notif.repeatInterval = 0;
				break;
		}
		
		NSDictionary *userDict = [NSDictionary dictionaryWithObject:reminderText.text
                                                             forKey:kRemindMeNotificationDataKey];
		notif.userInfo = userDict;
		
		[[UIApplication sharedApplication] scheduleLocalNotification:notif];
		
	}
}

- (void)showReminder:(NSString *)text {
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reminder" 
                                                        message:text delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
	[alertView show];
	
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    MyManager *sharedManager = [MyManager sharedManager];
    
    NSString * ppppww = [NSString stringWithFormat:@"%@", sharedManager.dataplist];
    
    indextotakeimage = indextotakeimage + 1 ;
    
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    
	// you can create an array of buttons to identify them by index
    NSString *plistfile = [ppppww stringByAppendingString:@".plist" ];
    // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    // NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistfile]; NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) 
    {
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: plistfile] ];
    }
    
    
    
    
    
    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path]) 
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
    }
    
    
 //   [data setObject:tempo forKey:@"notefile"];
 //   [data writeToFile: path atomically:YES];
    

	[picker dismissModalViewControllerAnimated:YES];
    
    NSLog(@"info = %@",info);
    
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	
	if([mediaType isEqualToString:@"public.movie"])			//被选中的是视频
	{
		NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
		targetURL = url;		//视频的储存路径
       //   [data setObject:url forKey:@"imagenewurl"];
       //   [data writeToFile: path atomically:YES];

        
		if (isCamera) 
		{
			//保存视频到相册
			ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
			[library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:nil];
			
		}
		
		//获取视频的某一帧作为预览
        [self getPreViewImg:url];
	}
	else if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
	{
        //获取照片实例
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage] ;
		
        NSString *fileName = [[NSString alloc] init];
       
        if ([info objectForKey:UIImagePickerControllerReferenceURL]) {
            fileName = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
            //ReferenceURL的类型为NSURL 无法直接使用  必须用absoluteString 转换，照相机返回的没有UIImagePickerControllerReferenceURL，会报错
            fileName = [self getFileName:fileName];
        }
        else
        {
            fileName = [self timeStampAsString];
        }
        
        
         NSLog(@"Image fileName %@ ",fileName);
        NSURL *urlnew = [NSURL URLWithString:fileName];
		
     //   [data setObject:fileName forKey:@"imagenewurl"];
     //   [data writeToFile: path atomically:YES];
        NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
        
        [myDefault setValue:fileName forKey:@"fileName"];
		if (isCamera) //判定，避免重复保存
		{
           /* 
            ALAssetsLibrary *al=[[ALAssetsLibrary alloc] init];
            [al writeImageToSavedPhotosAlbum:[image CGImage] metadata:nil completionBlock:^(NSURL *assetURL,NSError *error)
             {                
                 ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myAsset)
                 {
                     ALAssetRepresentation *rep = [myAsset defaultRepresentation];
                     //NSString *fileName = [rep filename];
                     NSString *imgUrl = [[rep url] absoluteString];
                     NSString *yyy = [rep filename];
                     
                     //[self.imagesArray addObject:imgInfo];
                     [self dismissViewControllerAnimated:YES completion:nil];
                     NSLog(@"Image from Camera %@ added to imageArray",imgUrl);
                     NSLog(@"Image from Camera %@ added to imageArray",yyy);
                 };
                 
                 ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
                 [assetsLibrary assetForURL:assetURL
                                resultBlock:resultblock
                               failureBlock:nil];
             }];
            url assets-library://asset/asset.JPG?id=CCE89C38-BED9-44A1-802A-CDDEA783D888&ext=JPG
            */
            UIImage *viewImage = image;  // --- mine was made from drawing context
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];  
            // Request to save the image to camera roll  
            [library writeImageToSavedPhotosAlbum:[viewImage CGImage] orientation:(ALAssetOrientation)[viewImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){  
                if (error) {  
                    NSLog(@"error");  
                } else {  
                    NSLog(@"url %@", assetURL); 
                    NSString *tempoq = [@"Documents/"   stringByAppendingPathComponent:[self timeStampAsString]];
                   // NSString *tempoq001 = [tempoq stringByAppendingPathComponent:@".jpg"];
                     NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:tempoq];


                   [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
                    
                    NSString *inStr = [NSString stringWithFormat:@"%d", indextotakeimage];
                    NSString *inStr1 = [@"imagenewpath" stringByAppendingString:inStr]; 
                    [data setObject:jpgPath forKey:inStr1];
                    [data writeToFile: path atomically:YES];

                    [self performSelector:@selector(saveImg:) withObject:[UIImage imageWithContentsOfFile:jpgPath] afterDelay:0.0];

                }  
            }];  
            
            //NSString* originalFileName = [[library defaultRepresentation] filename];
			//保存到相册
            /*
			ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
			[library writeImageToSavedPhotosAlbum:[image CGImage]
									  orientation:(ALAssetOrientation)[image imageOrientation]
								  completionBlock:^(NSURL* assetURL, NSError* error) 
             {
                 if (error.code == 0) {
                     NSLog(@"URL %@", assetURL);
                     [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                         NSLog(@"Filename %@", [[asset defaultRepresentation] filename]);
                     }
                             failureBlock:^(NSError* error) {
                                 NSLog(@"failed to retrieve image asset:\nError: %@ ", [error localizedDescription]);
                             }];
                 }else {
                     NSLog(@"saved image failed.\nerror code %i\n%@", error.code, [error localizedDescription]);
                 }
             }];
            
			*/
            
            
            
            
		}
        
        
		NSURL *urlrrr = [info objectForKey:UIImagePickerControllerReferenceURL];
        NSLog(@"tttt %@",urlrrr);
        NSString *tempoq = [@"Documents/"   stringByAppendingPathComponent:[self timeStampAsString]];
       // NSString *tempoq001 = [tempoq stringByAppendingPathComponent:@".jpg"];
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:tempoq];
        
        
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
 
        
        NSString *inStr = [NSString stringWithFormat:@"%d", indextotakeimage];
        NSString *inStr1 = [@"imagenewpath" stringByAppendingString:inStr]; 
        [data setObject:jpgPath forKey:inStr1];
        [data writeToFile: path atomically:YES];

        //[self getPreViewImg:urlrrr];
		[self performSelector:@selector(saveImg:) withObject:image afterDelay:0.0];
		
	}
	else
	{
		NSLog(@"Error media type");
		return;
	}
    
	isCamera = FALSE;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	NSLog(@"Cancle it");
	isCamera = FALSE;
	[picker dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark userFunc

-(void)getPreViewImg:(NSURL *)url
{
    
    
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    NSString * ppppww = [NSString stringWithFormat:@"%@", sharedManager.dataplist];
    
    
    
    
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    
	// you can create an array of buttons to identify them by index
    NSString *plistfile = [ppppww stringByAppendingString:@".plist" ];
    // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    // NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistfile]; NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) 
    {
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: plistfile] ];
    }
    
    
    
    
    
    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path]) 
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
    }
    
   //    [data setObject:url forKey:@"imagenewurl"];
   //    [data writeToFile: path atomically:YES];
    
/////////////////////////////////////////////////////////////////////////////////////////////////    

    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);

    NSString *tempoq = [@"Documents/"   stringByAppendingPathComponent:[self timeStampAsString]];
 //   NSString *tempoq001 = [tempoq stringByAppendingPathComponent:@".jpg"];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:tempoq];
    
    
    [UIImageJPEGRepresentation(img, 1.0) writeToFile:jpgPath atomically:YES];
    
    NSString *inStr = [NSString stringWithFormat:@"%d", indextotakeimage];
    NSString *inStr1 = [@"imagenewpath" stringByAppendingString:inStr]; 
    [data setObject:jpgPath forKey:inStr1];
    [data writeToFile: path atomically:YES];


    [self performSelector:@selector(saveImg:) withObject:img afterDelay:0.1];
   
}

-(NSString *)getFileName:(NSString *)fileName
{
	NSArray *temp = [fileName componentsSeparatedByString:@"&ext="];
	NSString *suffix = [temp lastObject];
	
	temp = [[temp objectAtIndex:0] componentsSeparatedByString:@"?id="];
	
	NSString *name = [temp lastObject];
	
	name = [name stringByAppendingFormat:@".%@",suffix];
	return name;
}

-(void)saveImg:(UIImage *) image
{
    
	NSLog(@"Review Image");
    UIAlertView *alert;
	imageView.image = image;
    if(indextotakeimage > indextotakeimage_prev)
    {
    NSString * opopopop = [@"You May add  " stringByAppendingString:[NSString stringWithFormat:@"%d", (6 - indextotakeimage)]];
    NSString *yyyryr = [opopopop stringByAppendingString:@"  more Images"];
   alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:yyyryr delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    }
    indextotakeimage_prev = indextotakeimage;
    [alert show];

}

-(NSString *)timeStampAsString
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    NSString *locationString = [df stringFromDate:nowDate];
    
    NSString *locationString1 = [locationString  stringByAppendingString:[NSString stringWithFormat:@"%d", indextotakeimage]];
    

    return [locationString1 stringByAppendingFormat:@".jpg"];
}

#pragma mark -
#pragma mark sendFile

-(IBAction)startCamera:(id)sender
{
	UIImagePickerController *camera = [[UIImagePickerController alloc] init];
	camera.delegate = self;
	camera.allowsEditing = YES;
	isCamera = TRUE;
	
	//检查摄像头是否支持摄像机模式
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{		
		camera.sourceType = UIImagePickerControllerSourceTypeCamera;
		camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	}
	else 
	{
		NSLog(@"Camera not exist");
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Camera not exist"
                                                            message:@"Go to Select File" delegate:self 
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        CGPoint p = { 150.f, 150.f };
        [pieMenu showInView:baseViewref atPoint:p];

		return;
	}
	
    //仅对视频拍摄有效
	switch (segmentVideoQuality.selectedSegmentIndex) {
		case 0:
			camera.videoQuality = UIImagePickerControllerQualityTypeHigh;
			break;
		case 1:
			camera.videoQuality = UIImagePickerControllerQualityType640x480;
			break;
		case 2:
			camera.videoQuality = UIImagePickerControllerQualityTypeMedium;
			break;
		case 3:
			camera.videoQuality = UIImagePickerControllerQualityTypeLow;
			break;
		default:
			camera.videoQuality = UIImagePickerControllerQualityTypeMedium;
			break;
	}
	
	[self presentModalViewController:camera animated:YES];
    CGPoint p = { 150.f, 150.f };
  //  [pieMenu showInView:baseViewref atPoint:p];
    [self selectfilefromlib];
	
}




-(IBAction)selectFile:(id)sender
{
    
    
    if ([[UIDevice currentDevice].model isEqual:@"iPad"])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
      //  UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:picker];
       self.pop=[[UIPopoverController alloc] 
                  initWithContentViewController:picker];
        picker.delegate = self; 
        
        pop.delegate = self;
        CGRect popoverRect = [self.view convertRect:[sender frame] fromView:[sender superview]];
        
        NSLog(@"Rect Selected");
        [pop presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        NSLog(@"Rect Made and presented");																
        [pop setPopoverContentSize:CGSizeMake(200.0, 200.0)]; 
        
        [pop presentPopoverFromRect:[sender bounds]
                                          inView:sender
                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                        animated:NO];
        
        
        // Display image picker in a popover
    }
    else
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            //混合类型 photo + movie
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        [self presentModalViewController:picker animated:YES];
    }


}

-(void)qualityvideo
{
    segmentVideoQuality = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"High", @"640", @"Medium",@"Low", nil]];
    segmentVideoQuality.frame = CGRectMake(20, 72, 280, 30);
    segmentVideoQuality.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentVideoQuality.selectedSegmentIndex = 4;
    segmentVideoQuality.tintColor = [UIColor colorWithRed:.9 green:.1 blue:.1 alpha:1];
    
    
    
    [segmentVideoQuality addTarget:self action:@selector(valueChangednew:) forControlEvents: UIControlEventValueChanged];
    [baseViewref addSubview:segmentVideoQuality];

    
}

-(void)selectfilefromlib
{
    
    
    if ([[UIDevice currentDevice].model isEqual:@"iPad"])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //  UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:picker];
        self.pop=[[UIPopoverController alloc] 
                  initWithContentViewController:picker];
        picker.delegate = self; 
        
        pop.delegate = self;
        CGRect popoverRect = CGRectMake(100.0, 100.0, 100.0, 100.0);
        //[self.baseViewref convertRect:[self.baseViewref frame] fromView:[self.baseViewref superview]];
        
        NSLog(@"Rect Selected");
        [pop presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        NSLog(@"Rect Made and presented");																
        [pop setPopoverContentSize:CGSizeMake(200.0, 200.0)]; 
        
        CGPoint p = { 150.f, 150.f };
        [pieMenu showInView:baseViewref atPoint:p];

        
    /*    [pop presentPopoverFromRect:[self.baseViewref bounds]
                             inView:self
           permittedArrowDirections:UIPopoverArrowDirectionAny
                           animated:NO];*/
        
        
        // Display image picker in a popover
    }
    else
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            //混合类型 photo + movie
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        [self presentModalViewController:picker animated:YES];
        
        CGPoint p = { 150.f, 150.f };
        [pieMenu showInView:baseViewref atPoint:p];

    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self.baseViewref];
    NSLog(@"%@", NSStringFromCGPoint(p));
    
}


@end