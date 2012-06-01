//
//  userAccountSettingViewController.m
//  feiying
//
//  Created by  on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "userAccountSettingViewController.h"
#import "userLoginViewController.h"
#import "../customComponents/tabViewNavigationController.h"
#import "../customComponents/customButton.h"

#import "../openSource/JSONKit/JSONKit.h"
#import "../openSource/ASIHTTPRequest/ASIFormDataRequest.h"
#import "../openSource/Toast/iToast.h"

#import "../constants/systemConstant.h"
#import "../constants/urlConstant.h"
#import "../common/UserManager.h"
#import "../util/NSString+util.h"

#import <MessageUI/MessageUI.h>

#import "AppDelegate.h"

@implementation userAccountSettingViewController

@synthesize userRegLoginDelegate = _userRegLoginDelegate;

@synthesize userNameInput = _mUserNameInput;

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

// send get register and login validate code request
-(void) sendGetRegLoginValidateCodeRequest{
    // init get register and login validate code request param
    NSMutableDictionary *_getRegLoginValidateCodeParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[_mUserNameInput text], @"phone", nil];
    
    [self sendRequestWithUrl:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant getValidateCodeUrl]] andPostBody:_getRegLoginValidateCodeParam andFinishedRespMeth:@selector(didFinishedRequestGetRegLoginValidateCode:) andFailedRespMeth:@selector(didFailedRequestGetRegLoginValidateCode:)];
}

// send user register and login checking request
-(void) sendUserRegLoginCheckingRequest{
    // get device info
    NSString *_brand = @"apple";
    NSString *_model = [[UIDevice currentDevice] model];
    NSString *_release = [NSString stringWithFormat:@"%@ %@", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
    NSString *_sdk = @"ios 5.0";
    //NSLog(@"brand = %@, model = %@, release = %@ and sdk = %@", _brand, _model, _release, _sdk);
    
    // init user register and login checking request param
    NSMutableDictionary *_userRegLoginCheckingParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[_mValidateCodeInput text], @"code", _brand, @"brand", _model, @"model", _release, @"release", _sdk, @"sdk", nil];
    
    [self sendRequestWithUrl:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant userRegLoginUrl]] andPostBody:_userRegLoginCheckingParam andFinishedRespMeth:@selector(didFinishedRequestUserRegLoginChecking:) andFailedRespMeth:@selector(didFailedRequestUserRegLoginChecking:)];
}

