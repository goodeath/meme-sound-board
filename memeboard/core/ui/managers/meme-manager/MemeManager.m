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
    self.memes = [[NSMutableArray<Meme *> alloc] init];

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
    NSData *data = [NSData dataWithContentsOfFile:url.path];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"%@", array);
    for(NSDictionary *dict in array){
        NSString *url = [dict valueForKey:@"url"];
        [self addMeme: [NSURL URLWithString:url]];

    }
}

-(BOOL)addMeme:(NSURL *) url
{
    NSLog(@"%@ adding", url.absoluteString);
    NSString *urlStr = url.absoluteString;
    NSArray<NSString *> *parts = [urlStr componentsSeparatedByString:@"/"];
    NSString *name = parts.lastObject;
    
    Sound *sound = [[Sound alloc] init:name filepath: [url copy]];
    
    if(sound == nil) return NO;
    
    Sound * const capturedSound = sound;
     
        
    MemeButton *btn = [
        [MemeButton alloc] initWithFrame: NSMakeRect(0, 0, 100, 100) mouseDownHandler:^(){
            
            NSString *a = [name copy];
        NSLog(@"Playing %@ %@", a, url.absoluteString);
        [capturedSound play];
    }  ];

    Meme *meme = [[Meme alloc] init: btn sound:capturedSound];
    if(!meme) return NO;
    
    [self.memes addObject: meme];
    if([name isEqual:@"tf_nemesis.mp3"])  return NO;
    return YES;
}

-(Meme *) getViewByURL:(NSURL *) url {
    for(Meme* meme in self.memes){
        if(meme.sound.path == url) return meme;
    }
    return nil;
}

-(Meme *) remove:(NSView *)obj {
    Meme *found = nil;
    NSLog(@"rem %@", obj);
    for(Meme* meme in self.memes){
        NSLog(@"rem %@", meme.ui);
        if(meme.ui == obj) {
            NSLog(@"FOUND");
            found = meme;
            break;
        }
    }
    [self.memes removeObject:found];
    [self save];
    return found;
}

@end
