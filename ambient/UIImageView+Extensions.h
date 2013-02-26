#import <Foundation/Foundation.h>

typedef void (^FinallyBlock)();

@interface UIImageView (Extensions)
- (void)loadImage:(NSString *)url finally:(FinallyBlock)finally;
@end