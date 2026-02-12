//
//  MemeButton.h
//  language-learning
//
//  Created by Alex Morte on 2/1/26.
//
#import <Cocoa/Cocoa.h>
typedef void (^MouseDownHandler)(void);
typedef void (^OnRemoveHandler)(NSView *);

@interface MemeButton: NSView
- (id)initWithMouseDownEvent:(MouseDownHandler) handler;
- (id)initWithFrame:(NSRect)frame mouseDownHandler:(MouseDownHandler)handler;
- (void)setOnRemoveHandler:(OnRemoveHandler)handler;
- (void)remove:(id)sender;
@property OnRemoveHandler onRemove;
@property MouseDownHandler onMouseDown;
@end


