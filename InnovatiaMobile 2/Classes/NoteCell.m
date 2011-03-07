//
//  shareViewController.h
//  note
//
//  Created by g g on 1/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import "NoteCell.h"

static UIImage *ideaImage = nil;

@interface NoteCell()
- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:
	(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;
@end

@implementation NoteCell

@synthesize noteTextLabel,notePriorityLabel,notePriorityImageView;

+ (void)initialize
{
    // The priority images are cached as part of the class, so they need to be
    // explicitly retained.
    ideaImage = [[UIImage imageNamed:@"ideaMarker.png"] retain];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        UIView *myContentView = self.contentView;
        
		self.notePriorityImageView = [[UIImageView alloc] initWithImage:ideaImage];
		[myContentView addSubview:self.notePriorityImageView];
        [self.notePriorityImageView release];
        
        self.noteTextLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] 
											  selectedColor:[UIColor whiteColor] fontSize:14.0 bold:YES]; 
		self.noteTextLabel.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview:self.noteTextLabel];
		[self.noteTextLabel release];
      
        self.notePriorityLabel = [self newLabelWithPrimaryColor:[UIColor blueColor] //Will be this coul
												  selectedColor:[UIColor whiteColor] fontSize:12.0 bold:YES];
		self.notePriorityLabel.textAlignment = UITextAlignmentRight;
		[myContentView addSubview:self.notePriorityLabel];
		[self.notePriorityLabel release];
        
        // Position the notePriorityImageView above all of the other views so
        // it's not obscured. It's a transparent image, so any views
        // that overlap it will still be visible.
        [myContentView bringSubviewToFront:self.notePriorityImageView];
    }
    return self;
}

- (Note *)note
{
    return self.note;
}

- (void)setNote:(Note *)newNote
{

    note = newNote;
    
    self.noteTextLabel.text = newNote.text;
    self.notePriorityImageView.image = [self imageForPriority:newNote.priority];
    
	self.notePriorityLabel.text = @"IDEA";
	
    [self setNeedsDisplay];
}



- (void)layoutSubviews {
    
#define LEFT_COLUMN_OFFSET 2
#define LEFT_COLUMN_WIDTH 50
	
#define RIGHT_COLUMN_OFFSET 75
#define RIGHT_COLUMN_WIDTH 240
	
#define UPPER_ROW_TOP 4
    
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
	
    if (!self.editing) {
		
        CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
        
        // Place the Text label.
		frame = CGRectMake(boundsX +RIGHT_COLUMN_OFFSET  , UPPER_ROW_TOP, RIGHT_COLUMN_WIDTH, 18);
		frame.origin.y = 13;
		self.noteTextLabel.frame = frame;
        
        // Place the priority image.
        UIImageView *imageView = self.notePriorityImageView;
        frame = [imageView frame];
		frame.origin.x = boundsX + LEFT_COLUMN_OFFSET;
		frame.origin.y = 6;
 		imageView.frame = frame;
        
        // Place the priority label.
        CGSize prioritySize = [self.notePriorityLabel.text sizeWithFont:self.notePriorityLabel.font 
							   forWidth:RIGHT_COLUMN_WIDTH lineBreakMode:UILineBreakModeTailTruncation];
        CGFloat priorityX = frame.origin.x + imageView.frame.size.width + 4.0;
        frame = CGRectMake(priorityX, UPPER_ROW_TOP, prioritySize.width, prioritySize.height);
		frame.origin.y = 15;
        self.notePriorityLabel.frame = frame;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];
	
	UIColor *backgroundColor = nil;
	if (selected) {
	    backgroundColor = [UIColor clearColor];
	} else {
		backgroundColor = [UIColor whiteColor];
	}
    
	self.noteTextLabel.backgroundColor = backgroundColor;
	self.noteTextLabel.highlighted = selected;
	self.noteTextLabel.opaque = !selected;
	
	self.notePriorityLabel.backgroundColor = backgroundColor;
	self.notePriorityLabel.highlighted = selected;
	self.notePriorityLabel.opaque = !selected;
}


- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor 
						selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{

    UIFont *font;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    } else {
        font = [UIFont systemFontOfSize:fontSize];
    }
    
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor whiteColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}

- (UIImage *)imageForPriority:(NSString *)priority
{
	return ideaImage;
}

- (void)dealloc {
	[super dealloc];
}


@end
