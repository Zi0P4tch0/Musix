#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class MPAVItem;

@interface ZPNowPlayingItemInfoView : UIView

-(instancetype)initWithFrame:(CGRect)frame 
	                    item:(MPAVItem*)item
						artworkImage:(UIImage*)artworkImage;

@end