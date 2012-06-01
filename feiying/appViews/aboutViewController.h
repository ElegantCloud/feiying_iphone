//
//  aboutViewController.h
//  feiying
//
//  Created by  on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "baseTableViewCell.h"

@interface aboutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    // about string
    NSString *_mAboutSectionString;
    // number of rows of about section
    NSInteger _mAboutSectionRows;
}

@end

@interface versionSectionTableViewCell : baseTableViewCell

// init with logoImg, version info and copyright
-(id) initWithLogoImg:(UIImage*) pLogoImg andVersionInfo:(NSString*) pVersionInfo andCopyright:(NSString*) pCopyright;

@end
