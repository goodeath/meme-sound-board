//
//  sound.m
//  language-learning
//
//  Created by Alex Morte on 1/31/26.
//
#include "Sound.h"

@implementation Sound

@synthesize name;
@synthesize path;

-(void)play
{
    NSSound *content = [[NSSound alloc] initWithContentsOfURL:self.path byReference:YES];
    [content play];
}

-(id)init:(NSString *)filename filepath:( NSURL *)filepath
{
    self = [super init];
    
    self.name = filename;
    self.path = filepath;
    
    return self;
}

@end