// self init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // set title
        self.title = (_isAppStartedLoading) ? @"欢迎使用飞影" : @"帐号设置";
        
        // set navigationItem
        // create back barButtonItem as right navigationBar barButtonItem if it is not the app started loading
        self.navigationItem.leftBarButtonItem = (_isAppStartedLoading) ? nil : [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(userAccountSettingCancel)];
        // set right navigationItem is nil
        self.navigationItem.rightBarButtonItem = nil;
        
        // init dictionarys
        _mComponentsDic = [[NSMutableDictionary alloc] init];
        _mRegLoginStepDic = [[NSMutableDictionary alloc] init];
        
        // user register and login step 1
        // register and login step1 array
        NSMutableArray *_regLoginStep1Array = [[NSMutableArray alloc] init];
        
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
        _mUserNameInput.keyboardType = /*UIKeyboardTypeNumbersAndPunctuation*/UIKeyboardTypeNumberPad;
        // set delegate
        _mUserNameInput.delegate = self;
        // add userNameInput to regLoginStep1 array and components dictionary
        [_regLoginStep1Array addObject:@"手机号码"];
        [_mComponentsDic setObject:_mUserNameInput forKey:@"手机号码"];
        
        // get validate code button
        customButton *_getRegLoginValidateCodeButton = [[customButton alloc] init];
        // set frame
        _getRegLoginValidateCodeButton.frame = CGRectMake(0.0, 0.0, 120.0, 30.0);
        // set title
        _getRegLoginValidateCodeButton.labelText.text = @"获取验证码";
        // add target
        [_getRegLoginValidateCodeButton addTarget:self action:@selector(getRegLoginValidateCode) forControlEvents:UIControlEventTouchUpInside];
        // add getRegLoginValidateCodeButton to regLoginStep1 array and components dictionary
        [_regLoginStep1Array addObject:@"getRegLoginValidateCodeButton"];
        [_mComponentsDic setObject:_getRegLoginValidateCodeButton forKey:@"getRegLoginValidateCodeButton"];
        
        // set regLoginStep1 array to user register and login step dictionary
        [_mRegLoginStepDic setObject:_regLoginStep1Array forKey:[NSNumber numberWithInteger:_mRegLoginStep]];
        
        // user register and login step 2
        // register and login step2 array
        NSMutableArray *_regLoginStep2Array = [[NSMutableArray alloc] init];
        
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
        _mValidateCodeInput.keyboardType = /*UIKeyboardTypeNumbersAndPunctuation*/UIKeyboardTypeNumberPad;
        // set delegate
        _mValidateCodeInput.delegate = self;
        // add validateCodeInput to regLoginStep2 array and components dictionary
        [_regLoginStep2Array addObject:@"验证码"];
        [_mComponentsDic setObject:_mValidateCodeInput forKey:@"验证码"];
        
        // check validate code button
        customButton *_userRegLoginCheckingButton = [[customButton alloc] init];
        // set frame
        _userRegLoginCheckingButton.frame = CGRectMake(0.0, 0.0, 140.0, 30.0);
        // set title
        _userRegLoginCheckingButton.labelText.text = @"注册/登录验证";
        // add target
        [_userRegLoginCheckingButton addTarget:self action:@selector(userRegLoginChecking) forControlEvents:UIControlEventTouchUpInside];
        // add userRegLoginCheckingButton to regLoginStep2 array and components dictionary
        [_regLoginStep2Array addObject:@"userRegLoginCheckingButton"];
        [_mComponentsDic setObject:_userRegLoginCheckingButton forKey:@"userRegLoginCheckingButton"];
        
        // set regLoginStep2 array to user register and login step dictionary
        [_mRegLoginStepDic setObject:_regLoginStep2Array forKey:[NSNumber numberWithInteger:(_mRegLoginStep+1)]];
        
        // user register and login step 3
        // register and login step3 array
        NSMutableArray *_regLoginStep3Array = [[NSMutableArray alloc] init];
        
        // feiying business introduce description
        NSString *_feiyingBusinessIntro = @"       安徽联通飞影业务，是针对经常使用3G网络观看视频用户开放的，开通此业务，您可以不花费手机套餐包月流量，随时随地随意使用安徽飞影手机客户端观看视频。\n       此业务每月5元，点击开通业务按钮，发送短信开通安徽联通飞影业务。您也可以发送短信、登录安徽联通网上营业厅或到各个营业厅退订此业务。";
        // add feiyingBusinessLabel to regLoginStep3 array and components dictionary
        [_regLoginStep3Array addObject:_feiyingBusinessIntro];
        [_mComponentsDic setObject:[NSNull null] forKey:_feiyingBusinessIntro];
        
        // open feiying business button
        customButton *_openFeiyingBusinessButton = [[customButton alloc] init];
        // set frame
        _openFeiyingBusinessButton.frame = CGRectMake(0.0, 0.0, 80.0, 30.0);
        // set title
        _openFeiyingBusinessButton.labelText.text = @"开通业务";
        // add target
        [_openFeiyingBusinessButton addTarget:self action:@selector(openFeiyingBusiness) forControlEvents:UIControlEventTouchUpInside];
        
        // abort open feiying business button
        customButton *_abortOpenFeiyingBusinessButton = [[customButton alloc] init];
        // set frame
        _abortOpenFeiyingBusinessButton.frame = CGRectMake(0.0, 0.0, 80.0, 30.0);
        // set title
        _abortOpenFeiyingBusinessButton.labelText.text = @"暂不开通";
        // add target
        [_abortOpenFeiyingBusinessButton addTarget:self action:@selector(abortOpenFeiyingBusiness) forControlEvents:UIControlEventTouchUpInside];
        
        // init 
        NSArray *_controls = [NSArray arrayWithObjects:_openFeiyingBusinessButton, _abortOpenFeiyingBusinessButton, nil];
        // add openFeiyingBusinessButton to regLoginStep3 array and components dictionary
        [_regLoginStep3Array addObject:@"openFeiyingBusinessButton"];
        [_mComponentsDic setObject:_controls forKey:@"openFeiyingBusinessButton"];
        
        // set regLoginStep3 array to user register and login step dictionary
        [_mRegLoginStepDic setObject:_regLoginStep3Array forKey:[NSNumber numberWithInteger:(_mRegLoginStep+2)]];
        
        // init user register and login table view
        _mUserRegLoginTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        // set background color
        _mUserRegLoginTableView.backgroundColor = BACKGROUNDCOLOR;
        // set dataSource and delegate
        [_mUserRegLoginTableView setDataSource:self];
        [_mUserRegLoginTableView setDelegate:self];
        
        // login and register progressHUD
        _mHud = [[MBProgressHUD alloc] initWithView:self.view];
        //_mHud.mode = MBProgressHUDModeDeterminate;
        
        // add subViews to self view
        [self.view addSubview:_mUserRegLoginTableView];
        [self.view addSubview:_mHud];
    }
    return self;
}

