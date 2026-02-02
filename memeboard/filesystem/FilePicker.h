//
//  AudioSelector.h
//  language-learning
//
//  Created by Alex Morte on 1/31/26.
//
#include <Cocoa/Cocoa.h>

typedef void (^FilePickerCallback)(NSURL *fileURL);

@interface FilePicker: NSObject
+ (void) pick: (FilePickerCallback) completion;
+ (void) pickAndCopy: (FilePickerCallback) completion;
@end
