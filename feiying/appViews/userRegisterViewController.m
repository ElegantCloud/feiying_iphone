//
//  userRegisterViewController.m
//  feiying
//
//  Created by  on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "userRegisterViewController.h"
#import "userLoginViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "../openSource/JSONKit/JSONKit.h"
#import "../openSource/ASIHTTPRequest/ASIFormDataRequest.h"
#import "../openSource/Toast/iToast.h"

#import "../constants/systemConstant.h"
#import "../constants/urlConstant.h"

#import "../customComponents/customButton.h"

#import "../util/NSString+util.h"

@implementation userRegisterViewController

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
    
    // need to save cookie
    [_request setUseCookiePersistence:YES];
    
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

// send get validate code request
-(void) sendGetValidateCodeRequest{
    // init get validate code request param
    NSMutableDictionary *_getValidateCodeParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[_mUserNameInput text], @"phone", nil];
    
    [self sendRequestWithUrl:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant getValidateCodeUrl]] andPostBody:_getValidateCodeParam andFinishedRespMeth:@selector(didFinishedRequestGetValidateCode:) andFailedRespMeth:@selector(didFailedRequestGetValidateCode:)];
}

// send check validate code request
-(void) sendCheckValidaterequest{
    // init check validate code request param
    NSMutableDictionary *_checkValidateCodeParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[_mValidateCodeInput text], @"code", nil];
    
    [self sendRequestWithUrl:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant getCheckValidateUrl]] andPostBody:_checkValidateCodeParam andFinishedRespMeth:@selector(didFinishedRequestCheckValidateCode:) andFailedRespMeth:@selector(didFailedRequestCheckValidateCode:)];
}

// send user register request
-(void) sendUserRegisterRequest{
    // send user register request
    NSMutableDictionary *_registerParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[_mPasswordInput text], @"password", [_mPwdConfirmInput text], @"password1", nil];
    
    [self sendRequestWithUrl:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant regUserUrl]] andPostBody:_registerParam andFinishedRespMeth:@selector(didFinishedRequestRegister:) andFailedRespMeth:@selector(didFailedRequestRegister:)];
}

