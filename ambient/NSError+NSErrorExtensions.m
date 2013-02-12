#import "NSError+NSErrorExtensions.h"
#import "Constants.h"

@implementation NSError (NSErrorExtensions)

+ (NSError *)error:(NSString *)message {
    NSString *domain = REVERSE_DOMAIN;
    NSString *desc = NSLocalizedString(message, EMPTY_STRING);
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : desc};

    return [NSError errorWithDomain:domain code:nil userInfo:userInfo];
}

@end