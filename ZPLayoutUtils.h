#import <Foundation/Foundation.h>

#define IPAD_K(CONSTANT) [ZPLayoutUtils constantForiPad:CONSTANT]

@interface ZPLayoutUtils : NSObject

+(CGFloat)constantForiPad:(CGFloat)ipadConstant;
	
@end