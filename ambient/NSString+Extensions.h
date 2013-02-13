#import <Foundation/Foundation.h>

@interface NSString (Extensions)
+ (NSString *) urlPath:(NSString *)path params:(NSDictionary *)params;
@end