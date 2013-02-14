#import <Foundation/Foundation.h>

typedef id(^MapBlock)(id);

@interface NSArray (Extensions)
- (NSArray *)map:(MapBlock)block;
@end