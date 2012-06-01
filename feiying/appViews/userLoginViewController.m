//
//  userLoginViewController.m
//  feiying
//
//  Created by  on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "userLoginViewController.h"
#import "baseTabViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "../openSource/JSONKit/JSONKit.h"
#import "../openSource/Toast/iToast.h"

#import "userRegisterViewController.h"
#import "../util/NSString+util.h"
#import "../common/UserManager.h"
#import "../constants/systemConstant.h"
#import "../constants/urlConstant.h"

@implementation userLoginViewController

@synthesize userLoginDelegate = _userLoginDelegate;

@synthesize userNameInput = _mUserNameInput;
@synthesize passwordInput = _mPasswordInput;

// private methods
-(void) autoLoginIsOn:(UISwitch*) pSwitch{
    if(pSwitch.on){
        [_mRememberPasswordSwitch setOn:YES animated:YES];
        _mRememberPasswordSwitch.enabled = NO;
    }
    else{
        _mRememberPasswordSwitch.enabled = YES;
    }
}

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

// send login request
-(void) sendLoginRequest{
    // init login request param
    NSMutableDictionary *_loginParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[_mUserNameInput text], @"loginName", [[_mPasswordInput text] md5], @"loginPwd", nil];
     
    [self sendRequestWithUrl:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant loginUrl]]  andPostBody:_loginParam andFinishedRespMeth:@selector(didFinishedRequestLogin:) andFailedRespMeth:@selector(didFailedRequestLogin:)];
}

// self init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // navigation setting
        self.title = @"登录";
        
        // create back barButtonItem as right navigationBar barButtonItem
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(userLoginCancel)];
        
        // create user register barButtonItem as right navigationBar barButtonItem
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleBordered target:self action:@selector(userRegisterNavigation)];
        
        // hide tabBar when pushed
        self.hidesBottomBarWhenPushed = YES;
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height+49.0);
        
        // components setting
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
        //
        _mUserNameInput.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        // set delegate
        _mUserNameInput.delegate = self;
        
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
        
        // remember password switch
        _mRememberPasswordSwitch = [[UISwitch alloc] init];
        // set switch on
        _mRememberPasswordSwitch.on = YES;
        
        // auto login switch
        _mAutoLoginSwitch = [[UISwitch alloc] init];
        [_mAutoLoginSwitch addTarget:self action:@selector(autoLoginIsOn:) forControlEvents:UIControlEventValueChanged];
        
        // login button
        _mLoginButton = [[customButton alloc] init];
        // set frame
        _mLoginButton.frame = CGRectMake(0.0, 0.0, 80.0, 30.0);
        // set title
        _mLoginButton.labelText.text = @"登录";
        // add target
        [_mLoginButton addTarget:self action:@selector(userLoginAction) forControlEvents:UIControlEventTouchUpInside];
        
        // self view subView
        // init login table view
        UITableView *_loginTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        // set background color
        _loginTableView.backgroundColor = [UIColor colorWithRed:1.0 green:255.0/255.0 blue:245.0/255.0 alpha:1.0];;
        // set dataSource
        [_loginTableView setDataSource:self];
        
        // login progressHUD
        _mHud = [[MBProgressHUD alloc] initWithView:self.view];
        _mHud.mode = MBProgressHUDModeDeterminate;
        _mHud.labelText = @"正在登录,请稍后...";
        
        // add subViews to self view
        [self.view addSubview:_loginTableView];
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

