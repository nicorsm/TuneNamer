//
//  MainViewController.h
//  TuneNamer
//
//  Created by Nicola Giancecchi on 05/10/14.
//  Copyright (c) 2014 Nicola Giancecchi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainViewController : NSViewController{
    
    int converted;
    int not_converted_errors;
    int not_converted_tags;
    int not_converted_already_exists;
}

@property (strong) IBOutlet NSButton *btnSelectFiles;
@property (strong) IBOutlet NSButton *btnRenameFiles;
@property (strong) NSArray *fileURLs;
@property (strong) IBOutlet NSProgressIndicator *indProgress;

@end
