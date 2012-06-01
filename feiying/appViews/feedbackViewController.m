//
//  feedbackViewController.m
//  feiying
//
//  Created by  on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "feedbackViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "../openSource/Toast/iToast.h"
#import "../openSource/JSONKit/JSONKit.h"
#import "../openSource/ASIHTTPRequest/ASIFormDataRequest.h"

#import "../constants/systemConstant.h"
#import "../constants/urlConstant.h"

#import "../util/NSString+util.h"

@implementation feedbackViewController

// private methods
// send request with url
-(void) sendRequestWithUrl:(NSString*) pUrl andPostBody:(NSMutableDictionary*) pPostBodyDic andFinishedRespMeth:(SEL) pFinRespMeth andFailedRespMeth:(SEL) pFailRespMeth{
    // judge request param
    if(pUrl == nil){
        NSLog(@"sendRequestWithUrl - request url is nil.");
        
        return;
    }
    
    // synchronous request
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pUrl]];
    
    // set timeout seconds
    [_request setTimeOutSeconds:5.0];
    
    //  set post value
    [pPostBodyDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        [_request addPostValue:obj forKey:key];
    }];
    
    // set delegate
    _request.delegate = self;
    
    // set response methods
    if(pFinRespMeth && [self respondsToSelector:pFinRespMeth]){
        _request.didFinishSelector = pFinRespMeth;
    }
    if(pFailRespMeth && [self respondsToSelector:pFailRespMeth]){
        _request.didFailSelector = pFailRespMeth;
    }
    
    // start send request
    [_request startSynchronous];
}

// feedback info type picker response method
-(void) feedbackInfoTypePicker:(customButton*) pPicker{
    // if custom picker view is exist, return immediately
    if([[self.view subviews] containsObject:_mPickerView]){
        return;
    }
    
    // set picker view selected row in component
    NSInteger _row = ([_mFeedbackTypeDic.allKeys containsObject:[[pPicker labelText] text]]) ? [_mFeedbackTypeDic.allKeys indexOfObject:[[pPicker labelText] text]] : 0;
    [_mPickerView setPickerViewSelectedRow:_row InComponent:0];
    
    // add to view
    [self.view addSubview:_mPickerView];
}

// textview leave edit mode
-(void) leaveEditMode{
    [_mFeedbakInfo resignFirstResponder];
}

// send feedback submit request
-(void) sendFeedbackSubmitRequest{
    // get feedback info type, comment and user
    NSString *_feedbackInfoType = [_mFeedbackTypeDic objectForKey:_mFbInfoTypePickerSelector.labelText.text];
    NSString *_feedbackInfoComment = _mFeedbakInfo.text;
    NSString *_userInfo = _mUserInfo.text;
    NSLog(@"feedback info type = %@, comment = %@ and user info = %@", _feedbackInfoType, _feedbackInfoComment, _userInfo);
    
    // init feedback submit request param
    NSMutableDictionary *_submitParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_userInfo, @"user", _feedbackInfoType, @"type", _feedbackInfoComment, @"comment", nil];
    
    [self sendRequestWithUrl:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant feedbackSubmitUrl]]  andPostBody:_submitParam andFinishedRespMeth:@selector(didFinishedRequestFeedbackSubmit:) andFailedRespMeth:@selector(didFailedRequestFeedbackSubmit:)];
}

