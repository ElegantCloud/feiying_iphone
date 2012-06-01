//
//  urlConstant.h
//  feiying
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface urlConstant : NSObject

// static methods
// video url
+(NSString*) videoUrl;
// video image url
+(NSString*) videoImgUrl;

// login url
+(NSString*) loginUrl;

// get register validate code url
+(NSString*) getValidateCodeUrl;
// check validate code url
+(NSString*) getCheckValidateUrl;
// register user url
+(NSString*) regUserUrl;
// user register and login url
+(NSString*) userRegLoginUrl;

// video home page url
+(NSString*) homePageUrl;

// common channel page url
+(NSString*) commonChannelPageUrl;
// common video detail infomation page url
+(NSString*) commonvVideoDetailInfoPageUrl;

// fav channel list
+(NSString*) favChannelListUrl;
// common fav channel page url
+(NSString*) commonFavChannelPageUrl;
// add or delete fav video indicator url
+(NSString*) videoFavIndicatorUrl;

// send share video url
+(NSString*) sendShareUrl;
// delete sended share video url
+(NSString*) deleteSendedShareUrl;
// sended share video list url
+(NSString*) sendedShareListUrl;
// sended share video's receivers url
+(NSString*) sendedShareReceiversUrl;
// received share video list url
+(NSString*) receivedShareListUrl;
// delete received share video url
+(NSString*) deleteReceivedShareUrl;

// add play count url
+(NSString*) addVideoPlayCountUrl;

// authenticate url
+(NSString*) authenticateUrl;

// video search url
+(NSString*) videoSearchUrl;

// video web play address
+(NSString*) videoWebPlayAddr;

// get search hot keywords url
+(NSString*) hotKeywordsUrl;

// feedback submit url
+(NSString*) feedbackSubmitUrl;

@end
