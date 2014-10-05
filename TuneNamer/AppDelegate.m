//
//  AppDelegate.m
//  TuneNamer
//
//  Created by Nicola Giancecchi on 05/10/14.
//  Copyright (c) 2014 Nicola Giancecchi. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    // 1. Create the master View Controller
    self.mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    // 2. Add the view controller to the Window's content view
    [self.window.contentView addSubview:self.mainVC.view];
    [self.window setStyleMask:[self.window styleMask] & ~NSResizableWindowMask];
    self.mainVC.view.frame = ((NSView*)self.window.contentView).bounds;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
