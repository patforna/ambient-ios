#import "NSString+Extensions.h"

@implementation NSString (Extensions)
+ (NSString *)urlFor:(NSString *)base params:(NSDictionary *)params {
    if (params == nil || [params count] == 0) return base;

    NSMutableArray *keyValuePairs = [NSMutableArray arrayWithCapacity:[params count]];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        [keyValuePairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }];

    return [NSString stringWithFormat:@"%@?%@", base, [keyValuePairs componentsJoinedByString:@"&"]];
}
@end