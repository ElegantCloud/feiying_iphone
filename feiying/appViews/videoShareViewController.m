//
//  videoShareViewController.m
//  feiying
//
//  Created by  on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "videoShareViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

#import "../util/commonUtil.h"
#import "../util/NSString+util.h"
#import "../constants/systemConstant.h"
#import "../constants/urlConstant.h"

#import "AppDelegate.h"

#import "../openSource/Toast/iToast.h"

#import "../customComponents/customButton.h"

@implementation videoShareViewController

@synthesize previousVDVC = _mPreviousVDVC;

// private methods
// share recipients textField text changed
-(void) shareRecipientsTextDidChanged:(UITextField*) pTextField{
    NSLog(@"last textField text = %@ and current text = %@", _mLastShareRecipientsTFtext, pTextField.text);
    
    // get share recipients phone numbers array
    NSArray *_shareRecipientsPNArr = [pTextField.text getPhoneNumberArray];
    NSLog(@"share recipients phone number array = %@", _shareRecipientsPNArr);
    
    // process share recipients phone number array
    for (NSString *_shareRecipientPN in _shareRecipientsPNArr) {
        // get each share recipient phone number indexes
        NSIndexSet *_indexes = [_shareRecipientsPNArr indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [obj isEqual:_shareRecipientPN];
        }];
        
        // judge if or not has repetitive shareRecipient phone number
        if (_indexes.count > 1) {
            // remove target first
            [pTextField removeTarget:self action:@selector(shareRecipientsTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
            // set lastShareRecipientsTFtext as shareRecipients textField text
            [pTextField setText:_mLastShareRecipientsTFtext];
            // add target again
            [pTextField addTarget:self action:@selector(shareRecipientsTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
            
            // show toast tip
            iToast *_toast = [iToast makeText:@"列表中已存在此分享者,请不要重复添加"];
            [_toast setDuration:iToastDurationShort];
            [_toast setGravity:iToastGravityTopCenter];
            [_toast show];
        }
    }
    
    // update last shareRecipients textField text
    _mLastShareRecipientsTFtext = pTextField.text;
}

// textview leave edit mode
-(void) leaveEditMode{
    [_mShareNotes resignFirstResponder];
}

// append recipients input
-(void) appendRecipients:(NSString*) pAppendRecipients{
    NSMutableString *_newTFText = nil;
    if([_mShareRecipients text] && ![[[_mShareRecipients text] trimWhitespaceAndNewlineCharacter] isEqualToString:@""]){
        _newTFText = [NSMutableString stringWithFormat:@"%@,", [_mShareRecipients text]];
    }
    else{
        _newTFText = [[NSMutableString alloc] init];
    }

    // check be append recipients param if it had been existed or not
    if ([_newTFText rangeOfString:pAppendRecipients].length == 0) {
        // append recipients param
        [_newTFText appendString:pAppendRecipients];
        
        // set share recipients textField text
        [_mShareRecipients setText:_newTFText];
        
        // update last shareRecipients textField text
        _mLastShareRecipientsTFtext = _newTFText;
    }
    else {
        // show toast tip
        iToast *_toast = [iToast makeText:[NSString stringWithFormat:@"%@已在分享者列表中,请不要重复添加", pAppendRecipients]];
        [_toast setDuration:iToastDurationNormal];
        [_toast setGravity:iToastGravityBottom];
        [_toast show];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithShareVideoTitle:(NSString *)pTitle andChannelId:(NSNumber *)pChannelId andSourceId:(NSString *)pSourceId{
    self = [super init];
    if(self){
        // Custom initialization
        // set background color
        self.view.backgroundColor = BACKGROUNDCOLOR;
        
        // set title
        self.title = @"分享";
        
        // update view frame
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0.0, self.view.frame.size.width, self.view.frame.size.height-/*navigationBar height*/44.0);
        
        // set navigationItem nil
        self.navigationItem.leftBarButtonItem = nil;
        
        // init video web play address
        _mVideoWebPlayAddr = [NSString stringWithFormat:@"%@/%d/%@", [urlConstant videoWebPlayAddr], pChannelId.intValue, pSourceId];
        
        // init last shareRecipients textField text
        _mLastShareRecipientsTFtext = [[NSString alloc] init];
        
        // subViews setting
        // share recipients Tip
        UILabel *_recipientsTip = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 52.0, 30.0)];
        // set text
        _recipientsTip.text = @"收件人:";
        _recipientsTip.textColor = [UIColor darkGrayColor];
        _recipientsTip.font = [UIFont systemFontOfSize:14.0];
        _recipientsTip.backgroundColor = [UIColor clearColor];
        
        // share recipients text field
        _mShareRecipients = [[UITextField alloc] initWithFrame:CGRectMake(_recipientsTip.frame.origin.x+_recipientsTip.frame.size.width+5.0, _recipientsTip.frame.origin.y, self.view.frame.size.width-20.0-30.0-_recipientsTip.frame.size.width, _recipientsTip.frame.size.height)];
        // set style
        _mShareRecipients.borderStyle = UITextBorderStyleRoundedRect;
        // auto correction
        _mShareRecipients.autocorrectionType = UITextAutocorrectionTypeYes;
        // default display text
        _mShareRecipients.placeholder = @"收件人列表,以逗号分隔.";
        // set font
        _mShareRecipients.font = [UIFont systemFontOfSize:14.0];
        _mShareRecipients.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        // set keyBoard done button
        _mShareRecipients.returnKeyType = UIReturnKeyDone;
        _mShareRecipients.clearButtonMode = UITextFieldViewModeWhileEditing;
        // keyboard type
        _mShareRecipients.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        // set delegate
        _mShareRecipients.delegate = self;
        // add target
        [_mShareRecipients addTarget:self action:@selector(shareRecipientsTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
        
        // add recipients button
        UIButton *_addRecipientsButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        // set frame
        _addRecipientsButton.frame = CGRectMake(self.view.frame.size.width-5.0-30.0, _recipientsTip.frame.origin.y, 30.0, _recipientsTip.frame.size.height);
        // add target
        [_addRecipientsButton addTarget:self action:@selector(addRecipientsFromContact) forControlEvents:UIControlEventTouchUpInside];
        
        // share video title tip
        UILabel *_shareVideoTitleTip = [[UILabel alloc] initWithFrame:CGRectMake(_recipientsTip.frame.origin.x, _recipientsTip.frame.origin.y+_recipientsTip.frame.size.height+15.0, 100.0, 18.0)];
        // set text
        _shareVideoTitleTip.text = @"分享视频标题:";
        _shareVideoTitleTip.textColor = [UIColor darkGrayColor];
        _shareVideoTitleTip.font = [UIFont systemFontOfSize:14.0];
        _shareVideoTitleTip.backgroundColor = [UIColor clearColor];
        
        // share video title
        UILabel *_shareVideoTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, _shareVideoTitleTip.frame.origin.y+_shareVideoTitleTip.frame.size.height+5.0, 320.0-2*10.0, 44.0)];
        // set text
        _shareVideoTitle.text = pTitle;
        _shareVideoTitle.font = [UIFont boldSystemFontOfSize:16.0];
        _shareVideoTitle.numberOfLines = 2;
        _shareVideoTitle.backgroundColor = [UIColor clearColor];
        
        // share notes tip
        UILabel *_shareNotesTip = [[UILabel alloc] initWithFrame:CGRectMake(_recipientsTip.frame.origin.x, _shareVideoTitle.frame.origin.y+_shareVideoTitle.frame.size.height+15.0, 100.0, 18.0)];
        // set text
        _shareNotesTip.text = @"留言:";
        _shareNotesTip.textColor = [UIColor darkGrayColor];
        _shareNotesTip.font = [UIFont systemFontOfSize:14.0];
        _shareNotesTip.backgroundColor = [UIColor clearColor];
        
        // share notes
        _mShareNotes = [[UITextView alloc] initWithFrame:CGRectMake(5.0, _shareNotesTip.frame.origin.y+_shareNotesTip.frame.size.height+5.0, 320.0-2*5.0, 100.0)];
        // set view bolder style
        _mShareNotes.layer.cornerRadius = 8;
        _mShareNotes.layer.masksToBounds = YES;
        _mShareNotes.layer.borderWidth = 2;
        _mShareNotes.layer.borderColor = [[UIColor scrollViewTexturedBackgroundColor] CGColor];
        // auto correction
        _mShareNotes.autocorrectionType = UITextAutocorrectionTypeYes;
        // default display text
        _mShareNotes.text = @"这个视频很好玩哟!...";
        _mShareNotes.textColor = [UIColor lightGrayColor];
        // set font
        _mShareNotes.font = [UIFont fontWithName:@"AppleGothic" size:14.0];
        // set keyBoard done button
        _mShareNotes.returnKeyType = UIReturnKeyDone;
        // set delegate
        _mShareNotes.delegate = self;
        
        // share video confirm button
        customButton *_shareConfirmButton = [[customButton alloc] init];
        // set frame
        _shareConfirmButton.frame = CGRectMake((320.0-80.0)/2, _mShareNotes.frame.origin.y+_mShareNotes.frame.size.height+15.0, 80.0, 30.0);
        // set title
        _shareConfirmButton.labelText.text = @"短信分享";
        // add target
        [_shareConfirmButton addTarget:self action:@selector(videoShareConfirm) forControlEvents:UIControlEventTouchUpInside];
        
        // add subViews
        [self.view addSubview:_recipientsTip];
        [self.view addSubview:_addRecipientsButton];
        [self.view addSubview:_mShareRecipients];
        [self.view addSubview:_shareVideoTitleTip];
        [self.view addSubview:_shareVideoTitle];
        [self.view addSubview:_shareNotesTip];
        [self.view addSubview:_mShareNotes];
        [self.view addSubview:_shareConfirmButton];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

// UITextFieldDelegate methods implemetation
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

// UITextViewDelegate methods implemetation
-(void) textViewDidBeginEditing:(UITextView *)textView{
    // init textView done edit barButtonItem
    UIBarButtonItem *_doneEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];
    // set done edit barButtonItem tintColor
    //_doneEdit.tintColor = [UIColor blueColor];
    
    // set doneEit barButtonItem as navigationItem rightBarButtonItem
    self.navigationItem.rightBarButtonItem = _doneEdit;
    
    // scroll up
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y-123.0);
}

-(void) textViewDidEndEditing:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem = nil;
    
    // scroll down
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y+123.0);
}

