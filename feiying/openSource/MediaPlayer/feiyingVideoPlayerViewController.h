//
//  feiyingVideoPlayerViewController.h
//  sampleVideoPlayer
//
//  Created by  on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "../ASIHTTPRequest/ASIHTTPRequest.h"

typedef enum{
    watchBegin,
    watching
} threeGWatchVideoAlertViewType;

@interface feiyingVideoPlayerViewController : UIViewController <ASIHTTPRequestDelegate, UIAlertViewDelegate>{
    // video passed url string
    NSString *_mVideoPassedUrlStr;
    // video url
    NSURL *_mVideoUrl;
    
    // moviePlayer controller
    MPMoviePlayerController *_mMoviePlayerController;
    
    // loading cancel toolbar
    UIToolbar *_mLoadingCancelToolbar;
    // video player logo view
    UIImageView *_mLogoView;
    // loading activityIndicator animate
    UIActivityIndicatorView *_mLoadingView;
    // loading tip
    UILabel *_mLoadingTip;
    
    // is prepared to play
    BOOL _mIsPrepared;
    
    // video url is done fetched
    BOOL _mUrlIsPrepared;
    // fetch video url request
    ASIHTTPRequest *_mFetchVideoUrlRequest;
}

// get feiyingVideoPlayer reference
+(feiyingVideoPlayerViewController*) getFeiyingVideoPlayerRef;

// check video is playing currently
+(BOOL) videoIsPlaying;

// feiyingVideoPlayer init with video url
-(id) initWithVideoUrl:(NSString *) pVideoUrlStr;

// feiyingVideoPlayer begin to play
-(void) beginToPlay;

// show 3G watch video alert view with 3GWatchVideoAlertView type
-(void) show3GWatchVideoAlertView:(threeGWatchVideoAlertViewType) pType;

@end
