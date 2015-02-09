#import "ZPNowPlayingItemInfoView.h"

#import "ZPLayoutUtils.h"

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

@property (nonatomic, retain) UIView* artworkView;
@property (nonatomic, retain) UILabel *artistLabel;
@property (nonatomic, retain) UILabel *albumLabel;
@property (nonatomic, retain) UILabel *songLabel;

@end

@implementation ZPNowPlayingItemInfoView

-(instancetype)initWithFrame:(CGRect)frame 
	                    item:(MPAVItem*)item
						artworkImage:(UIImage*)artworkImage
{
	self = [super initWithFrame:frame];
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
	
	[self setupArtistLabel];
	[self setupAlbumLabel];
	[self setupSongLabel];
	
	[self updateConstraints];
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

-(void)setupArtistLabel
{
	MPMediaItem *mediaItem = 
		[self.item valueForKey:@"_mediaItem"];
	
	NSString *artist = 
		[mediaItem valueForProperty:MPMediaItemPropertyArtist];
	
	self.artistLabel =
		[[UILabel alloc] initWithFrame:CGRectZero];
					   
	[self.artistLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
					   
	[self.artistLabel setText:artist];
	
	[self.artistLabel setFont:
		[UIFont boldSystemFontOfSize:20]];
						   
	[self addSubview:self.artistLabel];
	
	[self.artistLabel release];
}

-(void)setupAlbumLabel
{
	MPMediaItem *mediaItem = 
		[self.item valueForKey:@"_mediaItem"];
	
	NSString *album = 
		[mediaItem valueForProperty:MPMediaItemPropertyAlbumTitle];
	
	self.albumLabel =
		[[UILabel alloc] initWithFrame:CGRectZero];
					   
	[self.albumLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
					   
	[self.albumLabel setText:album];
					   
	[self addSubview:self.albumLabel];
	
	[self.albumLabel release];
}

-(void)setupSongLabel
{
	MPMediaItem *mediaItem = 
		[self.item valueForKey:@"_mediaItem"];
	
	NSString *song = 
		[mediaItem valueForProperty:MPMediaItemPropertyTitle];
	
	self.songLabel =
		[[UILabel alloc] initWithFrame:CGRectZero];
	
	[self.songLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
					   
	[self.songLabel setText:song];
					   
	[self addSubview:self.songLabel];
	
	[self.songLabel release];
}

-(void)updateConstraints
{	
	NSArray *artworkViewHC = [NSLayoutConstraint constraintsWithVisualFormat:
	    @"H:|-(sep)-[artwork(artworkWidth)]-(intraItemSep)-[artistLabel]-(sep)-|"
		options:NSLayoutFormatAlignAllTop
	    metrics:@{@"sep":@(self.frame.size.width*0.06),
                  @"artworkWidth":@(self.frame.size.width * (0.35 + IPAD_K(0.07))),
			      @"intraItemSep":@(10)}
	    views:@{@"artwork":self.artworkView,
		        @"artistLabel":self.artistLabel}];
		
	NSArray *artworkViewVC = [NSLayoutConstraint constraintsWithVisualFormat:
	    @"V:|-(sep)-[artwork(artworkHeight)]"
		options:0
		metrics:@{@"sep":@(self.frame.size.width*0.06),
	              @"artworkHeight":@(self.frame.size.width*(0.35 + IPAD_K(0.07)))}
		views:@{@"artwork":self.artworkView}];	
		
	NSArray *labelsVC = [NSLayoutConstraint constraintsWithVisualFormat:
		 @"V:[artistLabel]-[albumLabel]-[songLabel]"
		options:NSLayoutFormatAlignAllLeft
		metrics:@{}
		views:@{@"artistLabel":self.artistLabel, 
		        @"albumLabel":self.albumLabel, 
				@"songLabel":self.songLabel}];	
		
	id albumLabelWidthC = [NSLayoutConstraint constraintWithItem:self.albumLabel 
			attribute:NSLayoutAttributeWidth
		    relatedBy:NSLayoutRelationEqual
			toItem: self.artistLabel
			attribute: NSLayoutAttributeWidth
			multiplier: 1.0
			constant: 0];
	
	id songLabelWidthC = [NSLayoutConstraint constraintWithItem:self.songLabel 
			attribute:NSLayoutAttributeWidth
		    relatedBy:NSLayoutRelationEqual
			toItem: self.artistLabel
			attribute: NSLayoutAttributeWidth
			multiplier: 1.0
			constant: 0];
		
	[self addConstraints:artworkViewHC];
	[self addConstraints:artworkViewVC];
	[self addConstraints:labelsVC];
	[self addConstraint:albumLabelWidthC];
	[self addConstraint:songLabelWidthC];
	
	[super updateConstraints];
}

-(void)dealloc
{		
	[self.artworkView release];
	
	[self.artistLabel release];
	[self.albumLabel release];
	[self.songLabel release];
	
	[super dealloc];
}

@end