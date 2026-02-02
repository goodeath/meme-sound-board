//
//  AudioSelector.m
//  language-learning
//
//  Created by Alex Morte on 1/31/26.
//

#include "AudioSelector.h"
@import UniformTypeIdentifiers;

@implementation AudioSelector

+(void)pick:(AudioPickCallback) completion {
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