// init with app started
-(id) initWithAppStarted{
    // set app started loading flag
    _isAppStartedLoading = YES;
    
    return [self initWithNibName:nil bundle:nil];
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
	//return YES;
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

// UITableViewDataSource methods implemetation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray*)[_mRegLoginStepDic objectForKey:[NSNumber numberWithInteger:_mRegLoginStep]] count];
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *_ret = nil;
    
    // set header title for section
    switch (_mRegLoginStep) {
        case 0:
            _ret = (_isAppStartedLoading)? @"" : @"第1步: 获取注册/登录验证码";
            break;
            
        case 1:
            _ret = @"第2步: 用户注册/登录验证";
            break;
            
        case 2:
            _ret = @"第3步: 开通安徽联通飞影业务";
            break;
    }
    
    return _ret;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *_retView = nil;
    
    if (_mRegLoginStep == 0 && _isAppStartedLoading) {
        // create and first login step 1 section title label view
        _retView = [[UIView alloc] init];
        _retView.backgroundColor = [UIColor clearColor];
        
        // user info setting label
        UILabel *_userInfoSettingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 15.0, [UIScreen mainScreen].bounds.size.width-2*20.0, 22.0)];
        // set background color
        _userInfoSettingLabel.backgroundColor = [UIColor clearColor];
        // set text and font
        _userInfoSettingLabel.text = @"请先设置帐户信息";
        _userInfoSettingLabel.textColor = [UIColor darkGrayColor];
        _userInfoSettingLabel.textAlignment = UITextAlignmentCenter;
        _userInfoSettingLabel.font = [UIFont boldSystemFontOfSize:18.0];
        // add to view
        [_retView addSubview:_userInfoSettingLabel];
        
        // step 1 tip label
        UILabel *_step1TipLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userInfoSettingLabel.frame.origin.x, _userInfoSettingLabel.frame.origin.y+_userInfoSettingLabel.frame.size.height+6.0, _userInfoSettingLabel.frame.size.width, 22.0)];
        // set background color
        _step1TipLabel.backgroundColor = [UIColor clearColor];
        // set text and font
        _step1TipLabel.text = @"第1步: 获取注册/登录验证码";
        _step1TipLabel.textColor = [UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:108.0/255.0 alpha:1.0];;
        _step1TipLabel.font = [UIFont boldSystemFontOfSize:17.0];
        // add to view
        [_retView addSubview:_step1TipLabel];
    }
    
    return _retView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    // set default section header height
    CGFloat _ret = 45.0;
    
    if (_mRegLoginStep == 0 && _isAppStartedLoading) {
        _ret += 30.0;
    }
    
    return _ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // table cell
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"test cell"];
    
    if(_cell == nil){
        //NSLog(@"userAccountSettingViewController - cellForRowAtIndexPath - indexPath = %@", indexPath);
        
        // cell data   
        NSString *_componentLabelString = [[_mRegLoginStepDic objectForKey:[NSNumber numberWithInteger:_mRegLoginStep]] objectAtIndex:[indexPath row]];
        //NSLog(@"_componentLabelString = %@", _componentLabelString);
        // no label
        if([_componentLabelString hasSuffix:@"Button"]){
            if([[_mComponentsDic objectForKey:_componentLabelString] isKindOfClass:[UIControl class]]){
                _cell = [[controlTableViewCell alloc] initWithLabelTip:nil andControl:[_mComponentsDic objectForKey:_componentLabelString]];
            }
            else if([[_mComponentsDic objectForKey:_componentLabelString] isKindOfClass:[NSArray class]]){
                _cell = [[controlTableViewCell alloc] initWithControls:[_mComponentsDic objectForKey:_componentLabelString]];
            }
        }
        else if([_mComponentsDic objectForKey:_componentLabelString] == [NSNull null]){
            _cell = [[controlTableViewCell alloc] initWithLabelTip:_componentLabelString andControl:nil];
        }
        else{
            _cell = [[controlTableViewCell alloc] initWithLabelTip:_componentLabelString andControl:[_mComponentsDic objectForKey:_componentLabelString]];
        }
    }
    
    return _cell;
}

