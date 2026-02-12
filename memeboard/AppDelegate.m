//
//  AppDelegate.m
//  language-learning
//
//  Created by Alex Morte on 1/25/26.
//

#import "AppDelegate.h"
#import "filesystem/AudioSelector.h"
#import "filesystem/FilePicker.h"
#import "core/ui/components/meme-button/MemeButton.h"



@interface AppDelegate ()
- (void)save;


@end

@interface PassthroughView : NSView
@end

@implementation PassthroughView
- (NSView *)hitTest:(NSPoint)point {
    for (NSView *subview in self.subviews) {
        NSPoint p = [subview convertPoint:point fromView:self];
        NSView *hit = [subview hitTest:p];
        if (hit) return hit;
    }
    return nil;
}
@end


@implementation AppDelegate

@synthesize userName;
@synthesize imageView;

+ (void)load {
    NSLog(@"AppDelegate +load");
}
/**
 * store configuration[x]
 * copy files [x]
 * dynamic buttons [x]
 * Grid organization
 * correct trigger
 * remove buttons
 * assign custom shortcuts
 * plugin for searching and downloading from internet
 * backup/import
 * max file 500kb
 */
//
//- (void)addMemeButton
//{
//    NSImageView *view = [[NSImageView alloc] initWithFrame: CGRectMake(50, 100, 100, 100)];
//    view.image = [NSImage imageNamed:@"button.png"];
//    [self.viewc]
//    [[self window] view
//}

- (void)imageClicked:(NSClickGestureRecognizer *)recognizer {
 
    [AudioSelector pick: ^(NSURL *url){
        if(url == nil) return;
        
        NSString *urlStr = url.absoluteString;
        NSArray<NSString *> *parts = [urlStr componentsSeparatedByString:@"/"];
        NSString *name = parts.lastObject;
        Sound *sound = [[Sound alloc] init:name filepath: url];
        if(self.sounds == nil) self.sounds = [NSArray<Sound *> arrayWithObject:sound];
        else [self.sounds arrayByAddingObject:sound];
//        [sound play];
        NSLog(@"%@", url);
        
        self.memeBoard = [[MemeBoardView alloc] init];
        NSWindow *mainWindow = self.window;
        NSLog(@"%@", mainWindow);
        if(self.memeBoard && mainWindow){
//            [self.memeBoard view];
            NSLog(@"ADDING IMG");
            [mainWindow.contentView addSubview:self.memeBoard.view];
        }
    }];
}

/**
 * Add Meme Handler
 *
 * gets the meme audio file and inserts in the system
 */
