#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>

#import "ZPNowPlayingItemInfoView.h"
#import "ZPGlobals.h"

//////////////////////////
// What We Need To Know //
//////////////////////////

@interface MPAVController : NSObject

-(void)changePlaybackIndexBy:(long long)amount;

@end


@interface MPUNowPlayingViewController : UIViewController<UIGestureRecognizerDelegate>

@property(retain) MPAVController* player;

-(id)_effectiveNavigationItem;

-(void)setupGesturesForContentView:(UIView*)contentView;
-(void)setupInfoViewWithContentView:(UIView*)contentView;

-(ZPNowPlayingItemInfoView*)infoView;

@end

@interface MPAVItem : NSObject
@end

///////////
// Tweak //
///////////

%hook MPUNowPlayingViewController
	
%new
-(ZPNowPlayingItemInfoView*)infoView
{
	ZPNowPlayingItemInfoView *infoView = nil;
	
	for (UIView *subview in self.view.subviews) {
		if ([subview isKindOfClass:[ZPNowPlayingItemInfoView class]]) {
			infoView = (ZPNowPlayingItemInfoView*)subview;
		}
	}
	
	return infoView;
}
	
%new
-(void)panDetected:(UIPanGestureRecognizer*)panGR
{
	static CGPoint lastCenter;
	static BOOL goingUp;
	
	UIView *contentView = MSHookIvar<UIView*>(self, "_contentView");
	
	ZPNowPlayingItemInfoView *infoView = [self infoView];
		
	if (panGR.state == UIGestureRecognizerStateBegan) 
	{		
		[infoView setAlpha:1.f];
	
		lastCenter = [contentView center];
	} 
	else if (panGR.state == UIGestureRecognizerStateChanged)
	{		
		CGPoint translatedPoint = [panGR translationInView:contentView];
										
		CGFloat nextY = contentView.frame.origin.y + translatedPoint.y;
				
		if (nextY <= self.topLayoutGuide.length && 
			nextY >= -contentView.frame.size.height + self.topLayoutGuide.length + ZP_ARTWORK_VISIBLE_AREA_WHEN_UP)
		{
			[contentView setCenter:
					CGPointMake(contentView.center.x, 
				            	contentView.center.y + translatedPoint.y)];	
		
			goingUp = contentView.center.y < lastCenter.y;
		}
		
		[panGR setTranslation:CGPointZero inView:contentView];
		
		lastCenter = [contentView center];
	}
	else if (panGR.state == UIGestureRecognizerStateEnded)
	{					
		[panGR setEnabled:NO];
		
		if (goingUp) 
		{
			[UIView animateWithDuration:0.45f 
				delay:0.f 
				usingSpringWithDamping:0.6f
				initialSpringVelocity:0.15f
				options:0
			 	animations:^{
								
					contentView.frame =
						CGRectMake(0,
					               -contentView.frame.size.height + self.topLayoutGuide.length + ZP_ARTWORK_VISIBLE_AREA_WHEN_UP,
								   contentView.frame.size.width,
								   contentView.frame.size.height);
				
				} completion:^(BOOL finished) {
					
					[panGR setEnabled:YES];
					
				}];
				
		}
		else
		{
			[UIView animateWithDuration:0.45f 
				delay:0.f 
				usingSpringWithDamping:0.6f 
				initialSpringVelocity:0.15f 
				options:0
			 	animations:^{
				
				contentView.frame =
					CGRectMake(0,
				               self.topLayoutGuide.length,
							   contentView.frame.size.width,
							   contentView.frame.size.height);
				
			} completion:^(BOOL finished) {
					
					[infoView setAlpha:0.f];
					[panGR setEnabled:YES];
					
			}];
		}
	}
}
	
%new
-(void)horizontalSwipeDetected:(UISwipeGestureRecognizer*)gestureRecognizer
{
		
	if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft)
	{
		[self.player changePlaybackIndexBy:1]; 
		
	} 
	else 
	{
		[self.player changePlaybackIndexBy:-1]; 
	}
	
}	