// ABPeoplePickerNavigationControllerDelegate methods implemetation
-(void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    // dismiss modalViewControllerAnimated
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    //NSLog(@"pjcker person = %@", person);
    
    // get display name and phone numbers array
    NSString *_displayName = [commonUtil getFullNameByRecord:person];
    NSArray *_phoneNumbersArray = [commonUtil getPhoneNumberArray:person];
    //NSLog(@"contack display name = %@ and phone numbers array = %@", _displayName, _phoneNumbersArray);
    
    if(_phoneNumbersArray && [_phoneNumbersArray count] > 1){
        UIActionSheet *_phoneSelectedSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"请选择联系号码(%@)", _displayName] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for(NSString *_phone in _phoneNumbersArray){
            [_phoneSelectedSheet addButtonWithTitle:_phone];
        }
        
        // show action sheet
        [_phoneSelectedSheet showInView:peoplePicker.view];
    }
    else if(_phoneNumbersArray && [_phoneNumbersArray count] == 1){
        NSLog(@"display name = %@ and phone = %@", _displayName, [_phoneNumbersArray objectAtIndex:0]);
        
        // append recipients
        [self appendRecipients:[NSString stringWithFormat:@"(%@)%@", _displayName, [_phoneNumbersArray objectAtIndex:0]]];
        
        // dismiss modalViewControllerAnimated
        [self dismissModalViewControllerAnimated:YES];
    }
    else{
        // init and show the contact has no phone alert
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:_displayName message:@"此联系人没有设置通讯号码." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [_alert show];
    }
    
    return NO;
}

