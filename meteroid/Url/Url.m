#import "Url.h"

@implementation Url

// http://cybersam.com/ios-dev/proper-url-percent-encoding-in-ios
// Encode a string to embed in an URL.
- (NSString *)encodeToPercentEscapeString:(NSString *)string {
    return (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (__bridge CFStringRef) string,
                                            NULL,
                                            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
}

// http://cybersam.com/ios-dev/proper-url-percent-encoding-in-ios
// Decode a percent escape encoded string.
- (NSString *)decodeFromPercentEscapeString:(NSString *)string {
    return (__bridge NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                            (__bridge CFStringRef) string,
                                                            CFSTR(""),
                                                            kCFStringEncodingUTF8);
}

@end
