//
//  AudioSelector.m
//  language-learning
//
//  Created by Alex Morte on 1/31/26.
//

#include "FilePicker.h"
@import UniformTypeIdentifiers;

@implementation FilePicker

+(void)pick:(FilePickerCallback) completion {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseFiles = YES;
    panel.canChooseDirectories = NO;
    panel.allowedContentTypes = @[UTTypeMP3];
    [panel beginWithCompletionHandler:^(NSModalResponse result) {
        if(result == NSModalResponseOK)
            completion(panel.URL);
        else
            completion(nil);
    }];
}

+ (void)pickAndCopy:(__strong FilePickerCallback)completion {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseFiles = YES;
    panel.canChooseDirectories = NO;
    panel.allowedContentTypes = @[UTTypeMP3];
    [panel beginWithCompletionHandler:^(NSModalResponse result) {
        if(result != NSModalResponseOK) {
            completion(nil);
            return;
        }
        
        NSString *urlStr = panel.URL.absoluteString;
        NSArray<NSString *> *parts = [urlStr componentsSeparatedByString:@"/"];
        NSString *name = parts.lastObject;
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSURL *url = [[fm URLsForDirectory:NSApplicationSupportDirectory
                          inDomains:NSUserDomainMask
                      ] firstObject];
        url = [url URLByAppendingPathComponent:name];
        // Create dir
        BOOL dirResult = [fm createDirectoryAtPath:url.absoluteString
            withIntermediateDirectories:YES
            attributes:nil error:nil];
        if(!dirResult)
            NSLog(@"ERROR CREATING");
        
        [fm copyItemAtURL:panel.URL toURL:url error:nil];
        
         
        completion(url);
        
    }];
}

@end
