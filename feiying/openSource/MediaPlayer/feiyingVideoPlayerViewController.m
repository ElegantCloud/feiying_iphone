//
//  feiyingVideoPlayerViewController.m
//  sampleVideoPlayer
//
//  Created by  on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "feiyingVideoPlayerViewController.h"

#import "../ASIHTTPRequest/Reachability/Reachability.h"
#import "../../common/UserManager.h"

#define SPECIALURL [NSURL URLWithString:@"http://fy1.richitec.com/feiying"]

static BOOL feiyingVideoPlayerIsPlaying;
static feiyingVideoPlayerViewController *feiyingVideoPlayerRef;

@implementation feiyingVideoPlayerViewController

// private methods
// cancel loading to play video
-(void) cancelLoadingView{
    NSLog(@"cancel loading to play the video.");
    
    if(_mIsPrepared){
        // remove loadStateChanged observer
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        
        // remove moviePlaybackDidFinished observer
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    }
    
    // cancel the fetch video url request
    if(!_mUrlIsPrepared && _mFetchVideoUrlRequest){
        [_mFetchVideoUrlRequest clearDelegatesAndCancel];
    }
    
    // back to previous view
    feiyingVideoPlayerRef = nil;
    feiyingVideoPlayerIsPlaying = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [self dismissModalViewControllerAnimated:YES];
}

// movie load state changed
-(void) moviePlayerLoadStateChanged:(NSNotification*) pNotification{
    NSLog(@"moviePlayerLoadStateChanged - notification = %@", pNotification);
    
    // unless state is unknown, start playback
    if([_mMoviePlayerController loadState] != MPMovieLoadStateUnknown){
        NSLog(@"movie player load state = %d", [_mMoviePlayerController loadState]);
        
        // remove loadStateChanged observer
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        
        // update loading tip
        _mLoadingTip.text = @"视频加载完成,马上播放.";
        
        // process video loading cancel toolbar, video player logoView, loadingView and tip
        [_mLoadingCancelToolbar removeFromSuperview];
        [_mLogoView removeFromSuperview];
        [_mLoadingView stopAnimating];
        [_mLoadingTip removeFromSuperview];
        // show moviePlayer view
        _mMoviePlayerController.view.hidden = NO;
        
        // play the movie
        [_mMoviePlayerController play];
    }
    else{
        //[self cancelLoadingView];
    }
}

