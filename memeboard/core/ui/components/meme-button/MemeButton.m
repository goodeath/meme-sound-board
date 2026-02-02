//
//  MemeButton.m
//  language-learning
//
//  Created by Alex Morte on 2/1/26.
//
#import "MemeButton.h"
#import "../../../../filesystem/FilePicker.h"

@implementation MemeButton

- (id)initWithMouseDownEvent:(MouseDownHandler) handler {
    self = [super init];
    self.onMouseDown = handler;
    return self;
}

- (id)initWithFrame:(NSRect)frame
             mouseDownHandler:(MouseDownHandler)handler
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.onMouseDown = handler;

    NSImageView *img =
        [[NSImageView alloc] initWithFrame:self.bounds];
    img.image = [NSImage imageNamed:@"button"];
    img.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

    [self addSubview:img];

    return self;
}


- (void)drawRect:(NSRect)dirtyRect {
    
//    NSImageView *img = [[NSImageView alloc]
//                        initWithFrame:NSMakeRect(0, 0, 100, 100)];
//    img.image = [NSImage imageNamed:@"button.png"];
//    NSClickGestureRecognizer *click =
//        [[NSClickGestureRecognizer alloc] initWithTarget:self
//                                                  action:@selector(mouseDown:)];
//    [img addGestureRecognizer:click];
//    [self addSubview:img];
}

- (void)mouseDown:(NSEvent *)event {
    NSLog(@"MOUSE DOWN EVENT");
    if(self.onMouseDown) self.onMouseDown();
}

@end
