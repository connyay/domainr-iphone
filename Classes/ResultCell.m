#import "ResultCell.h"

@implementation ResultCell

	@synthesize result, mainContentView;

	- (id) initWithStyle: (UITableViewCellStyle)style reuseIdentifier: (NSString*) reuseIdentifier; {
		self = [super initWithStyle:style reuseIdentifier: reuseIdentifier];
		
		for (UIView* view in [self.contentView subviews])
			[view removeFromSuperview];
		
		self.opaque = YES;
		self.clearsContextBeforeDrawing = NO;

		mainContentView = [[ResultContentView alloc] initWithResultCell: self];
		mainContentView.opaque = YES;
		mainContentView.backgroundColor = [UIColor whiteColor];
		mainContentView.clearsContextBeforeDrawing = NO;
		mainContentView.contentMode = UIViewContentModeRedraw;
		[[self contentView] addSubview: mainContentView];
		
		return self;
	}

	- (void) setFrame: (CGRect) theFrame; {
		[super setFrame: theFrame];
		if (!CGSizeEqualToSize(theFrame.size, mainContentView.frame.size))
			mainContentView.frame = CGRectMake(0, 0, theFrame.size.width, theFrame.size.height);
	}

	- (void) dealloc; {
		Release(mainContentView);
		Release(result);
		[super dealloc];
	}

	- (void) setSelected: (BOOL) selected animated: (BOOL) animated; {
		if (self.selectionStyle != UITableViewCellSelectionStyleNone) {
			[super setSelected: selected animated: animated];
			
			[self.mainContentView setNeedsDisplay];
		}
	}

	- (void) setResult: (Result*) theResult; {
		[result release];
		result = [theResult retain];

		result.resultCell = self;
		[self.mainContentView setNeedsDisplay];
	}

	#pragma mark -

	static UIFont* domainFont = nil;
	static UIFont* availabilityFont = nil;

	- (void) drawCellInteriorInRect: (CGRect) rect isSelected: (BOOL) isSelected; {
		if (!domainFont) {
			domainFont = [[UIFont systemFontOfSize:17] retain];
			availabilityFont = [[UIFont systemFontOfSize:14] retain];
		}
		
		UIColor *mainTextColor = nil;
		UIColor *lightTextColor = nil;
		
		if(self.highlighted) {
			mainTextColor = [UIColor whiteColor];
			lightTextColor = [UIColor whiteColor];
		} 
		else {
			if(result.imageType == kUnavailable){
				mainTextColor = [UIColor blackColor];
			}
			else {	
				mainTextColor = UIColorFromRGB(0x2160AD);
			}
			lightTextColor = [UIColor lightGrayColor];
			self.backgroundColor = [UIColor whiteColor];
		}
		
		[mainTextColor set];
		CGSize domainTextSize = [result.domainName drawInRect:CGRectMake(30, 8, rect.size.width - 60, rect.size.height) 
													 withFont:domainFont 
												lineBreakMode:UILineBreakModeWordWrap];
		
		/* temporary solution (long strings won't work) */
		if(domainTextSize.height == 21) {
			[lightTextColor set];
			[result.path drawInRect:CGRectMake(30 + domainTextSize.width, 8, rect.size.width - 30 - domainTextSize.width - 35, 16) 
						   withFont:domainFont
					  lineBreakMode:UILineBreakModeTailTruncation];			
		}
		
		
		if(result.imageType == kAvailable)
		 	[[UIImage imageNamed:@"available.png"] drawInRect:CGRectMake(11, 16, 9, 9) 
													blendMode:kCGBlendModeNormal 
														alpha:1.0];
		else if(result.imageType == kMaybe)
		 	[[UIImage imageNamed:@"maybe.png"] drawInRect:CGRectMake(11, 16, 9, 9)
												blendMode:kCGBlendModeNormal 
													alpha:1.0];
	}

@end

@implementation ResultContentView

	- (id) initWithResultCell: (ResultCell*) theCell; {
		self = [super init];
		resultCell = theCell;
		return self;
	}

	- (void) drawRect: (CGRect) theRect; {
		[resultCell drawCellInteriorInRect: theRect isSelected: resultCell.selected];
	}

@end