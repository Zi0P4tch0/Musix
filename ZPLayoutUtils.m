#import "ZPLayoutUtils.h"

@implementation ZPLayoutUtils

+(CGFloat)constantForiPad:(CGFloat)ipadConstant
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return ipadConstant;
	} 
	return 0.f;
	
}

@end