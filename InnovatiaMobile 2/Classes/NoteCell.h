//
//  shareViewController.h
//  note
//
//  Created by g g on 1/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface NoteCell : UITableViewCell {
	Note        *note;
    UILabel     *noteTextLabel;
    UILabel     *notePriorityLabel;
    UIImageView *notePriorityImageView;
}

@property (nonatomic, retain) UILabel     *noteTextLabel;
@property (nonatomic, retain) UILabel     *notePriorityLabel;
@property (nonatomic, retain) UIImageView *notePriorityImageView;

- (UIImage *)imageForPriority:(NSInteger)priority;

- (Note *)note;
- (void)setNote:(Note *)newNote;

@end
