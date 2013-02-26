#import "UIImageView+Extensions.h"
#import "AFNetworking.h"

@implementation UIImageView (Extensions)

- (void)loadImage:(NSString *)url finally:(FinallyBlock)finally {
    NSLog(@"GET: %@\n", url);

    showNetworkActivityIndicator();

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPShouldHandleCookies:NO];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        hideNetworkActivityIndicator();        
        self.image = image;
        if (finally) finally();
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        hideNetworkActivityIndicator();
        if (finally) finally();
    }];
}

static void showNetworkActivityIndicator() {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
}

static void hideNetworkActivityIndicator() {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
}


@end