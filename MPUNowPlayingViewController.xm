#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>

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
			
	[contentView addGestureRecognizer:leftSwipeGR];
	[contentView addGestureRecognizer:rightSwipeGR];
	
	[leftSwipeGR release];
	[rightSwipeGR release];
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
