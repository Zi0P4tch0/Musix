#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>

#import "ZPNowPlayingItemInfoView.h"

//////////////////////////
// What We Need To Know //
//////////////////////////

@interface MPAVController : NSObject

-(void)changePlaybackIndexBy:(long long)amount;

@end


@interface MPUNowPlayingViewController : UIViewController

@property(retain) MPAVController * player;

-(void)setupGesturesForContentView:(UIView*)contentView;

@end

@interface MPAVItem : NSObject
@end

///////////
// Tweak //
///////////

%hook MPUNowPlayingViewController
	
%new
-(void)swipeDetected:(UISwipeGestureRecognizer*)gestureRecognizer
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
-(void)longPressDetected:(UILongPressGestureRecognizer*)longPressGR
{
	UIView *contentView = MSHookIvar<UIView*>(self, "_contentView");
			
	if (longPressGR.state == UIGestureRecognizerStateBegan) {
		
		id item = MSHookIvar<MPAVItem*>(self, "_item");
				
		ZPNowPlayingItemInfoView *infoView = 
			[[ZPNowPlayingItemInfoView alloc] initWithFrame:
				CGRectMake(0,0,contentView.frame.size.width,contentView.frame.size.height) 
					item:item];
				
		[infoView setAlpha:0.f];
		[contentView addSubview:infoView];
		
		[infoView release];
		
		[UIView animateWithDuration:0.35f animations:^{
		
			[infoView setAlpha:1.0f];
		
		}];
		
	} else if (longPressGR.state == UIGestureRecognizerStateEnded) {
		
		for (UIView *subview in contentView.subviews) {
			if ([subview isKindOfClass:[ZPNowPlayingItemInfoView class]]) {
				[UIView animateWithDuration:0.35f animations:^{
		
					[subview setAlpha:0.f];
		
				} completion: ^(BOOL finished){
					
					[subview removeFromSuperview];
					
				}];
			}
		}
		
	}
	
}	
	
%new
-(void)setupGesturesForContentView:(UIView*)contentView
{
	UISwipeGestureRecognizer *leftSwipeGR = 
		[[UISwipeGestureRecognizer alloc] initWithTarget:self 
			                                      action:@selector(swipeDetected:)];
	leftSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
	
	UISwipeGestureRecognizer *rightSwipeGR = 
		[[UISwipeGestureRecognizer alloc] initWithTarget:self 
			                                      action:@selector(swipeDetected:)];
	rightSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
	
	UILongPressGestureRecognizer *longPressGR =
		[[UILongPressGestureRecognizer alloc] initWithTarget:self 
			                                          action:@selector(longPressDetected:)];
			
	[contentView addGestureRecognizer:leftSwipeGR];
	[contentView addGestureRecognizer:rightSwipeGR];
	[contentView addGestureRecognizer:longPressGR];
	
	[leftSwipeGR release];
	[rightSwipeGR release];
	[longPressGR release];
}

-(id)_createContentViewForItem:(id)item contentViewController:(id*)contentVC
{
	id contentView = %orig;
	
	[self setupGesturesForContentView:contentView];

	return contentView;
}

- (id)_effectiveNavigationItem
{
	UINavigationItem *navItem = %orig;
	
	if (navItem.rightBarButtonItems.count == 1) {
			
		UIBarButtonItem *shareBtn = 
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
									    	              target:self 
									                      action:@selector(shareTapped)]; //!//
		
		id rightButtons = [navItem.rightBarButtonItems mutableCopy]; //!//
		[rightButtons addObject:shareBtn];
		
		[shareBtn release];
		
		[navItem setRightBarButtonItems:rightButtons];
		
		[rightButtons release];
	
	}
	
	return navItem;
}
	
%new
-(void)shareTapped
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
