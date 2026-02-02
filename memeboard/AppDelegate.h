//
//  AppDelegate.h
//  language-learning
//
//  Created by Alex Morte on 1/25/26.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>
#import "core/models/sound/Sound.h"
#import "core/ui/MemeBoardView.h"
#import "core/ui/managers/meme-manager/MemeManager.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property MemeManager *memeManager;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (copy) NSString * userName;
@property (weak) IBOutlet NSImageView *imageView;
@property NSArray<Sound *> *sounds;
@property (strong) MemeBoardView *memeBoard;
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSButton *addMemeBtn;

//-(NSImageView *)addMemeButton;

@end

