//
//  shareTypeToolBar.h
//  feiying
//
//  Created by  on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol shareTypeToolBarDelegate <NSObject>

-(void) barItemChanged:(UIButton*) pBarButton;

@end

@interface shareTypeToolBar : UIToolbar{
    // selected item index
    NSInteger _mSelectedItemIndex;
    
    // shareTypeToolBar delegate
    id<shareTypeToolBarDelegate> _shareTypeToolBarDelegate;
}

@property (nonatomic, readwrite) NSInteger selectedItemIndex;

@property (nonatomic, retain) id<shareTypeToolBarDelegate> shareTypeToolBarDelegate;

// set shareTypeToolBar button items
-(void) setBarButtonItems:(NSArray*) pItems;

// bar button item been selected
-(void) barButtonItemBeenSelected:(UIButton*) pBarButton;

@end
