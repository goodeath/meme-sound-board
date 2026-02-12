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

@property Sound *sound;
@property MemeButton *ui;

-(id)init:(MemeButton *) btn sound:(Sound *) sound;
-(NSDictionary *)toDictionary;

@end

@interface MemeManager: NSObject

@property NSMutableArray<Meme *> *memes;


-(BOOL) addMeme:(NSURL *) url;
-(Meme *) getViewByURL:(NSURL *) url;
-(void)save;
-(void)restore;
-(Meme *) remove:(NSView *)obj;


@end
