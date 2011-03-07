//
//  SettingsViewController.h
//  note
//
//  Created by g g on 20/09/09.
//  Copyright 2009 g. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController {
	IBOutlet UITextField        *noteUrl;
	IBOutlet UITextField        *noteUser;
	IBOutlet UITextField        *noteUserPass;
}

@property(nonatomic,retain) IBOutlet UITextField        *noteUrl;
@property(nonatomic,retain) IBOutlet UITextField        *noteUser;
@property(nonatomic,retain) IBOutlet UITextField        *noteUserPass;

-(IBAction)updateSettings:(id)sender;

@end
