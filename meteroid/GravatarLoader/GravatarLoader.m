#import <CommonCrypto/CommonDigest.h>
#import "GravatarLoader.h"


// This solution to generate a MD5 hash originates from the Apple Developer Forums.
// Details: http://discussions.apple.com/message.jspa?messageID=7362074#7362074
NSString *md5(NSString *str) {
	const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, strlen(cStr), result);
	return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", 
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
} 


@interface GravatarLoader ()
- (void)requestWithArgs:(NSArray *)theArgs;
@end


@implementation GravatarLoader

- (id)initWithTarget:(id)theTarget andHandle:(SEL)theHandle {
	target = theTarget;
	handle = theHandle;
	return self;
}

- (NSURL*)loadEmail:(NSString *)theEmail withSize:(NSInteger)theSize {
	NSArray *args = [[NSArray alloc] initWithObjects:theEmail, [NSNumber numberWithInteger:theSize], nil];
    //[self performSelectorInBackground:@selector(requestWithArgs:) withObject:args];
    [self performSelector:@selector(requestWithArgs:) withObject:args];
    
    return urlImage;
}

- (void)requestWithArgs:(NSArray *)theArgs {
	NSString *email = [[theArgs objectAtIndex:0] lowercaseString];
	NSInteger size = [[theArgs objectAtIndex:1] integerValue];
	NSString *url = [NSString stringWithFormat:@"https://www.gravatar.com/avatar/%@?s=%d", md5(email), size];
	
    urlImage = [NSURL URLWithString:url];
}


@end