// movie playback did finished
-(void) moviePlayerPlaybackDidFinished:(NSNotification*) pNotification{
    NSLog(@"moviePlayer playback did finished - notification = %@", pNotification);
    
    // get movie finished playback reason
    NSNumber *finishReason = [(NSDictionary*)pNotification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    //NSLog(@"movie play finished reason = %@", finishReason);
    
    // movie finish. Reason is user exit(MPMovieFinishReasonUserExited) or error(MPMovieFinishReasonPlaybackError)
    if(finishReason.intValue != MPMovieFinishReasonPlaybackEnded && _mIsPrepared){
        // movie finishReason just playback error
        if(finishReason.intValue == MPMovieFinishReasonPlaybackError){
            // remove loadStateChanged observer
            [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        }
        
        // remove moviePlaybackDidFinished observer
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        
        // back to previous view
        feiyingVideoPlayerRef = nil;
        feiyingVideoPlayerIsPlaying = NO;
        [self dismissModalViewControllerAnimated:YES];
    }
    else if(finishReason.intValue == MPMovieFinishReasonPlaybackEnded){
        // show playback control always
        NSLog(@"---------------------------show playback control always.");
    }
}

// mp movie player is ready to play
-(void) readyToPlay{
    NSLog(@"feiyingVideoPlayer is ready.");
    
    if(_mVideoUrl == nil){
        NSLog(@"nil movie url.");
        
        // back to previous view
        feiyingVideoPlayerRef = nil;
        feiyingVideoPlayerIsPlaying = NO;
        [self dismissModalViewControllerAnimated:YES];
        
        return;
    }
    
    // set moviePlayer content url
    _mMoviePlayerController.contentURL = _mVideoUrl;
    
    if(/*[_mMoviePlayerController respondsToSelector:@selector(loadState)]*/[[[UIDevice currentDevice] systemVersion] doubleValue] >= 3.2){
        // set moviePlayer control style
        [_mMoviePlayerController setControlStyle:MPMovieControlStyleFullscreen];
        // set fullScreen
        //[_mMoviePlayerController setFullscreen:YES animated:YES];
        // prepare to play
        [_mMoviePlayerController prepareToPlay];
        
        // register that the load state changed (movie is ready)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    }
    else{
        // play movie for 3.1.x devices
        NSLog(@"play movie for 3.1.x devices.");
        [_mMoviePlayerController play];
    }
    
    // register that the movie has finished playing notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    // set is prepared to play
    _mIsPrepared = YES;
}

// init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithVideoUrl:(NSString *)pVideoUrlStr{
    self = [super init];
    if(self){
        // Custom initialization   
        // set application statusBar orientation
        [[UIApplication sharedApplication] setStatusBarOrientation:self.interfaceOrientation];
        
        // set background color
        self.view.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:28.0/255.0 blue:28.0/255.0 alpha:1.0];
        
        // set view landscape frame
        [self.view setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)];
        
        // init subView and add to view
        // loading cancel toolbar
        _mLoadingCancelToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.frame.size.width, 44.0)];
        // set bar style
        _mLoadingCancelToolbar.barStyle = UIBarStyleBlackTranslucent;

        // create and init loading cancel barButtonItem
        UIBarButtonItem *_loadingCancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleDone target:self action:@selector(cancelLoadingView)];
        // set width
        _loadingCancelBarButtonItem.width = 48.0;
        
        // set loadingCancelToolbar items
        _mLoadingCancelToolbar.items = [NSArray arrayWithObjects:_loadingCancelBarButtonItem, nil];
        
        // video player logo view
        _mLogoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        // set frame
        _mLogoView.frame = CGRectMake(self.view.frame.size.width/2-20.0, self.view.frame.size.height/2-32.0-40.0, 40.0, 32.0);
        
        // loading activityIndicator animate
        _mLoadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        // set frame
        _mLoadingView.frame = CGRectMake(self.view.frame.size.width/2-15.0, self.view.frame.size.height/2-30.0+15.0, 30.0, 30.0);
        // start animateing
        [_mLoadingView startAnimating];
        
        // loading tip
        _mLoadingTip = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-80.0, self.view.frame.size.height/2+25.0, 160.0, 20.0)];
        // set text
        _mLoadingTip.text = @"视频加载中,请稍候...";
        _mLoadingTip.textColor = [UIColor whiteColor];
        _mLoadingTip.textAlignment = UITextAlignmentCenter;
        // set font
        _mLoadingTip.font = [UIFont systemFontOfSize:13.0];
        // set background color
        _mLoadingTip.backgroundColor = [UIColor clearColor];
        
        // moviePlayer view
        _mMoviePlayerController = [[MPMoviePlayerController alloc] init];
        // set bounds
        _mMoviePlayerController.view.bounds = self.view.bounds;
        // update movie player controller view center
        _mMoviePlayerController.view.center = CGPointMake(_mMoviePlayerController.view.center.x, _mMoviePlayerController.view.center.y-20.0);
        // hide first
        _mMoviePlayerController.view.hidden = YES;

        // add subView to view
        [self.view addSubview:_mLoadingCancelToolbar];
        [self.view addSubview:_mLogoView];
        [self.view addSubview:_mLoadingView];
        [self.view addSubview:_mLoadingTip];
        [self.view addSubview:_mMoviePlayerController.view];
        
        // set video passed url
        _mVideoPassedUrlStr = pVideoUrlStr;
        
        // set feiyingVideoPlayer reference
        feiyingVideoPlayerRef = self;
        
        // get network status
        NetworkStatus _netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
        
        // if user cann't open feiying business and user 3G network to watch video
        if ([[[UserManager shareSingleton]  userBean] businessState] == unopened && _netStatus == ReachableViaWWAN) {
            // show 3G watch video alert view
            [self show3GWatchVideoAlertView:watchBegin];
        }
        else {
            // set default video url
            _mVideoUrl = nil;
            // parse passed param video url string
            NSLog(@"video url string param = %@", pVideoUrlStr);
            if(pVideoUrlStr != nil && ![pVideoUrlStr isEqualToString:@""]){
                // step1: skip whiteSpace, newLine and tab
                pVideoUrlStr = [pVideoUrlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                if(![pVideoUrlStr hasPrefix:@"http://"] && ![pVideoUrlStr hasPrefix:@"https://"]){
                    pVideoUrlStr = [@"http://" stringByAppendingString:pVideoUrlStr];
                }
                
                // step2: get video url suffix and judge if or not a media type url
                if(pVideoUrlStr && ![pVideoUrlStr hasSuffix:@".mp4"]){
                    // send asynchronous request to fetch the real video url
                    NSLog(@"begin to fetch the real video url.");
                    _mFetchVideoUrlRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:pVideoUrlStr]];
                    // set request headers
                    [_mFetchVideoUrlRequest setRequestHeaders:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Mozilla/5.0 (iPhone Simulator; CPU iPhone OS 5_0 like Mac OS X)", @"User-Agent", nil]];
                    // set timeout seconds
                    [_mFetchVideoUrlRequest setTimeOutSeconds:5.0];
                    // set delegate
                    [_mFetchVideoUrlRequest setDelegate:self];
                    // set response methods
                    [_mFetchVideoUrlRequest setWillRedirectSelector:@selector(willRedirectFetchVideoUrl:)];
                    [_mFetchVideoUrlRequest setDidFinishSelector:@selector(didFinishedRequestFetchVideoUrl:)];
                    [_mFetchVideoUrlRequest setDidFailSelector:@selector(didFailedRequestFetchVideoUrl:)];
                    // start send asynchronous request
                    [_mFetchVideoUrlRequest startAsynchronous];
                }
                else{
                    _mVideoUrl = [NSURL URLWithString:pVideoUrlStr];
                    
                    // set video url is prepared
                    _mUrlIsPrepared = YES;
                }
            }
            NSLog(@"video play url = %@ and url is prepared = %d", _mVideoUrl, _mUrlIsPrepared);
        }
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
	//return YES;
    
    // update movie player controller view frame
    //_mMoviePlayerController.view.frame = self.view.bounds;
    
    // judge application status bar
    if ([UIApplication sharedApplication].statusBarHidden) {
        // hidden
        // update movie player controller view frame
        _mMoviePlayerController.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    else {
        // shown
        // update movie player controller view frame
        _mMoviePlayerController.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y-20.0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

// ASIHTTPRequestDelegate methods implemetation
-(void) willRedirectFetchVideoUrl:(ASIHTTPRequest*) pRequest{
    NSLog(@"willRedirectFetchVideoUrl - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // get request redirect location
    NSString *_location = [pRequest.responseHeaders objectForKey:@"Location"];
    
    // judge request response status code and location
    if([pRequest responseStatusCode] == 302 && [_location hasSuffix:@".mp4"]){
        //NSLog(@"request response headers = %@", pRequest.responseHeaders);
        
        // update video url
        _mVideoUrl = [NSURL URLWithString:_location];
        NSLog(@"location = %@", _location);
        
        // update mUrlIsPrepared and ready to play
        _mUrlIsPrepared = YES;
        [self readyToPlay];
        
        // request redirect to special url
        [pRequest redirectToURL:SPECIALURL];
    }
    else {
        // request redirect to locaton
        [pRequest redirectToURL:[NSURL URLWithString:_location]];
    }
}

-(void) didFinishedRequestFetchVideoUrl:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestFetchVideoUrl - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // judge request response status code and url
    if([pRequest responseStatusCode] == 200 && ![pRequest.url isEqual:SPECIALURL]){
        // update video url
        _mVideoUrl = pRequest.url;
        
        // update mUrlIsPrepared and ready to play
        _mUrlIsPrepared = YES;
        [self readyToPlay];
    }
}

-(void) didFailedRequestFetchVideoUrl:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestFetchVideoUrl - request url = %@, error: %@", pRequest.url, _error);
    
    // update mUrlIsPrepared and ready to play
    _mUrlIsPrepared = YES;
    [self readyToPlay];
}

// UIAlertViewDelegate methods implemetation
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"3gWatchVideoAlertView - clickedButtonAtIndex - alertView type = %d and buttonIndex = %d", alertView.tag, buttonIndex);
    
    // judge alert view type and selected button index
    switch (buttonIndex) {
        case 0:
            // cancel loading view
            [self cancelLoadingView];
            break;
            
        case 1:
            // continue watching video
            {
                // judge alertView type
                if (alertView.tag == watching) {
                    // video play again
                    [_mMoviePlayerController play];
                    
                    // return immediately
                    return;
                }
                
                // set default video url
                _mVideoUrl = nil;
                // parse passed param video url string
                NSLog(@"video url string param = %@", _mVideoPassedUrlStr);
                if(_mVideoPassedUrlStr != nil && ![_mVideoPassedUrlStr isEqualToString:@""]){
                    // step1: skip whiteSpace, newLine and tab
                    _mVideoPassedUrlStr = [_mVideoPassedUrlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if(![_mVideoPassedUrlStr hasPrefix:@"http://"] && ![_mVideoPassedUrlStr hasPrefix:@"https://"]){
                        _mVideoPassedUrlStr = [@"http://" stringByAppendingString:_mVideoPassedUrlStr];
                    }
                    
                    // step2: get video url suffix and judge if or not a media type url
                    if(_mVideoPassedUrlStr && ![_mVideoPassedUrlStr hasSuffix:@".mp4"]){
                        // send asynchronous request to fetch the real video url
                        NSLog(@"begin to fetch the real video url.");
                        _mFetchVideoUrlRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_mVideoPassedUrlStr]];
                        // set request headers
                        [_mFetchVideoUrlRequest setRequestHeaders:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Mozilla/5.0 (iPhone Simulator; CPU iPhone OS 5_0 like Mac OS X)", @"User-Agent", nil]];
                        // set timeout seconds
                        [_mFetchVideoUrlRequest setTimeOutSeconds:5.0];
                        // set delegate
                        [_mFetchVideoUrlRequest setDelegate:self];
                        // set response methods
                        [_mFetchVideoUrlRequest setWillRedirectSelector:@selector(willRedirectFetchVideoUrl:)];
                        [_mFetchVideoUrlRequest setDidFinishSelector:@selector(didFinishedRequestFetchVideoUrl:)];
                        [_mFetchVideoUrlRequest setDidFailSelector:@selector(didFailedRequestFetchVideoUrl:)];
                        // start send asynchronous request
                        [_mFetchVideoUrlRequest startAsynchronous];
                    }
                    else{
                        _mVideoUrl = [NSURL URLWithString:_mVideoPassedUrlStr];
                        
                        // set video url is prepared
                        _mUrlIsPrepared = YES;
                    }
                }
                NSLog(@"video play url = %@ and url is prepared = %d", _mVideoUrl, _mUrlIsPrepared);
            }
            break;
    }
}