-(BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{    
    return NO;
}

// UIActionSheetDelegate methods implemetation
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"actionSheet - clickedButtonAtIndex - index = %d and title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    
    // get contact display name
    NSUInteger first = [actionSheet.title firstIndexOfChar:'('];
    NSUInteger last = [actionSheet.title lastIndexOfChar:')'];
    NSString *_displayName = [actionSheet.title substringWithRange:NSMakeRange(first+1, last-first-1)];
    //NSLog(@"selected contact display name = %@", _displayName);
    
    // process selected phone number
    if(![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"取消"]){
        NSString *_phoneNumber = [actionSheet buttonTitleAtIndex:buttonIndex];
        NSLog(@"display name = %@ and phone = %@", _displayName, _phoneNumber);
        
        // append recipients
        [self appendRecipients:[NSString stringWithFormat:@"(%@)%@", _displayName, _phoneNumber]];
    }
    
    // dismiss modalViewControllerAnimated
    [self dismissModalViewControllerAnimated:YES];
}

// methods implematation
// add recipients from phone contact
-(void) addRecipientsFromContact{
    // hide shareRecipients textField keyboard
    [_mShareRecipients resignFirstResponder];
    
    // init people picker navifation controller
    ABPeoplePickerNavigationController *_peoplePickerNavController = [[ABPeoplePickerNavigationController alloc] init];
    // set delegate
    _peoplePickerNavController.peoplePickerDelegate = self;
    
    // present perople picker navigation controller
    [self presentModalViewController:_peoplePickerNavController animated:YES];
}