// UITableViewDelegate methods implemetation
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // define return value
    CGFloat _ret = 0;
    
    tableView.delegate = nil;
    _ret = [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
    tableView.delegate = self;
    
    return _ret;
}

// UITextFieldDelegate methods implemetation
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

// ASIHTTPRequestDelegate methods implemetation
// get register and login validate code request response methods
-(void) didFinishedRequestGetRegLoginValidateCode:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestGetValidateCode - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    NSLog(@"response json format data = %@", _jsonData);
    
    // get login result
    if(pRequest.responseStatusCode == 200 && _jsonData){
        NSString *_result = [_jsonData objectForKey:@"result"];
        
        // 0 - succeed
        if([_result isEqualToString:@"0"]){
            // user register and login step2
            _mRegLoginStep = 1;
            _mValidateCodeInput.text = nil;
            [_mUserRegLoginTableView reloadData];
        }
        // 2 - user input phone format errpr
        else if([_result isEqualToString:@"2"]){
            iToast *_toast = [iToast makeText:@"您输入的手机号码格式错误."];
            [_toast setDuration:iToastDurationNormal];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
        }
    }
    else{
        iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
        [_toast setDuration:iToastDurationLong];
        [_toast setGravity:iToastGravityCenter];
        [_toast show];
    }
}

-(void) didFailedRequestGetRegLoginValidateCode:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestGetRegLoginValidateCode - request url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
    [_toast setDuration:iToastDurationLong];
    [_toast setGravity:iToastGravityCenter];
    [_toast show];
}

