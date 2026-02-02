//
//  MemeButton.h
//  language-learning
//
//  Created by Alex Morte on 2/1/26.
//
#import <Cocoa/Cocoa.h>
typedef void (^MouseDownHandler)(void);

@interface MemeButton: NSView
- (id)initWithMouseDownEvent:(MouseDownHandler) handler;
- (id)initWithFrame:(NSRect)frame mouseDownHandler:(MouseDownHandler)handler;
@property MouseDownHandler onMouseDown;
@end
