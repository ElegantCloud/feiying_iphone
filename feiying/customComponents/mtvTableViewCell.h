//
//  mtvTableViewCell.h
//  feiying
//
//  Created by  on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "baseTableViewCell.h"

@interface movieTVTableViewCell : baseTableViewCell

// init with movie/teleplay image, title, total time(movie), episode count(teleplay), actors, origin locate and release date
-(id) initWithTitle:(NSString*) pTitle andImage:(UIImage*) pImage andTotalTime:(NSString*) pTotalTime andEpisodeCountState:(NSString*) pEpisodeCountState andActors:(NSString*) pActors andOriginLocate:(NSString*) pOriginLocate andReleaseDate:(NSString*) pReleasedate;

@end