// self init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // set title
        self.title = @"用户反馈";
        
        // set background color
        self.view.backgroundColor = BACKGROUNDCOLOR;
        
        // hide tabBar when pushed
        self.hidesBottomBarWhenPushed = YES;
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-20.0, self.view.frame.size.width, self.view.frame.size.height+49.0);
        
        // init feedback type dictionary
        _mFeedbackTypeDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"problem", @"问题反馈", @"advice", @"改善建议", @"requirement", @"内容需求", @"consult", @"新手资讯", @"other", @"其他", nil];
        
        // feedback info type label
        UILabel *_fbInfoTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+5.0, self.view.bounds.origin.y+5.0, self.view.frame.size.width-2*5.0, 18.0)];
        // text
        _fbInfoTypeLabel.text = @"反馈信息类型:";
        _fbInfoTypeLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _fbInfoTypeLabel.backgroundColor = [UIColor clearColor];
        
        // feedback info type picker button
        _mFbInfoTypePickerSelector = [[customButton alloc] initWithFrame:CGRectMake(_fbInfoTypeLabel.frame.origin.x, _fbInfoTypeLabel.frame.origin.y+_fbInfoTypeLabel.frame.size.height+2.0, _fbInfoTypeLabel.frame.size.width, 26.0)];
        // set text
        _mFbInfoTypePickerSelector.labelText.text = @"问题反馈";
        // add target
        [_mFbInfoTypePickerSelector addTarget:self action:@selector(feedbackInfoTypePicker:) forControlEvents:UIControlEventTouchUpInside];
        
        // feedback info label
        UILabel *_fbInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mFbInfoTypePickerSelector.frame.origin.x, _mFbInfoTypePickerSelector.frame.origin.y+_mFbInfoTypePickerSelector.frame.size.height+15.0, _fbInfoTypeLabel.frame.size.width, 18.0)];
        // text
        _fbInfoLabel.text = @"请详细描述您的建议、意见、问题等:";
        _fbInfoLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _fbInfoLabel.backgroundColor = [UIColor clearColor];
        
        // feedback info input textview
        _mFeedbakInfo = [[UITextView alloc] initWithFrame:CGRectMake(_fbInfoLabel.frame.origin.x, _fbInfoLabel.frame.origin.y+_fbInfoLabel.frame.size.height+2.0, _fbInfoLabel.frame.size.width, 100.0)];
        // set view bolder style
        _mFeedbakInfo.layer.cornerRadius = 8;
        _mFeedbakInfo.layer.masksToBounds = YES;
        _mFeedbakInfo.layer.borderWidth = 2;
        _mFeedbakInfo.layer.borderColor = [[UIColor scrollViewTexturedBackgroundColor] CGColor];
        // auto correction
        _mFeedbakInfo.autocorrectionType = UITextAutocorrectionTypeYes;
        // set font
        _mFeedbakInfo.font = [UIFont fontWithName:@"AppleGothic" size:14.0];
        // set keyBoard done button
        _mFeedbakInfo.returnKeyType = UIReturnKeyNext;
        // set delegate
        _mFeedbakInfo.delegate = self;
        
        // feedback user info label
        UILabel *_fbUserInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mFeedbakInfo.frame.origin.x, _mFeedbakInfo.frame.origin.y+_mFeedbakInfo.frame.size.height+15.0, _mFeedbakInfo.frame.size.width, 18.0)];
        // text
        _fbUserInfoLabel.text = @"您的手机号码/邮箱地址(选填):";
        _fbUserInfoLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _fbUserInfoLabel.backgroundColor = [UIColor clearColor];
        
        // feedback user info input textfield
        _mUserInfo = [[UITextField alloc] initWithFrame:CGRectMake(_fbUserInfoLabel.frame.origin.x, _fbUserInfoLabel.frame.origin.y+_fbUserInfoLabel.frame.size.height+2.0, _fbUserInfoLabel.frame.size.width, 30.0)];
        // set style
        _mUserInfo.borderStyle = UITextBorderStyleRoundedRect;
        // auto correction
        _mUserInfo.autocorrectionType = UITextAutocorrectionTypeYes;
        // default display text
        _mUserInfo.placeholder = @"您的联系方式";
        // set font
        _mUserInfo.font = [UIFont systemFontOfSize:14.0];
        _mUserInfo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        // set keyBoard done button
        _mUserInfo.returnKeyType = UIReturnKeyDone;
        _mUserInfo.clearButtonMode = UITextFieldViewModeWhileEditing;
        // keyboard type
        _mUserInfo.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        // set delegate
        _mUserInfo.delegate = self;
        
        // submit button
        customButton *_submitButton = [[customButton alloc] init];
        // set frame
        _submitButton.frame = CGRectMake((self.view.frame.size.width-50.0)/2, _mUserInfo.frame.origin.y+_mUserInfo.frame.size.height+15.0, 50.0, 30.0);
        // set title
        _submitButton.labelText.text = @"提交";
        // add target
        [_submitButton addTarget:self action:@selector(feedbackSubmitConfirm) forControlEvents:UIControlEventTouchUpInside];
        
        // feedback submit progressHUD
        _mHud = [[MBProgressHUD alloc] initWithView:self.view];
        //_mHud.mode = MBProgressHUDModeDeterminate;
        _mHud.labelText = @"提交中...";
        
        // init feedback info type selected customPickerView
        _mPickerView = [[customPickerView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, 218.0, self.view.frame.size.width, 176.0)];
        // set customPickerView dataSource and delegate
        [_mPickerView setPickerDataSource:self];
        [_mPickerView setPickerDelegate:self];
        // set picker view title label
        _mPickerView.pickerTitleLabel.text = @"请选着反馈信息的类型";
        _mPickerView.pickerTitleLabel.textColor = [UIColor whiteColor];
        // set custome picker delegate
        _mPickerView.customPickerDelegate = self;
        
        // add subviews to view
        [self.view addSubview:_fbInfoTypeLabel];
        [self.view addSubview:_mFbInfoTypePickerSelector];
        [self.view addSubview:_fbInfoLabel];
        [self.view addSubview:_mFeedbakInfo];
        [self.view addSubview:_fbUserInfoLabel];
        [self.view addSubview:_mUserInfo];
        [self.view addSubview:_submitButton];
        [self.view addSubview:_mHud];
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

