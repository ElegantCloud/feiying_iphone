//
//  shareListViewController.h
//  feiying
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "commonTableViewController.h"

typedef enum {
    Sended,
    Received
} ShareListViewType;

@interface shareListViewController : commonTableViewController{
    // share list view type
    ShareListViewType _mShareListViewType;
    
    // fetch data request url
    NSString* _mFetchDataUrl;
    
    // table data source refresh flag
    BOOL _mIsTableDSRefresh;
    // table data source had inited flag
    BOOL _mTableDSHadInited;
    
    // its tab view controller
    baseTabViewController *_mParentTabViewController;
}

@property (nonatomic, readwrite) BOOL isTableDSRefresh;

@property (nonatomic, readwrite) ShareListViewType shareListViewType;
@property (nonatomic, retain) baseTabViewController *parentTabViewController;

// init with video share type and fetch data url
-(id) initWithShareType:(ShareListViewType) pShareListViewType andFetchDataUrl:(NSString*) pUrl;

// init or refresh table data source
-(void) initOrRefreshTableDataSource;

@end