// self init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // set background color
        self.view.backgroundColor = [UIColor grayColor];
        
        // navigation setting
        self.title = @"注册";
        
        // init dictionarys
        _mComponentsDic = [[NSMutableDictionary alloc] init];
        _mRegStepDic = [[NSMutableDictionary alloc] init];
        
        // user register step 1
        // register step1 array
        NSMutableArray *_regStep1Array = [[NSMutableArray alloc] init];
        
        // user name input
        _mUserNameInput = [[UITextField alloc] init];
        // set style
        _mUserNameInput.borderStyle = UITextBorderStyleNone;
        // auto correction
        _mUserNameInput.autocorrectionType = UITextAutocorrectionTypeYes;
        // default display text
        _mUserNameInput.placeholder = @"手机号码";
        // set font
        _mUserNameInput.font = [UIFont systemFontOfSize:14.0];
        _mUserNameInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        // set keyBoard done button
        _mUserNameInput.returnKeyType = UIReturnKeyDone;
        _mUserNameInput.clearButtonMode = UITextFieldViewModeWhileEditing;
        // keyboard type
        _mUserNameInput.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        // set delegate
        _mUserNameInput.delegate = self;
        // add userNameInput to regStep1 array and components dictionary
        [_regStep1Array addObject:@"用户名"];
        [_mComponentsDic setObject:_mUserNameInput forKey:@"用户名"];
        
        // get validate code button
        customButton *_getValidateCodeButton = [[customButton alloc] init];
        // set frame
        _getValidateCodeButton.frame = CGRectMake(0.0, 0.0, 140.0, 30.0);
        // set title
        _getValidateCodeButton.labelText.text = @"获取注册验证码";
        // add target
        [_getValidateCodeButton addTarget:self action:@selector(getRegiValidateCode) forControlEvents:UIControlEventTouchUpInside];
        // add getValidateCodeButton to regStep1 array and components dictionary
        [_regStep1Array addObject:@"getValidateCodeButton"];
        [_mComponentsDic setObject:_getValidateCodeButton forKey:@"getValidateCodeButton"];
        
        // set regStep1 array to user register step dictionary
        [_mRegStepDic setObject:_regStep1Array forKey:[NSNumber numberWithInteger:_mRegStep]];
        
        // user register step 2
        // register step2 array
        NSMutableArray *_regStep2Array = [[NSMutableArray alloc] init];
        
        // validate code input
        _mValidateCodeInput = [[UITextField alloc] init];
        // set style
        _mValidateCodeInput.borderStyle = UITextBorderStyleNone;
        // auto correction
        _mValidateCodeInput.autocorrectionType = UITextAutocorrectionTypeYes;
        // default display text
        _mValidateCodeInput.placeholder = @"验证码";
        // set is secure text
        _mValidateCodeInput.secureTextEntry = YES;
        // set font
        _mValidateCodeInput.font = [UIFont systemFontOfSize:14.0];
        _mValidateCodeInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        // set keyBoard done button
        _mValidateCodeInput.returnKeyType = UIReturnKeyDone;
        _mValidateCodeInput.clearButtonMode = UITextFieldViewModeWhileEditing;
        // keyboard type
        _mValidateCodeInput.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        // set delegate
        _mValidateCodeInput.delegate = self;
        // add validateCodeInput to regStep2 array and components dictionary
        [_regStep2Array addObject:@"验证码"];
        [_mComponentsDic setObject:_mValidateCodeInput forKey:@"验证码"];
        
        // check validate code button
        customButton *_checkValidateCodeButton = [[customButton alloc] init];
        // set frame
        _checkValidateCodeButton.frame = CGRectMake(0.0, 0.0, 140.0, 30.0);
        // set title
        _checkValidateCodeButton.labelText.text = @"验证注册验证码";
        // add target
        [_checkValidateCodeButton addTarget:self action:@selector(checkRegiValidateCode) forControlEvents:UIControlEventTouchUpInside];
        // add checkValidateCodeButton to regStep2 array and components dictionary
        [_regStep2Array addObject:@"checkValidateCodeButton"];
        [_mComponentsDic setObject:_checkValidateCodeButton forKey:@"checkValidateCodeButton"];
        
        // set regStep2 array to user register step dictionary
        [_mRegStepDic setObject:_regStep2Array forKey:[NSNumber numberWithInteger:(_mRegStep+1)]];
        
        // user register setp 3
        // register step3 array
        NSMutableArray *_regStep3Array = [[NSMutableArray alloc] init];
        
        // password input
        _mPasswordInput = [[UITextField alloc] init];
        // set style
        _mPasswordInput.borderStyle = UITextBorderStyleNone;
        // auto correction
        _mPasswordInput.autocorrectionType = UITextAutocorrectionTypeYes;
        // default display text
        _mPasswordInput.placeholder = @"密码";
        // set is secure text
        _mPasswordInput.secureTextEntry = YES;
        // set font
        _mPasswordInput.font = [UIFont systemFontOfSize:14.0];
        _mPasswordInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        // set keyBoard done button
        _mPasswordInput.returnKeyType = UIReturnKeyDone;
        _mPasswordInput.clearButtonMode = UITextFieldViewModeWhileEditing;
        // set delegate
        _mPasswordInput.delegate = self;
        // add passwordInput to regStep3 array and components dictionary
        [_regStep3Array addObject:@"密码"];
        [_mComponentsDic setObject:_mPasswordInput forKey:@"密码"];
        
        // password confirm input
        _mPwdConfirmInput = [[UITextField alloc] init];
        // set style
        _mPwdConfirmInput.borderStyle = UITextBorderStyleNone;
        // auto correction
        _mPwdConfirmInput.autocorrectionType = UITextAutocorrectionTypeYes;
        // default display text
        _mPwdConfirmInput.placeholder = @"保持两次密码一致";
        // set is secure text
        _mPwdConfirmInput.secureTextEntry = YES;
        // set font
        _mPwdConfirmInput.font = [UIFont systemFontOfSize:14.0];
        _mPwdConfirmInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        // set keyBoard done button
        _mPwdConfirmInput.returnKeyType = UIReturnKeyDone;
        _mPwdConfirmInput.clearButtonMode = UITextFieldViewModeWhileEditing;
        // set delegate
        _mPwdConfirmInput.delegate = self;
        // add pwdConfirmInput to regStep3 array and components dictionary
        [_regStep3Array addObject:@"密码确认"];
        [_mComponentsDic setObject:_mPwdConfirmInput forKey:@"密码确认"];
        
        // register confirm button
        customButton *_registerConfirmButton = [[customButton alloc] init];
        // set frame
        _registerConfirmButton.frame = CGRectMake(0.0, 0.0, 100.0, 30.0);
        // set title
        _registerConfirmButton.labelText.text = @"确认注册";
        // add target
        [_registerConfirmButton addTarget:self action:@selector(userRegisterConfirm) forControlEvents:UIControlEventTouchUpInside];
        // add registerConfirmButton to regStep3 array and components dictionary
        [_regStep3Array addObject:@"registerConfirmButton"];
        [_mComponentsDic setObject:_registerConfirmButton forKey:@"registerConfirmButton"];
        
        // set regStep3 array to user register step dictionary
        [_mRegStepDic setObject:_regStep3Array forKey:[NSNumber numberWithInteger:(_mRegStep+2)]];
        
        // self view subView
        // init register table view
        _mUserRegTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        // set background color
        _mUserRegTableView.backgroundColor = [UIColor colorWithRed:1.0 green:255.0/255.0 blue:245.0/255.0 alpha:1.0];;
        // set dataSource
        [_mUserRegTableView setDataSource:self];
        
        // register progressHUD
        _mHud = [[MBProgressHUD alloc] initWithView:self.view];
        _mHud.mode = MBProgressHUDModeDeterminate;
        
        // add subViews to self view
        [self.view addSubview:_mHud];
        [self.view addSubview:_mUserRegTableView];
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

