//
//  AudioSelector.h
//  language-learning
//
//  Created by Alex Morte on 1/31/26.
//
#include <Cocoa/Cocoa.h>

typedef void (^AudioPickCallback)(NSURL *fileURL);

@interface AudioSelector: NSObject
+ (void) pick: (AudioPickCallback) completion;
@end