// UITableViewDataSource methods implemetation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // table cell
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"test cell"];
    
    if(_cell == nil){
        //NSLog(@"userLoginViewController - cellForRowAtIndexPath - indexPath = %@", indexPath);
        
        // cell data        
        switch ([indexPath row]) {
            case 0:
                _cell = [[controlTableViewCell alloc] initWithLabelTip:@"用户名" andControl:_mUserNameInput];
                break;
                
            case 1:
                _cell = [[controlTableViewCell alloc] initWithLabelTip:@"密码" andControl:_mPasswordInput];
                break;
                
            case 2:
                _cell = [[controlTableViewCell alloc] initWithLabelTip:@"记住密码" andControl:_mRememberPasswordSwitch];
                break;
                
            case 3:
                _cell = [[controlTableViewCell alloc] initWithLabelTip:@"自动登录" andControl:_mAutoLoginSwitch];
                break;
            
            case 4:
                _cell = [[controlTableViewCell alloc] initWithLabelTip:nil andControl:_mLoginButton];
                break;
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
// user register navigate action
-(void) userRegisterNavigation{    
    // create and init user register view controller
    userRegisterViewController *registerViewController = [[userRegisterViewController alloc] init];

    [self.navigationController pushViewController:registerViewController animated:YES];
}

// user login action
-(void) userLoginAction{
    NSLog(@"user login.");
    
    // get input user name, password, auto login flag and remember password flag
    NSString *_inputUserName = [_mUserNameInput text];
    NSString *_inputPassword = [_mPasswordInput text];
    BOOL needToAutoLogin = _mAutoLoginSwitch.on;
    BOOL needToRememberPwd = _mRememberPasswordSwitch.on;
    NSLog(@"input user name = %@, password = %@, auto login flag = %d and remember password flag = %d", _inputUserName, _inputPassword, needToAutoLogin, needToRememberPwd);
    
    // jedge user input name and password
    if(!_inputUserName || [[_inputUserName trimWhitespaceAndNewlineCharacter] isEqualToString:@""] || !_inputPassword || [[_inputPassword trimWhitespaceAndNewlineCharacter] isEqualToString:@""]){
        NSLog(@"please input user name or password.");
        
        iToast *_toast = [iToast makeText:@"用户名或密码没有输入,请确认."];
        [_toast setDuration:iToastDurationNormal];
        [_toast setGravity:iToastGravityBottom];
        [_toast show];
    }
    else{
        // textfield resignFirstResponder
        [_mUserNameInput resignFirstResponder];
        [_mPasswordInput resignFirstResponder];
        
        // show progressHud
        [_mHud showWhileExecuting:@selector(sendLoginRequest) onTarget:self withObject:nil animated:YES];
    }
}

// user login cancel
-(void) userLoginCancel{
    // dismiss userLogin viewController or navigation pop up
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

// ASIHTTPRequestDelegate methods implemetation
// login request response methods
-(void) didFinishedRequestLogin:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestLogin - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    //NSLog(@"response json format data = %@", _jsonData);
    
    // get login result
    if(pRequest.responseStatusCode == 200 && _jsonData){
        NSString *_result = [_jsonData objectForKey:@"result"];
        
        // 0 - succeed
        if([_result isEqualToString:@"0"]){
            // add user bean
            [[UserManager shareSingleton] setUser:[_mUserNameInput text] andPwd:[_mPasswordInput text]];
            
            // save login user name, password, auto login flag and remember pwd
            NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
            [_userDefaults setObject:_mUserNameInput.text forKey:@"loginName"];
            if(_mRememberPasswordSwitch.on){
                [_userDefaults setObject:_mPasswordInput.text forKey:@"loginPwd"];
            }
            else{
                [_userDefaults removeObjectForKey:@"loginPwd"];
            }
            if(_mAutoLoginSwitch.on){
                [_userDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"autoLogin"];
            }
            
            // call userLoginDelegate method
            [_userLoginDelegate userLoginSucceed];
        }
        else{
            iToast *_toast = [iToast makeText:@"登录失败,用户名或密码错误."];
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

-(void) didFailedRequestLogin:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestLogin - request url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
    [_toast setDuration:iToastDurationLong];
    [_toast show];
}

@end

////////////////////////////////////
@implementation controlTableViewCell

-(id) initWithLabelTip:(NSString *)pString andControl:(UIControl *)pControl{
    self = [super init];
    if (self) {
        //NSLog(@"controlTableViewCell - initWithLabelTip - tip string = %@ and control = %@", pString, pControl);
        // set cell default height
        CGFloat _cellHeight = 40.0;
        
        // set style
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // save control width
        CGFloat _controlWidth = pControl.frame.size.width;
        
        // cell content setting
        UILabel *_labelTip = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 5.0, 80.0, 30.0)];
        // set text
        _labelTip.font = [UIFont boldSystemFontOfSize:15];
        _labelTip.text = pString;
        _labelTip.backgroundColor = [UIColor clearColor];
        
        
        pControl.frame = CGRectMake(_labelTip.frame.origin.x+_labelTip.frame.size.width+5.0, _labelTip.frame.origin.y, self.frame.size.width-(_labelTip.frame.origin.x+_labelTip.frame.size.width+5.0)-_labelTip.frame.origin.x-20.0, _labelTip.frame.size.height);
        
        // add table cell content to view
        if(pString && pControl == nil){
            // update label tip frame and font
            // get label string row
            NSInteger _rows = 0;
            for(NSString *_paragraph in [pString getStrParagraphArray]){
                _rows += ((NSInteger)[_paragraph getStrPixelLenByFontSize:14]%260==0) ? [_paragraph getStrPixelLenByFontSize:14]/260.0 : [_paragraph getStrPixelLenByFontSize:14]/260.0+1; 
            }
            // update frame
            _labelTip.frame = CGRectMake(_labelTip.frame.origin.x, _labelTip.frame.origin.y, 280.0, _rows*[pString getStrPixelHeightByFontSize:14]);
            _labelTip.numberOfLines = _rows;
            // update font
            _labelTip.font = [UIFont systemFontOfSize:14.0];
            
            //update cellHeight
            _cellHeight = _rows*[pString getStrPixelHeightByFontSize:14]+2*5.0;
        }
        else if(pString == nil && pControl){
            // control left move center
            pControl.frame = CGRectMake((self.frame.size.width-20.0-_controlWidth)/2, pControl.frame.origin.y, _controlWidth, pControl.frame.size.height);
        }
        
        // add components to cell content view
        if(pString){
            [self.contentView addSubview:_labelTip];
        }
        if(pControl){
            [self.contentView addSubview:pControl];
        }
        
        // set frame size height
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _cellHeight);
    }
    return self;
}

// init with controls array
-(id) initWithControls:(NSArray*) pControls{
    self = [super init];
    if (self) {
        //NSLog(@"controlTableViewCell - initWithLabelTip - tip string = %@ and control = %@", pString, pControl);
        // set cell default height
        CGFloat _cellHeight = 40.0;
        
        // set style
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // save each control's width and add each control to cell content view
        NSMutableArray *_controlsWidthArray = [[NSMutableArray alloc] initWithCapacity:[pControls count]];
        for(UIControl *_control in pControls){
            // save width
            [_controlsWidthArray addObject:[NSNumber numberWithFloat:_control.frame.size.width]];
            // add to cell content view
            [self.contentView addSubview:_control];
        }
        
        // process two and three controls
        switch ([pControls count]) {
            case 2:
                {
                    // get two controls
                    UIControl *_control1 = [pControls objectAtIndex:0];
                    UIControl *_control2 = [pControls objectAtIndex:1];
                    
                    // controls move
                    _control1.frame = CGRectMake((self.frame.size.width-20.0)/2-5.0-((NSNumber*)[_controlsWidthArray objectAtIndex:0]).floatValue, 5.0, ((NSNumber*)[_controlsWidthArray objectAtIndex:0]).floatValue, 30.0);
                    _control2.frame = CGRectMake((self.frame.size.width-20.0)/2+5.0, 5.0, ((NSNumber*)[_controlsWidthArray objectAtIndex:1]).floatValue, 30.0);
                }
                break;
            
            case 3:
                {
                    // get three controls
                    UIControl *_control1 = [pControls objectAtIndex:0];
                    UIControl *_control2 = [pControls objectAtIndex:1];
                    UIControl *_control3 = [pControls objectAtIndex:2];
                    
                    // controls center
                    _control2.frame = CGRectMake((self.frame.size.width-20.0-((NSNumber*)[_controlsWidthArray objectAtIndex:1]).floatValue)/2, 5.0, ((NSNumber*)[_controlsWidthArray objectAtIndex:1]).floatValue, 30.0);
                    _control1.frame = CGRectMake(_control2.frame.origin.x-5.0-((NSNumber*)[_controlsWidthArray objectAtIndex:0]).floatValue, 5.0, ((NSNumber*)[_controlsWidthArray objectAtIndex:0]).floatValue, 30.0);
                    _control3.frame = CGRectMake(_control2.frame.origin.x+((NSNumber*)[_controlsWidthArray objectAtIndex:1]).floatValue+5.0, 5.0, ((NSNumber*)[_controlsWidthArray objectAtIndex:2]).floatValue, 30.0);
                }
                break;
        }
        
        // set frame size height
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _cellHeight);
    }
    return self;
}

@end