- (void)addMemeHandler:(NSClickGestureRecognizer *) recognizer
{
    [FilePicker pickAndCopy: ^(NSURL *url) {
        NSLog(@"%@ %@", url, self.window);
        if(url == nil || self.window == nil) return;
        
//        NSString *urlStr = url.absoluteString;
//        NSArray<NSString *> *parts = [urlStr componentsSeparatedByString:@"/"];
//        NSString *name = parts.lastObject;
//        
//        Sound *sound = [[Sound alloc] init:name filepath: url];
//        
//        if(self.sounds == nil) self.sounds = [NSArray<Sound *> arrayWithObject:sound];
//        else [self.sounds arrayByAddingObject:sound];
//        
//        MemeButton *btn = [
//            [MemeButton alloc] initWithFrame: NSMakeRect(0, 0, 100, 100) mouseDownHandler:^(){
//            NSLog(@"Playing");
//            [sound play];
//        }];
        BOOL result = [self.memeManager addMeme:url];
        if(result){
            Meme *view = [self.memeManager getViewByURL:url];
            
            NSView *cell = [[NSView alloc] initWithFrame:NSZeroRect];
            cell.translatesAutoresizingMaskIntoConstraints = NO;


            [view.ui removeFromSuperview];
            [cell addSubview:view.ui];

            [view.ui.centerXAnchor constraintEqualToAnchor:cell.centerXAnchor].active = YES;
            [view.ui.centerYAnchor constraintEqualToAnchor:cell.centerYAnchor].active = YES;
            [self.grid addColumnWithViews:@[cell]];
//            
//            [view.ui setOnRemove:^(NSView *v){
//                NSGridCell *insertedCell = [self.grid cellForView:cell];
//                if(insertedCell != nil){
//                    NSGridColumn *r = insertedCell.column;
//                    NSInteger index = [self.grid indexOfColumn:r];
//                    [self.grid removeColumnAtIndex:index];
//                    [self.memeManager remove:v];
//                }
//            }];
            
            [view.ui setOnRemove:^(NSView *v){
                
                NSGridCell *insertedCell = [self.grid cellForView:cell];
                
                if(insertedCell != nil){
                    NSGridColumn *r = insertedCell.column;
                
                    NSInteger index = [self.grid indexOfColumn:r];
                    NSLog(@"removing at %ld", index);
                    [cell removeFromSuperview];
                    [self.grid removeColumnAtIndex:index];
                    [self.memeManager remove:v];
                    [self.grid setNeedsLayout:YES];
                    [self.grid layoutSubtreeIfNeeded];
                    [self.grid setNeedsDisplay:YES];
                }
            }];
      
            
            

//            [self.window.contentView addSubview: view];
            [self.memeManager save];
        }
    }];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    //only work outside of container
    PassthroughView *container = [[PassthroughView alloc] initWithFrame:NSZeroRect];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.memeManager = [[MemeManager alloc] init];
    self.grid = [[NSGridView alloc] init];
    self.grid.translatesAutoresizingMaskIntoConstraints = NO;
    [self.grid addRowWithViews:@[]];
    self.stack = [[NSStackView alloc] initWithFrame:NSZeroRect];
    self.stack.wantsLayer = YES;
    self.stack.layer.backgroundColor = NSColor.redColor.CGColor;

    self.stack.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    self.grid.rowAlignment = NSGridRowAlignmentFirstBaseline;
    self.stack.spacing = 50;
    self.stack.translatesAutoresizingMaskIntoConstraints = NO;
    self.stack.distribution = NSStackViewDistributionGravityAreas;
    self.stack.alignment = NSLayoutAttributeCenterY;
    [self.stack setHuggingPriority:NSLayoutPriorityRequired
                  forOrientation:NSLayoutConstraintOrientationHorizontal];
    [self.stack setContentCompressionResistancePriority:NSLayoutPriorityRequired
                                          forOrientation:NSLayoutConstraintOrientationHorizontal];
    [container addSubview:self.stack];
    self.grid.columnSpacing = 50;
    [NSLayoutConstraint activateConstraints:@[
        [self.stack.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [self.stack.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [self.stack.topAnchor constraintEqualToAnchor:container.topAnchor],
        [self.stack.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
    ]];
//    [self.grid addRowWithViews:@[container]];

//    [NSLayoutConstraint activateConstraints:@[
//        [self.grid.leadingAnchor constraintEqualToAnchor:self.window.contentView.leadingAnchor constant:20],
//        [self.grid.trailingAnchor constraintEqualToAnchor:self.window.contentView.trailingAnchor constant:-20],
//        [self.grid.topAnchor constraintEqualToAnchor:self.window.contentView.topAnchor constant:20],
//        [self.grid.bottomAnchor constraintEqualToAnchor:self.window.contentView.bottomAnchor constant:-20],
//    ]];
    
    [self.window.contentView addSubview:self.grid];
    [NSLayoutConstraint activateConstraints:@[
        [self.grid.leadingAnchor constraintEqualToAnchor:self.window.contentView.leadingAnchor constant:20],
        [self.grid.topAnchor constraintEqualToAnchor:self.window.contentView.topAnchor constant:150]
    ]];


   
//    NSAlert *alert = [[NSAlert alloc] init];
//        alert.messageText = @"AppDelegate is alive";
//        [alert runModal];
    // Insert code here to initialize your application
    self.userName = NSFullUserName();
    NSLog(@"Image clicked!");
//    self.imageView.userInteractionEnabled = YES;
//
    NSClickGestureRecognizer *click =
        [[NSClickGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(addMemeHandler:)];

    [self.addMemeBtn addGestureRecognizer:click];
//
//    
    self.memeBoard = [[MemeBoardView alloc] init];
////    NSWindow *mainWindow = [NSApp mainWindow];
//    NSWindow *mainWindow =  self.window;
//    NSLog(@"%@ asd",self.window);
//    if(self.memeBoard && mainWindow){
//        [self.memeBoard view];
//        NSLog(@"ADDING IMG");
////        [mainWindow setContentViewController:self.memeBoard];
//        [[mainWindow contentView] addSubview: self.memeBoard.view];
//        NSLog(@"Window frame: %@", NSStringFromRect(mainWindow.frame));
//        NSLog(@"Content view frame: %@", NSStringFromRect(mainWindow.contentView.frame));
//    }
    [self.memeManager restore];
    for(Meme *meme in self.memeManager.memes){
        NSLog(@"%@", meme.sound.path);
//        MemeButton *button = meme.ui;
//        Meme const *currentMeme = [[Meme alloc] init:meme.ui sound:meme.sound];
        // IMPORTANT: disable autoresizing
//        currentMeme.ui.translatesAutoresizingMaskIntoConstraints = NO;
        
        // con
        NSView *cell = [[NSView alloc] initWithFrame:NSZeroRect];
        cell.translatesAutoresizingMaskIntoConstraints = NO;
        cell.wantsLayer = YES;

        [meme.ui removeFromSuperview];
        [cell addSubview:meme.ui];

        [meme.ui.centerXAnchor constraintEqualToAnchor:cell.centerXAnchor].active = YES;
        [meme.ui.centerYAnchor constraintEqualToAnchor:cell.centerYAnchor].active = YES;
        
        // con

//        // Size control (this replaces container tricks)
//        [currentMeme.ui.widthAnchor constraintEqualToConstant:100].active = YES;
//        [currentMeme.ui.heightAnchor constraintEqualToConstant:300].active = YES;
//        
        [self.grid addColumnWithViews:@[cell]];
        

        [meme.ui setOnRemove:^(NSView *v){
            
            NSGridCell *insertedCell = [self.grid cellForView:cell];
            
            if(insertedCell != nil){
                NSGridColumn *r = insertedCell.column;
            
                NSInteger index = [self.grid indexOfColumn:r];
                NSLog(@"removing at %ld", index);
                [cell removeFromSuperview];
                [self.grid removeColumnAtIndex:index];
                [self.memeManager remove:v];
                [self.grid setNeedsLayout:YES];
                [self.grid layoutSubtreeIfNeeded];
                [self.grid setNeedsDisplay:YES];
            }
        }];
  
//        return;
//        [self.stack addArrangedSubview: meme.ui];
    }
    self.stack.distribution = NSStackViewDistributionGravityAreas;
    NSLog(@"dist=%ld spacing=%.1f",
          self.stack.distribution,
          self.stack.spacing);

}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"language_learning"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving and Undo support

- (void)save {
    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    NSManagedObjectContext *context = self.persistentContainer.viewContext;

    if (![context commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    NSError *error = nil;
    if (context.hasChanges && ![context save:&error]) {
        // Customize this code block to include application-specific recovery steps.              
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
    return self.persistentContainer.viewContext.undoManager;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Save changes in the application's managed object context before the application terminates.
    NSManagedObjectContext *context = self.persistentContainer.viewContext;

    if (![context commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (!context.hasChanges) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![context save:&error]) {

        // Customize this code block to include application-specific recovery steps.
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertSecondButtonReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
