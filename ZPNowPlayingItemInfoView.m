#import "ZPNowPlayingItemInfoView.h"

#import "ZPGlobals.h"

/////////////////////////
// What we can "steal" //
/////////////////////////

@interface MPAVItem : NSObject
@end

///////////////////////////
// Back where we were... //
///////////////////////////

@interface ZPNowPlayingItemInfoView()

@property (nonatomic, assign) MPAVItem* item;

@property (nonatomic, assign) UIImage* artworkImage;

@property (nonatomic, retain, readwrite) UIView* artworkView;

@end

@implementation ZPNowPlayingItemInfoView

-(instancetype)initWithItem:(MPAVItem*)item
			   artworkImage:(UIImage*)artworkImage
{
	self = [super initWithFrame:CGRectZero];
	if (self) {
		self.item = item;
		self.artworkImage = artworkImage;
		[self setup];
	}
	return self;
}

-(void)setup
{
	[self setBackgroundColor:[UIColor whiteColor]];
		
	[self setupArtworkView];
	
	[self addConstraints];
}

-(void)setupArtworkView
{
	self.artworkView = 
		[[UIImageView alloc] initWithImage:self.artworkImage];
		
	[self.artworkView setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	[self.artworkView.layer setBorderColor:[UIColor blackColor].CGColor];
	[self.artworkView.layer setBorderWidth:.5f];
	
	[self addSubview:self.artworkView];
	
	[self.artworkView release];
}

-(void)addConstraints
{		
	NSLayoutConstraint *artworkViewVC =
    	[NSLayoutConstraint constraintWithItem:self.artworkView 
			attribute: NSLayoutAttributeTop 
			relatedBy:NSLayoutRelationEqual 
			toItem:self
			attribute:NSLayoutAttributeTop
			multiplier:1
			constant:ZP_INTRAITEM_SEP + ZP_ARTWORK_VISIBLE_AREA_WHEN_UP];
	
	NSLayoutConstraint *artworkViewHC =
    	[NSLayoutConstraint constraintWithItem:self.artworkView 
			attribute: NSLayoutAttributeLeft
			relatedBy:NSLayoutRelationEqual 
			toItem:self
			attribute:NSLayoutAttributeLeft
			multiplier:1
			constant:ZP_INTRAITEM_SEP];
	
	NSLayoutConstraint *artworkViewHeightC =
    	[NSLayoutConstraint constraintWithItem:self.artworkView 
			attribute: NSLayoutAttributeHeight
			relatedBy:NSLayoutRelationEqual 
			toItem:self
			attribute:NSLayoutAttributeWidth
			multiplier:0.35
			constant:0];
	
	NSLayoutConstraint *artworkViewWidthC =
    	[NSLayoutConstraint constraintWithItem:self.artworkView 
			attribute: NSLayoutAttributeWidth
			relatedBy:NSLayoutRelationEqual 
			toItem:self
			attribute:NSLayoutAttributeWidth
			multiplier:0.35
			constant:0];
	
	[self addConstraint:artworkViewHC];
	[self addConstraint:artworkViewVC];
	[self addConstraint:artworkViewHeightC];
	[self addConstraint:artworkViewWidthC];
	
}

-(void)dealloc
{		
	[self.artworkView release];
	
	[super dealloc];
}

@end