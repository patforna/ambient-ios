#import "NSString+Extensions.h"

@implementation NSString (Extensions)
+ (NSString *)urlPath:(NSString *)path params:(NSDictionary *)params {
    if (params == nil || [params count] == 0) return path;

    NSMutableArray *keyValuePairs = [NSMutableArray arrayWithCapacity:[params count]];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        [keyValuePairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }];

    return [NSString stringWithFormat:@"%@?%@", path, [keyValuePairs componentsJoinedByString:@"&"]];
}
@end