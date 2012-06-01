//
//  episodeListView.h
//  feiying
//
//  Created by  on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface episodeListView : UIView{
    // table data source
    NSArray *_mDataSource;
}

// init with episode list
-(id) initWithEpisodeList:(NSArray*) pEpisodeList;

@end
