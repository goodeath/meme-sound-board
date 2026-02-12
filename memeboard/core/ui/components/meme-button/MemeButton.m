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

- (NSView *)hitTest:(NSPoint)point {
    return self;
}

-(void)remove:(id)sender {
    NSLog(@"Removing2");
    if(self.onRemove)
        self.onRemove(self);
    
}

- (id)initWithFrame:(NSRect)frame
             mouseDownHandler:(MouseDownHandler)handler
           
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Menu"];
    NSMenuItem *item = [[NSMenuItem alloc]
                        initWithTitle:@"Remove"
                        action:@selector(remove:)
                        keyEquivalent:@""];
    

    self.onMouseDown = handler;

    NSImageView *img =
        [[NSImageView alloc] initWithFrame:self.bounds];
    img.wantsLayer = YES;
    self.wantsLayer = YES;
    img.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [img.widthAnchor constraintEqualToConstant:100],
        [img.heightAnchor constraintEqualToConstant:100]
    ]];
    img.image = [NSImage imageNamed:@"button"];
    item.target = self;
//    [item setTarget:self];
    [menu addItem: item];
    [self setMenu:menu];
//    img.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;


    [self addSubview:img];

    return self;
}

- (BOOL)acceptsFirstResponder {
    return YES;
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

-(void)setOnRemoveHandler:(OnRemoveHandler)onRemove {
    NSLog(@"Setting on remove %@", onRemove);
    self.onRemove = onRemove;
}

- (void)mouseDown:(NSEvent *)event {
    NSLog(@"MOUSE DOWN EVENT");
    if(self.onMouseDown) self.onMouseDown();
}

@end
