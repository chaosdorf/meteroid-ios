#import <Foundation/Foundation.h>

@interface Url : NSObject

- (NSString *)encodeToPercentEscapeString:(NSString *)string;
- (NSString *)decodeFromPercentEscapeString:(NSString *)string;

@end
