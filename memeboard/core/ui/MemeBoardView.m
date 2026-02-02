//
//  MemeBoardView.m
//  language-learning
//
//  Created by Alex Morte on 2/1/26.
//
#import <Cocoa/Cocoa.h>
#import "MemeBoardView.h"

@implementation MemeBoardView

- (void)loadView {
    NSView *view = [[NSView alloc] initWithFrame: NSMakeRect(0, 0, 100, 100)];
    view.wantsLayer = YES;
    view.layer.backgroundColor = [[NSColor greenColor] CGColor];
    self.view = view;
    NSLog(@"loading");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSImageView *img = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
    img.image = [NSImage imageNamed:@"button.png"];
    img.layer.borderColor = [[NSColor redColor] CGColor];
    img.layer.borderWidth = 2.0;
    
    
    NSClickGestureRecognizer *click = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
    [img addGestureRecognizer:click];
    [self.view addSubview:img];
    NSLog(@"loaded");
}

- (void)onClick:(NSClickGestureRecognizer *)gesture {
    NSLog(@"cliclicliked");
}

@end