// UITableViewDataSource methods implemetation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray*)[_mRegStepDic objectForKey:[NSNumber numberWithInteger:_mRegStep]] count];
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *_ret = nil;
    
    // set header title for section
    switch (_mRegStep) {
        case 0:
            _ret = @"Step1: 获取注册验证码";
            break;
            
        case 1:
            _ret = @"Step2: 验证注册验证码";
            break;
            
        case 2:
            _ret = @"Step3: 设置登录密码";
            break;
    }
    
    return _ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // table cell
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"test cell"];
    
    if(_cell == nil){
        //NSLog(@"userRegisterViewController - cellForRowAtIndexPath - indexPath = %@", indexPath);
        
        // cell data   
        NSString *_componentLabelString = [[_mRegStepDic objectForKey:[NSNumber numberWithInteger:_mRegStep]] objectAtIndex:[indexPath row]];
        //NSLog(@"_componentLabelString = %@", _componentLabelString);
        // no label
        if([_componentLabelString hasSuffix:@"Button"]){
            _cell = [[controlTableViewCell alloc] initWithLabelTip:nil andControl:[_mComponentsDic objectForKey:_componentLabelString]];
        }
        else{
            _cell = [[controlTableViewCell alloc] initWithLabelTip:_componentLabelString andControl:[_mComponentsDic objectForKey:_componentLabelString]];
        }
    }
    
    return _cell;
}

// UITextFieldDelegate methods implemetation
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

// methods implemetation
// user register confirm
-(void) userRegisterConfirm{
    NSLog(@"user register confirm.");
    
    // judge user input password and confirm pwd
    if(![_mPasswordInput text] || [[[_mPasswordInput text] trimWhitespaceAndNewlineCharacter] isEqualToString:@""] || ![_mPwdConfirmInput text] || [[[_mPwdConfirmInput text] trimWhitespaceAndNewlineCharacter] isEqualToString:@""]){
        NSLog(@"user input pawwsord or confirm pwd is nil.");
        
        iToast *_toast = [iToast makeText:@"密码或确认密码没有输入,请确认."];
        [_toast setDuration:iToastDurationNormal];
        [_toast setGravity:iToastGravityBottom];
        [_toast show];
        
        return;
    }
    
    // textfield resignFirstResponder
    [_mPasswordInput resignFirstResponder];
    [_mPwdConfirmInput resignFirstResponder];
    
    // show progressHud
    _mHud.labelText = @"正在完成注册,情稍后...";
    [_mHud showWhileExecuting:@selector(sendUserRegisterRequest) onTarget:self withObject:nil animated:YES];
}

// get user register validate code
-(void) getRegisterValidateCode{
    NSLog(@"get register validate code.");
    
    // judge user input phone code
    if(![_mUserNameInput text] || [[[_mUserNameInput text] trimWhitespaceAndNewlineCharacter] isEqualToString:@""]){
        NSLog(@"user input phone code is nil.");
        
        iToast *_toast = [iToast makeText:@"请输入用户名,再点击获取手机验证码."];
        [_toast setDuration:iToastDurationNormal];
        [_toast setGravity:iToastGravityBottom];
        [_toast show];
        
        return;
    }
    
    // textfield resignFirstResponder
    [_mUserNameInput resignFirstResponder];
    
    // show progressHud
    _mHud.labelText = @"正在获取手机验证码,情稍后...";
    [_mHud showWhileExecuting:@selector(sendGetValidateCodeRequest) onTarget:self withObject:nil animated:YES];
}

// check user register validate code
-(void) checkRegisterValidateCode{
    NSLog(@"check register validate code.");
    
    // judge user input phone code
    if(![_mValidateCodeInput text] || [[[_mValidateCodeInput text] trimWhitespaceAndNewlineCharacter] isEqualToString:@""]){
        NSLog(@"user input validate code is nil.");
        
        iToast *_toast = [iToast makeText:@"请输入验证码,再点击验证手机验证码."];
        [_toast setDuration:iToastDurationNormal];
        [_toast setGravity:iToastGravityBottom];
        [_toast show];
        
        return;
    }
    
    // textfield resignFirstResponder
    [_mValidateCodeInput resignFirstResponder];
    
    // show progressHud
    _mHud.labelText = @"正在验证手机验证码,情稍后...";
    [_mHud showWhileExecuting:@selector(sendCheckValidaterequest) onTarget:self withObject:nil animated:YES];
}