// user register and login checking request response methods
-(void) didFinishedRequestUserRegLoginChecking:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestUserRegLoginChecking - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    NSLog(@"response json format data = %@", _jsonData);
    
    // get login result
    if(pRequest.responseStatusCode == 200 && _jsonData){
        NSString *_result = [_jsonData objectForKey:@"result"];
        
        // 0 - succeed
        if([_result isEqualToString:@"0"]){
            // get user register and login checking response info
            NSString *_status = [[_jsonData objectForKey:@"info"] objectForKey:@"status"];
            NSString *_userKey = [[_jsonData objectForKey:@"info"] objectForKey:@"userkey"];
            NSLog(@"user register and login checking response info - status = %@ and userkey = %@", _status, _userKey);
            
            // business opened
            if([_status isEqualToString:@"opened"]){
                // add user bean
                [[UserManager shareSingleton] setUser:[_mUserNameInput text] andUserKey:_userKey andBusinessOpened:opened];
                
                // save login user name, userKey and auto login flag
                NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
                [_userDefaults setObject:_mUserNameInput.text forKey:@"loginName"];
                [_userDefaults setObject:_userKey forKey:@"loginUserKey"];
                [_userDefaults setObject:[NSNumber numberWithInt:opened] forKey:@"businessState"];
                [_userDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"autoLogin"];
                
                // call userLoginDelegate method
                [_userRegLoginDelegate userLoginSucceed];
            }
            else if([_status isEqualToString:@"unopened"]){
                NSLog(@"business unopened.");
                
                /*
                // user register and login step3
                _mRegLoginStep = 2;
                [_mUserRegLoginTableView reloadData];
                 */
                
                // add user bean
                [[UserManager shareSingleton] setUser:[_mUserNameInput text] andUserKey:_userKey andBusinessOpened:unopened];
                
                // save login user name, userKey and auto login flag
                NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
                [_userDefaults setObject:_mUserNameInput.text forKey:@"loginName"];
                [_userDefaults setObject:_userKey forKey:@"loginUserKey"];
                [_userDefaults setObject:[NSNumber numberWithInt:unopened] forKey:@"businessState"];
                [_userDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"autoLogin"];
                
                // call userLoginDelegate method
                [_userRegLoginDelegate userLoginSucceed];
            }
            else if([_status isEqualToString:@"processing"]){
                NSLog(@"business processing.");
                
                // this case has not been processed
                //
            }
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
            
            // back to user login register step1
            _mRegLoginStep = 0;
            [_mUserRegLoginTableView reloadData];
        }
    }
    else{
        iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
        [_toast setDuration:iToastDurationLong];
        [_toast setGravity:iToastGravityCenter];
        [_toast show];
    }
}

-(void) didFailedRequestCheckValidateCode:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestCheckValidateCode - request url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
    [_toast setDuration:iToastDurationLong];
    [_toast setGravity:iToastGravityCenter];
    [_toast show];
}

// methods implemetation
-(void) userAccountSettingCancel{
    // dismiss userLogin viewController or navigation pop up
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

// get user register and login validate code
-(void) getRegLoginValidateCode{
    NSLog(@"get register and login validate code.");
    
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
    [_mHud showWhileExecuting:@selector(sendGetRegLoginValidateCodeRequest) onTarget:self withObject:nil animated:YES];
}

// user register and login checking
-(void) userRegLoginChecking{
    NSLog(@"user register and login checking.");
    
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
    [_mHud showWhileExecuting:@selector(sendUserRegLoginCheckingRequest) onTarget:self withObject:nil animated:YES];
}

// open feiying business
-(void) openFeiyingBusiness{
    // judge sms supply device
    if([MFMessageComposeViewController canSendText]){  
        // init and show cann't send sms alert
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:nil message:@"此功能暂时没有实现" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [_alert show];
    }
    else{
        // init and show cann't send sms alert
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:nil message:@"你的设备不能发送短信." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [_alert show];
    }
}

// abort open feiying business
-(void) abortOpenFeiyingBusiness{
    NSLog(@"abortOpenFeiyingBusiness.");
    
    // remove user
    [[UserManager shareSingleton] removeUser];
    
    // save login user name, userKey and auto login flag
    NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
    [_userDefaults removeObjectForKey:@"loginName"];
    [_userDefaults removeObjectForKey:@"loginUserKey"];
    [_userDefaults removeObjectForKey:@"autoLogin"];
    
    // call userLoginDelegate method
    [_userRegLoginDelegate userLoginSucceed];
}

@end