// video share confirm
-(void) videoShareConfirm{
    NSLog(@"videoShareConfirm - recipients = %@ and body = %@", _mShareRecipients.text, _mShareNotes.text);
    
    // check video shared recipients
    if(_mShareRecipients.text == nil || [[_mShareRecipients.text trimWhitespaceAndNewlineCharacter] isEqualToString:@""]){
        iToast *_toast = [iToast makeText:@"请填写分享者信息."];
        [_toast setDuration:iToastDurationNormal];
        [_toast setGravity:iToastGravityBottom];
        [_toast show];
        
        return;
    }
    
    // share notes textview leave edit mode
    [self leaveEditMode];
    
    // judge sms supply device
    if([MFMessageComposeViewController canSendText]){        
        // init message compose viewController and present modalViewController
        if(!gMsgViewController){
            gMsgViewController = [[MFMessageComposeViewController alloc] init];
        }
        
        gMsgViewController.recipients = [_mShareRecipients.text getPhoneNumberArray];
        NSString *_smsBody = (_mShareNotes.text && ![[_mShareNotes.text trimWhitespaceAndNewlineCharacter] isEqualToString:@""]) ? [NSString stringWithFormat:@"分享视频: %@ \n留言: %@", _mVideoWebPlayAddr, _mShareNotes.text] : [NSString stringWithFormat:@"分享视频: %@", _mVideoWebPlayAddr];
        gMsgViewController.body = _smsBody;
        NSLog(@"sms recipients = %@ and body = %@", gMsgViewController.recipients, gMsgViewController.body);
        gMsgViewController.messageComposeDelegate = self.previousVDVC;
        [self presentModalViewController:gMsgViewController animated:YES];
    }
    else{
        // init and show cann't send sms alert
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:nil message:@"你的设备不能发送短信." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [_alert show];
    }
}

@end
