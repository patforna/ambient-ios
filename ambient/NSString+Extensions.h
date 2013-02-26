#import <Foundation/Foundation.h>

@interface NSString (Extensions)
+ (NSString *) urlFor:(NSString *)base params:(NSDictionary *)params;
@end