//
//  channelTableViewCell.h
//  feiying
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "baseTableViewCell.h"

@interface channelTableViewCell : baseTableViewCell

// init with channel item
-(id) initWithChannelTitle:(NSString*) pChannelTitle andImage:(UIImage*) pChannelImage;

@end
