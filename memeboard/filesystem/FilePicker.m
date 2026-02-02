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

@end
