#import "UIView+Positioning.h"

@implementation UIView (Positioning)

-(CGFloat)top
{
	return self.frame.origin.y;
}

-(CGFloat)bottom
{
	return [self top] + self.frame.size.height;
}

-(CGFloat)left
{
	return self.frame.origin.x;
}

-(CGFloat)right
{
	return [self left] + self.frame.size.width;
}

-(CGFloat)width
{
	return self.frame.size.width;
}

-(CGFloat)height
{
	return self.frame.size.height;
}

-(void)setTop:(CGFloat)top
{
	self.frame = 
		CGRectMake(self.frame.origin.x, 
	               top, 
				   self.frame.size.width, 
				   self.frame.size.height);
}

-(void)setBottom:(CGFloat)bottom
{
	self.frame = 
		CGRectMake(self.frame.origin.x, 
	               bottom - self.frame.size.height, 
				   self.frame.size.width, 
				   self.frame.size.height);
}

-(void)setLeft:(CGFloat)left
{
	self.frame = 
		CGRectMake(left, 
	               self.frame.origin.y, 
				   self.frame.size.width, 
				   self.frame.size.height);
}

-(void)setRight:(CGFloat)right
{
	self.frame = 
		CGRectMake(right - self.frame.size.width, 
	               self.frame.origin.y, 
				   self.frame.size.width, 
				   self.frame.size.height);
}

@end