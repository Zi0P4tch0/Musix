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

@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, assign) UIImage* artworkImage;

@property (nonatomic, retain, readwrite) UIView* artworkView;

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

-(void)backTapped:(UIButton*)backButton
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ZPNowPlayingItemInfoViewShouldDisappear" object:nil];
}

-(void)setup
{
	[self setBackgroundColor:[UIColor whiteColor]];
	
	[self setupBackButton];
	
	[self setupArtworkView];
	
	[self updateConstraints];
	
	[self bringSubviewToFront:self.artworkView];
}

-(void)setupBackButton
{
	self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.backButton setTitle:@"Back" forState:UIControlStateNormal];
	
	[self.backButton setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	[self.backButton addTarget:self action:@selector(backTapped:) forControlEvents:UIControlEventTouchUpInside];
	
	[self addSubview:self.backButton];
		
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

-(void)updateConstraints
{	
	NSArray *artworkViewHC = [NSLayoutConstraint constraintsWithVisualFormat:
	    @"H:|-(sep)-[artwork(artworkWidth)]"
		options:NSLayoutFormatAlignAllTop
	    metrics:@{@"sep":@(self.frame.size.width*0.06),
                  @"artworkWidth":@(self.frame.size.width * (0.35 + IPAD_K(0.07)))}
	    views:@{@"artwork":self.artworkView}];
				
	NSArray *artworkViewVC = [NSLayoutConstraint constraintsWithVisualFormat:
	    @"V:|-(sep)-[artwork(artworkHeight)]"
		options:0
		metrics:@{@"sep":@(self.frame.size.width*0.06),
	              @"artworkHeight":@(self.frame.size.width*(0.35 + IPAD_K(0.07)))}
		views:@{@"artwork":self.artworkView}];	
		
	NSArray *backButtonHC = [NSLayoutConstraint constraintsWithVisualFormat:
		@"H:[backButton]-(sep)-|"
		options:0
		metrics:@{@"sep":@(self.frame.size.width*0.06)}
		views:@{@"backButton":self.backButton}];	
		
	NSArray *backButtonVC = [NSLayoutConstraint constraintsWithVisualFormat:
		@"V:|-(sep)-[backButton]"
		options:0
		metrics:@{@"sep":@(self.frame.size.width*0.06)}
		views:@{@"backButton":self.backButton}];	
		

	[self addConstraints:artworkViewHC];
	[self addConstraints:artworkViewVC];
	[self addConstraints:backButtonHC];
	[self addConstraints:backButtonVC];
	
	[super updateConstraints];
}

-(void)dealloc
{		
	[self.artworkView release];
	
	[self.backButton release];
	
	[super dealloc];
}

@end