//
//  Sound.h
//  language-learning
//
//  Created by Alex Morte on 1/31/26.
//

#include <Cocoa/Cocoa.h>

@interface Sound: NSObject

@property NSString *name;
@property NSURL *path;
-(void)play;
-(id)init:(NSString *) filename filepath:(NSURL *)filepath;
@end
