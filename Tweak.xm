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

-(void)_updateTitles;

-(void)setupGestures;
-(void)setupShareButtonIfNecessary;

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
-(void)setupGestures
{
	%log(@"Setting up gestures...");
	
	UISwipeGestureRecognizer *leftSwipeGR = 
		[[UISwipeGestureRecognizer alloc] initWithTarget:self 
			                                      action:@selector(swipeDetected:)];
	leftSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
	
	UISwipeGestureRecognizer *rightSwipeGR = 
		[[UISwipeGestureRecognizer alloc] initWithTarget:self 
			                                      action:@selector(swipeDetected:)];
	rightSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
	
	UIView *contentView = MSHookIvar<UIView*>(self, "_contentView");
		
	[contentView addGestureRecognizer:leftSwipeGR];
	[contentView addGestureRecognizer:rightSwipeGR];
	
	[leftSwipeGR release];
	[rightSwipeGR release];
}
	
%new
-(void)setupShareButtonIfNecessary
{
	UINavigationItem *navItem = 
		MSHookIvar<UINavigationItem*>(self, "_effectiveNavigationItem");
	
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

-(void)viewDidAppear:(BOOL)animated
{
	%orig(animated);
			
	[self _updateTitles];
	
	[self setupGestures];
	
}

- (void)_updateTitles
{
	%orig;
		
	//Setup buttons if necessary
		
	[self setupShareButtonIfNecessary];

}

%end
