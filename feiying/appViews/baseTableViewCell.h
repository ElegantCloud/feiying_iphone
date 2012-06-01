//
//  baseTableViewCell.h
//  feiying
//
//  Created by  on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface baseTableViewCell : UITableViewCell

// get tableViewCell height with contents
+(CGFloat) getCellHeightWithContents:(NSMutableDictionary *) pContents;

@end
