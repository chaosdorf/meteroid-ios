#import <UIKit/UIKit.h>


@interface GravatarLoader : NSObject {
  @private
	id target;
	SEL handle;
    NSURL *urlImage;
}

- (id)initWithTarget:(id)theTarget andHandle:(SEL)theHandle;
- (NSURL*)loadEmail:(NSString *)theEmail withSize:(NSInteger)theSize;

@end

