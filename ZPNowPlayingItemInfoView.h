#import <UIKit/UIKit.h>

@class MPAVItem;

@interface ZPNowPlayingItemInfoView : UIView

@property (nonatomic, retain, readonly) UIView* artworkView;

-(instancetype)initWithItem:(MPAVItem*)item
			   artworkImage:(UIImage*)artworkImage;

@end