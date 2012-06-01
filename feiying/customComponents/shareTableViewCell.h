//
//  shareTableViewCell.h
//  feiying
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "baseTableViewCell.h"

@interface shareTableViewCell : baseTableViewCell

// init with video image, title, share time, send to or receive from
-(id) initWithTitle:(NSString*) pTitle andImage:(UIImage*) pImage andShareTime:(NSString*) pShareTime andSendTo:(NSString*) pSendTo andReceiveFrom:(NSString*) pReceiveFrom;

@end