%new
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gr 
	shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)other
{
	return NO;
}

%new
-(void)setupInfoViewWithContentView:(UIImageView*)contentView
{	
	id item = MSHookIvar<MPAVItem*>(self, "_item");
	
	ZPNowPlayingItemInfoView *infoView = 
		[[ZPNowPlayingItemInfoView alloc] initWithItem:item
			                              artworkImage:[contentView image]];
			
	[infoView setTranslatesAutoresizingMaskIntoConstraints:NO];
			
	[self.view addSubview:infoView];
	[infoView release];
	
	NSArray *infoViewVC = [NSLayoutConstraint constraintsWithVisualFormat:
		@"V:[guide][infoView(infoViewHeight)]"
		options:0
		metrics:@{@"infoViewHeight":@(contentView.frame.size.height)}
		views:@{@"infoView":infoView, @"guide": self.topLayoutGuide}];
		
	NSArray *infoViewHC = [NSLayoutConstraint constraintsWithVisualFormat:
		@"H:|[infoView]|"
		options:0
		metrics:@{}
		views:@{@"infoView":infoView}];
		
	[self.view addConstraints:infoViewVC];
	[self.view addConstraints:infoViewHC];
		
	[self.view bringSubviewToFront:contentView];
		
	[infoView setAlpha:0.f];
}

%new
-(void)setupGesturesForContentView:(UIImageView*)contentView
{		
	UISwipeGestureRecognizer *leftSwipeGR = 
		[[UISwipeGestureRecognizer alloc] initWithTarget:self 
			                                      action:@selector(horizontalSwipeDetected:)];
	leftSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
	
	UISwipeGestureRecognizer *rightSwipeGR = 
		[[UISwipeGestureRecognizer alloc] initWithTarget:self 
			                                      action:@selector(horizontalSwipeDetected:)];
	rightSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
	
	UIPanGestureRecognizer *panGR = 
		[[UIPanGestureRecognizer alloc] initWithTarget:self 
			                                    action:@selector(panDetected:)];
	
	leftSwipeGR.delegate = self;
	rightSwipeGR.delegate = self;
	panGR.delegate = self;
		
	[contentView addGestureRecognizer:leftSwipeGR];
	[contentView addGestureRecognizer:rightSwipeGR];
	[contentView addGestureRecognizer:panGR];
	
	[panGR requireGestureRecognizerToFail:leftSwipeGR];
	[panGR requireGestureRecognizerToFail:rightSwipeGR];
	
	[leftSwipeGR release];
	[rightSwipeGR release];
	[panGR release];
}

-(id)_createContentViewForItem:(id)item contentViewController:(id*)contentVC
{
	UIImageView *contentView = %orig;
	
	[self setupInfoViewWithContentView:contentView];
	[self setupGesturesForContentView:contentView];

	return contentView;
}


/////////////
// Sharing //
/////////////

- (id)_effectiveNavigationItem
{
	UINavigationItem *navItem = %orig;
	
	if (navItem.rightBarButtonItems.count == 1) {
			
		UIBarButtonItem *shareBtn = 
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
									    	              target:self 
									                      action:@selector(shareTapped:)]; //!//
		
		id rightButtons = [navItem.rightBarButtonItems mutableCopy]; //!//
		[rightButtons addObject:shareBtn];  //!//
		
		[shareBtn release];
				
		[navItem setRightBarButtonItems:rightButtons];
		
		[rightButtons release];
			
	}
	
	return navItem;
}
	
%new
-(void)shareTapped:(id)sender
{				
	id item = MSHookIvar<MPAVItem*>(self, "_item");
	AVURLAsset *currentAsset = MSHookIvar<AVURLAsset*>(item, "_asset");
		
	NSArray *activityItems = @[currentAsset.URL];

	UIActivityViewController *activityVC = 
		[[UIActivityViewController alloc] initWithActivityItems:activityItems 
										  applicationActivities:nil];
	
	[self presentViewController:activityVC animated:YES completion:^{
		
		[activityVC release];
		
	}];
	
}
%end