// ASIHTTPRequestDelegate methods implemetation
// get validate code request response methods
-(void) didFinishedRequestGetValidateCode:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestGetValidateCode - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    //NSLog(@"response json format data = %@", _jsonData);
    
    // get login result
    if(pRequest.responseStatusCode == 200 && _jsonData){
        NSString *_result = [_jsonData objectForKey:@"result"];
        
        // 0 - succeed
        if([_result isEqualToString:@"0"]){
            // user register step2
            _mRegStep = 1;
            _mValidateCodeInput.text = nil;
            [_mUserRegTableView reloadData];
        }
        // 2 - user input phone format errpr
        else if([_result isEqualToString:@"2"]){
            iToast *_toast = [iToast makeText:@"您输入的手机号码格式错误."];
            [_toast setDuration:iToastDurationNormal];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
        }
        // 3 - user input phone had been registed
        else if([_result isEqualToString:@"3"]){
            iToast *_toast = [iToast makeText:@"该手机号码已经被注册过."];
            [_toast setDuration:iToastDurationNormal];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
        }
    }
    else{
        iToast *_toast = [iToast makeText:@"访问服务器异常,请重试."];
        [_toast setDuration:iToastDurationNormal];
        [_toast setGravity:iToastGravityBottom];
        [_toast show];
    }
}

-(void) didFailedRequestGetValidateCode:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestGetValidateCode - request url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
    [_toast setDuration:iToastDurationLong];
    [_toast show];
}

// check validate code request response methods
-(void) didFinishedRequestCheckValidateCode:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestCheckValidateCode - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    //NSLog(@"response json format data = %@", _jsonData);
    
    // get login result
    if(pRequest.responseStatusCode == 200 && _jsonData){
        NSString *_result = [_jsonData objectForKey:@"result"];
        
        // 0 - succeed
        if([_result isEqualToString:@"0"]){
            // user register step3
            _mRegStep = 2;
            _mPasswordInput.text = nil;
            _mPwdConfirmInput .text = nil;
            [_mUserRegTableView reloadData];
        }
        // 2 - validate code error
        else if([_result isEqualToString:@"2"]){
            iToast *_toast = [iToast makeText:@"验证码错误,请重新输入.."];
            [_toast setDuration:iToastDurationNormal];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
        }
        // 6 - validate code timeout
        else if([_result isEqualToString:@"6"]){
            iToast *_toast = [iToast makeText:@"此验证码已过期，请重新获取."];
            [_toast setDuration:iToastDurationLong];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
            
            // back to user register step1
            _mRegStep = 0;
            [_mUserRegTableView reloadData];
        }
    }
    else{
        iToast *_toast = [iToast makeText:@"访问服务器异常,请重试."];
        [_toast setDuration:iToastDurationNormal];
        [_toast setGravity:iToastGravityBottom];
        [_toast show];
    }
}

-(void) didFailedRequestCheckValidateCode:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestCheckValidateCode - request url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
    [_toast setDuration:iToastDurationLong];
    [_toast show];
}

// register confirm request response methods
-(void) didFinishedRequestRegister:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestRegister - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    //NSLog(@"response json format data = %@", _jsonData);
    
    // get login result
    if(pRequest.responseStatusCode == 200 && _jsonData){
        NSString *_result = [_jsonData objectForKey:@"result"];
        
        // 0 - succeed
        if([_result isEqualToString:@"0"]){
            [self.navigationController popViewControllerAnimated:YES];
        }
        // 5- confirm password not matches first input pwd
        else if([_result isEqualToString:@"5"]){
            iToast *_toast = [iToast makeText:@"两次密码不一致，请重新输入."];
            [_toast setDuration:iToastDurationNormal];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
        }
        // 6 - register timeout
        else if([_result isEqualToString:@"6"]){
            iToast *_toast = [iToast makeText:@"此次注册操作已过期，请重新开始."];
            [_toast setDuration:iToastDurationLong];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
            
            // back to user register step1
            _mRegStep = 0;
            [_mUserRegTableView reloadData];
        }
    }
    else{
        iToast *_toast = [iToast makeText:@"访问服务器异常,请重试."];
        [_toast setDuration:iToastDurationNormal];
        [_toast setGravity:iToastGravityBottom];
        [_toast show];
    }
}

-(void) didFailedRequestRegister:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestRegister - request url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
    [_toast setDuration:iToastDurationLong];
    [_toast show];
}

@end
