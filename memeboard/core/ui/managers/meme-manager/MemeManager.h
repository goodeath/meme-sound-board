//
//  MemeManager.h
//  language-learning
//
//  Created by Alex Morte on 2/1/26.
//
#import <Cocoa/Cocoa.h>
#import "../../components/meme-button/MemeButton.h"
#import "../../../models/sound/Sound.h"

@interface Meme: NSObject
-(id)init:(MemeButton *) btn sound:(Sound *) sound;
@property Sound *sound;
@property MemeButton *ui;
@end

@interface MemeManager: NSObject

@property NSArray<Meme *> *memes;

-(BOOL) addMeme:(NSURL *) url;
-(NSView *) getViewByURL:(NSURL *) url;

@end
