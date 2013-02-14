#import <Foundation/Foundation.h>

@interface User : NSObject
+ (User *)from:(id)json;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *first;
@property (strong, nonatomic) NSString *last;
@property (readonly, strong, nonatomic) NSString *name;
@end