//
//  videoShareViewController.h
//  feiying
//
//  Created by  on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AddressBookUI/AddressBookUI.h>
#import "videoDetailViewController.h"

@interface videoShareViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, ABPeoplePickerNavigationControllerDelegate, UIActionSheetDelegate>{
    // share recipients
    UITextField *_mShareRecipients;
    // share notes
    UITextView *_mShareNotes;
    
    // video web play address
    NSString *_mVideoWebPlayAddr;
    
    // previous video detail view controller
    videoDetailViewController *_mPreviousVDVC;
    
    // last shareRecipients textField text
    NSString *_mLastShareRecipientsTFtext;
}

@property (nonatomic, retain) videoDetailViewController *previousVDVC;

// init with share video title, channelId and sourceId
-(id) initWithShareVideoTitle:(NSString*) pTitle andChannelId:(NSNumber*) pChannelId andSourceId:(NSString*) pSourceId;
 
// add recipients from phone contact
-(void) addRecipientsFromContact;

// video share confirm
-(void) videoShareConfirm;

@end