// UIPickerViewDataSource methods implemetation
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_mFeedbackTypeDic count];
}

// UIPickerViewDelegate methods implemetation
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_mFeedbackTypeDic.allKeys objectAtIndex:row];
}

// customPickerViewDelegate method implemetation
-(void) pickerDoneSelected{
    //NSLog(@"feedbackViewController - pickerDoneSelected implemetation.");
    
    // update feedback info type picker selector
    _mFbInfoTypePickerSelector.labelText.text = [_mFeedbackTypeDic.allKeys objectAtIndex:[_mPickerView getPickerViewSelectedRowInComponent:0]];
    
    // remove picker view from super view
    [_mPickerView removeFromSuperview];
}

// UITextFieldDelegate methods implemetation
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    // scroll up
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y-54.0);
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    // scroll up
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y+54.0);
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
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y-20.0);
}

-(void) textViewDidEndEditing:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem = nil;
    
    // scroll up
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y+20.0);
}

// methods implemetation
// feedback submit confirm
-(void) feedbackSubmitConfirm{
    //NSLog(@"feedbackViewController - feedbackSubmitConfirm.");
    
    if(_mFeedbakInfo && ![[_mFeedbakInfo.text trimWhitespaceAndNewlineCharacter] isEqualToString:@""]){
        // show progressHud
        [_mHud showWhileExecuting:@selector(sendFeedbackSubmitRequest) onTarget:self withObject:nil animated:YES];
    }
    else{
        iToast *_toast = [iToast makeText:@"请输入您的建议、意见或问题!"];
        [_toast setDuration:iToastDurationLong];
        [_toast setGravity:iToastGravityBottom];
        [_toast show];
    }
}

// ASIHTTPRequestDelegate methods implemetation
// feedback submit request response methods
-(void) didFinishedRequestFeedbackSubmit:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestFeedbackSubmit - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // get login result
    if(pRequest.responseStatusCode == 200){
        iToast *_toast = [iToast makeText:@"提交成功,谢谢您的宝贵意见."];
        [_toast setGravity:iToastGravityBottom];
        [_toast show];
        
        // self navigation pop up
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        iToast *_toast = [iToast makeText:@"提交失败,请重试."];
        [_toast setDuration:iToastDurationNormal];
        [_toast setGravity:iToastGravityBottom];
        [_toast show];
    }
}

-(void) didFailedRequestFeedbackSubmit:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestFeedbackSubmit - request url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
    [_toast setDuration:iToastDurationLong];
    [_toast setGravity:iToastGravityCenter];
    [_toast show];
}

@end
