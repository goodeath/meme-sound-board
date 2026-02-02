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


- (NSDictionary *)toDictionary {
    return @{
        @"url": self.sound.path.absoluteString
    };
}

@end

@implementation MemeManager

-(id)init
{
    self = [super init];
    self.memes = [[NSArray<Meme *> alloc] init];
    [self restore];
    return self;
}

-(void)save
{
    NSArray *jsonData = [self.memes valueForKey:@"toDictionary"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:nil];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *url = [[fm URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] firstObject];
    [fm createDirectoryAtPath:url.path withIntermediateDirectories:YES attributes:nil error:nil];
    url = [url URLByAppendingPathComponent:@"config.json"];
    
    
    NSError *error = nil;
    
    BOOL success = [data writeToFile:url.path options: NSDataWritingAtomic error:&error];
    if (!success) {
        NSLog(@"Write error: %@", error);
    }
    NSLog(@"SAVING %@",url);
}

-(void)restore
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSURL *url = [[fm URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] firstObject];
    url = [url URLByAppendingPathComponent:@"config.json"];
    BOOL exists = [fm fileExistsAtPath:url.path];
    NSLog(@"%@ %b", url, exists);
    if(!exists) return;
    NSData *data = [NSData dataWithContentsOfFile:url.absoluteString];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
  
    for(NSDictionary *dict in array){
        NSString *url = [dict valueForKey:@"url"];
        [self addMeme: [NSURL URLWithString:url]];
    }
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
