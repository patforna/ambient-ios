#import "NSArray+Extensions.h"

@implementation NSArray (Extensions)
- (NSArray *)map:(MapBlock)block {
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for (id item in self) {
        [result addObject:block(item)];
    }
    return result;
}
@end