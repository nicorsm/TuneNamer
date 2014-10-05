//
//  MainViewController.m
//  TuneNamer
//
//  Created by Nicola Giancecchi on 05/10/14.
//  Copyright (c) 2014 Nicola Giancecchi. All rights reserved.
//

#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MainViewController ()

@end

@implementation MainViewController


- (IBAction)didSelectFiles:(id)sender {
    
    
    // Create the File Open Dialog class.
    NSOpenPanel* open = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    open.canChooseFiles = YES;
    open.allowsMultipleSelection = YES;
    open.canChooseDirectories = NO;
    open.allowedFileTypes = @[@"mp4",@"m4a",@"mp3",@"aac",@"aif",@"wav",@"wma"];
    
    [open beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            self.fileURLs = [open URLs];
            [self.btnRenameFiles setEnabled:self.fileURLs.count>0];
        }
        
    }];

}
- (IBAction)didRename:(id)sender {

    [self.indProgress setHidden:NO];
    [self.indProgress startAnimation:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self rename_async];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didFinishRenaming];
        });
    });
}

-(void)rename_async{
    
    // Loop through all the files and process them.
    for(NSURL *url in self.fileURLs)
    {
        AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        NSArray *metadata = [asset commonMetadata];
        NSString *artist = nil;
        NSString *title = nil;
        
        for ( AVMetadataItem* item in metadata ) {
            if([item.commonKey isEqual:@"artist"]){
                artist = [item.stringValue stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
            } else if([item.commonKey isEqual:@"title"]){
                title = [item.stringValue stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
            }
        }
        
        NSURL *newURL = nil;
        
        if(artist && title){
            NSString *oldFile = [[url path] stringByDeletingLastPathComponent];
            NSString *formatted = [oldFile stringByAppendingFormat:@"/%@ - %@.%@", artist, title, url.pathExtension];
            newURL = [[NSURL fileURLWithPath:formatted isDirectory:NO] standardizedURL];
        }
        
        if(newURL){
            NSError *error;
            if(![[NSFileManager defaultManager] fileExistsAtPath:newURL.path isDirectory:NO]){
                [[NSFileManager defaultManager] moveItemAtURL:url toURL:newURL error:&error];
                
                if(error)
                    not_converted_errors++;
                else
                    converted++;
            } else {
                not_converted_already_exists++;
            }
            
        } else {
            not_converted_tags++;
        }
    }
 
}

-(void)didFinishRenaming{
    
    [self.indProgress setHidden:YES];
    [self.indProgress stopAnimation:nil];
    self.fileURLs = nil;
    [self.btnRenameFiles setEnabled:self.fileURLs.count>0];
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"TuneNamer report"];
    [alert setInformativeText:[NSString stringWithFormat:@"%d filenames modified successfully\n%d filenames not modified for lack of ID3 tags\n%d filenames not modified because they already exists\n%d filenames not modified for errors", converted, not_converted_tags, not_converted_already_exists, not_converted_errors]];
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal];
    
    converted = 0;
    not_converted_tags = 0;
    not_converted_errors = 0;
    not_converted_already_exists = 0;
    
}

@end
