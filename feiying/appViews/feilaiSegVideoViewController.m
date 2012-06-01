//
//  feilaiSegVideoViewController.m
//  feiying
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "feilaiSegVideoViewController.h"

#import "../constants/systemConstant.h"
#import "../constants/urlConstant.h"
#import "../util/NSString+util.h"
#import "../common/UserManager.h"

#import "../openSource/ASIHTTPRequest/ASIFormDataRequest.h"

@implementation feilaiSegVideoViewController
// private methods
// send request with url
-(void) sendRequestWithUrl:(NSString*) pUrl andPostBody:(NSMutableDictionary*) pPostBodyDic andUserInfo:(NSDictionary*) pUserInfo andFinishedRespMeth:(SEL) pFinRespMeth andFailedRespMeth:(SEL) pFailRespMeth{
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
    NSMutableArray *_postBodyDataArray = [[NSMutableArray alloc] init];
    [pPostBodyDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        // set request post value
        [_request addPostValue:obj forKey:key];
        
        // init post body data array
        [_postBodyDataArray addObject:[[NSString alloc] initWithFormat:@"%@=%@", key, obj]];
    }];
    
    // post request signature
    NSLog(@"post body data array = %@", _postBodyDataArray);
    // postBody data array sort
    NSMutableArray *_sortedArray = [[NSMutableArray alloc] initWithArray:[_postBodyDataArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
    NSLog(@"sorted post body data array = %@", _sortedArray);
    
    // append userKey
    if([[[UserManager shareSingleton] userBean] userKey]){
        [_sortedArray addObject:[[[UserManager shareSingleton] userBean] userKey]];
    }
    NSLog(@"after append user key sorted post body data array = %@", _sortedArray);
    
    // generate signature
    NSMutableString *_sortedArrayString = [[NSMutableString alloc] init];
    for(NSString *_str in _sortedArray){
        [_sortedArrayString appendString:_str];
    }
    NSString *_signature = [_sortedArrayString MD5];
    NSLog(@"the signature is %@", _signature);
    
    // add signature to postBody data
    [_request addPostValue:_signature forKey:@"sig"];
    
    // set user infomation
    _request.userInfo = pUserInfo;
    
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
    [_request startAsynchronous];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // stop viewLoadingIndicatorView and show tableView
        [_mViewLoadingIndicatorView stopAnimating];
        _mTableView.hidden = NO;
        
        // update table view frame
        _mTableView.frame = CGRectMake(_mTableView.frame.origin.x, _mTableView.frame.origin.y, _mTableView.frame.size.width, _mTableView.frame.size.height-35.0);
        
        [self initTableDataSource:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant sendedShareListUrl]]];
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

// overwrite method:(void) initTableDataSource:
-(void) initTableDataSource:(NSString *)pRequestUrl{
    // init reloading tag
    NSDictionary *_userInfo = nil;
    
    // set root url
    if(_mRootUrl == nil || ![_mRootUrl isEqualToString:pRequestUrl]){
        _mRootUrl = pRequestUrl;
    }
    //NSLog(@"root url = %@", _mRootUrl);
    
    // set reloading table sourceData request userInfo
    if(_reloading){
        //NSLog(@"table dataSource size = %d and object = %@", [_mTableDataSource count], _mTableDataSource);
        // set userInfo
        _userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"table dataSource reloading...", @"reqUserInfo", nil];
    }
    
    // init get sended share video list param
    NSMutableDictionary *_getSendedShareListParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[[UserManager shareSingleton] userBean] name], @"username", nil];
    
    // create asynchronous httpRequest
    [self sendRequestWithUrl:pRequestUrl andPostBody:_getSendedShareListParam andUserInfo:_userInfo andFinishedRespMeth:@selector(didFinishedRequestTableData:) andFailedRespMeth:@selector(didFailedRequestTableData:)];
}

@end