// feiyingVideoPlayerViewController methods implematation
// get feiyingVideoPlayer reference
+(feiyingVideoPlayerViewController*) getFeiyingVideoPlayerRef{
    return feiyingVideoPlayerRef;
}

// check video is playing currently
+(BOOL) videoIsPlaying{
    return feiyingVideoPlayerIsPlaying;
}

// feiyingVideoPlayer begin to play
-(void) beginToPlay{
    NSLog(@"feiyingVideoPlayer begin to play.");
    
    // update feiyingVideoPlayer video playing flag
    feiyingVideoPlayerIsPlaying = YES;
    
    // judge if video url is prepared
    if(_mUrlIsPrepared){
        // movie player play
        [self readyToPlay];
    }
}

-(void) show3GWatchVideoAlertView:(threeGWatchVideoAlertViewType) pType{
    // when watching, pause video first
    if (pType == watching) {
        [_mMoviePlayerController pause];
    }
    
    // create and int 3GWatchVideoAlertView
    UIAlertView *_3GWatchVideoAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您目前处于3G网络, 继续观看会产生3G流量,流量费将由当地运营商收取" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"继续观看", nil];
    // set 3GWatchVideoAlertView type
    _3GWatchVideoAlertView.tag = pType;
    // show alert view
    [_3GWatchVideoAlertView show];
}

@end
