#import "ZPNowPlayingItemInfoView.h"

#import "UIView+Positioning.h"

/////////////////////////
// What we can "steal" //
/////////////////////////

@interface MPUSlantedTextPlaceholderArtworkView : UIImageView

-(instancetype)initWithImage:(UIImage*)image;

@end

@interface MPAVItem : NSObject
@end

///////////////////////////
// Back where we were... //
///////////////////////////

@interface ZPNowPlayingItemInfoView()

@property (nonatomic, assign) MPAVItem* item;

@property (nonatomic, retain) MPUSlantedTextPlaceholderArtworkView *artworkView;
@property (nonatomic, retain) UILabel *artistLabel;
@property (nonatomic, retain) UILabel *albumLabel;
@property (nonatomic, retain) UILabel *songLabel;

@end

@implementation ZPNowPlayingItemInfoView

-(instancetype)initWithFrame:(CGRect)frame 
	                    item:(MPAVItem*)item
{
	self = [super initWithFrame:frame];
	if (self) {
		self.item = item;
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
}

-(void)setupArtworkView
{
	MPMediaItem *mediaItem = 
		[self.item valueForKey:@"_mediaItem"];
	
	MPMediaItemArtwork *itemArtwork = 
		[mediaItem valueForProperty:MPMediaItemPropertyArtwork];
	UIImage *artworkImage = [itemArtwork imageWithSize:CGSizeMake(250, 250)];

	self.artworkView = 
		[[MPUSlantedTextPlaceholderArtworkView alloc] initWithImage:artworkImage];
	
	self.artworkView.frame = CGRectMake(10,10,100,100);
	[self.artworkView.layer setBorderColor:[UIColor blackColor].CGColor];
	[self.artworkView.layer setBorderWidth:0.5f];
	
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
		[[UILabel alloc] initWithFrame:
			CGRectMake([self.artworkView right] + 10,
			           [self.artworkView top],
					   [self width] - [self.artworkView right] - 20,
					   [self.artworkView height] / 3)];
					   
	[self.artistLabel setText:artist];
	
	[self.artistLabel setFont:
		[UIFont boldSystemFontOfSize:
		  [[self.artistLabel font] pointSize]]];
	
					   
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
		[[UILabel alloc] initWithFrame:
			CGRectMake([self.artistLabel left],
			           [self.artistLabel bottom],
					   [self width] - [self.artworkView right] - 20,
					   [self.artworkView height] / 3)];
					   
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
		[[UILabel alloc] initWithFrame:
			CGRectMake([self.albumLabel left],
			           [self.albumLabel bottom],
					   [self width] - [self.artworkView right] - 20,
					   [self.artworkView height] / 3)];
					   
	[self.songLabel setText:song];
					   
	[self addSubview:self.songLabel];
	
	[self.songLabel release];
}

-(void)dealloc
{
	[super dealloc];
	
	[self.artworkView release];
	[self.artistLabel release];
	[self.songLabel release];
}

@end