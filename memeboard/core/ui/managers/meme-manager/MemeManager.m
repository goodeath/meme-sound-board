//
//  MemeManager.m
//  language-learning
//
//  Created by Alex Morte on 2/1/26.
//
#import "MemeManager.h"

@implementation Meme
-(id)init:(MemeButton *)btn sound:(Sound *)sound {
    self = [super init];
    self.sound = sound;
    self.ui = btn;
    return self;
}
@end

@implementation MemeManager

-(id)init
{
    self = [super init];
    self.memes = [[NSArray<Meme *> alloc] init];
    return self;
}

-(BOOL)addMeme:(NSURL *) url
{
    
    NSString *urlStr = url.absoluteString;
    NSArray<NSString *> *parts = [urlStr componentsSeparatedByString:@"/"];
    NSString *name = parts.lastObject;
    
    Sound *sound = [[Sound alloc] init:name filepath: url];
    
    if(sound == nil) return NO;
    
    MemeButton *btn = [
        [MemeButton alloc] initWithFrame: NSMakeRect(0, 0, 100, 100) mouseDownHandler:^(){
        NSLog(@"Playing");
        [sound play];
    }];

    Meme *meme = [[Meme alloc] init: btn sound:sound];
    if(!meme) return NO;
    self.memes = [self.memes arrayByAddingObject: meme];
    return YES;
}

-(NSView *) getViewByURL:(NSURL *) url {
    for(Meme* meme in self.memes){
        if(meme.sound.path == url) return meme.ui;
    }
    return nil;
}

@end
