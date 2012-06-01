//
//  mtvDetailTableViewCell.h
//  feiying
//
//  Created by  on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "videoDetailTableViewCell.h"

#import "../customComponents/episodeListTableView.h"

@interface movieTVDetailTableViewCell : videoDetailTableViewCell<episodeListDelegate>

// init with movie/teleplay image, title, originLocate, releaseDate, director, actors, total time(movie), episode count(teleplay), play count, share count, fav count, description
-(id) initWithTitle:(NSString*) pTitle andImage:(UIImage*) pImage andOriginLocate:(NSString*) pOriginLocate andReleaseDate:(NSString*) pReleaseDate andDirector:(NSString*) pDirector andActors:(NSString*) pActors andTotalTime:(NSString*) pTotalTime andEpisodeCountState:(NSString*) pEpisodeCountState andPlaycount:(NSString*) pPlaycount andSharecount:(NSString*) pSharecount andFavcount:(NSString*) pFavcount andDescription:(NSString*) pDescription andEpisodeList:(NSArray*) pEpisodeList andDeleteFavFlag:(BOOL) pDeleteFav andDeleteShareFlag:(BOOL) pDeleteShare andShareInfo:(NSDictionary*) pShareInfo;

// play the series episode action
-(void) playSeriesEpisodeAction:(NSString*) pEpisodeUrl;

@end
