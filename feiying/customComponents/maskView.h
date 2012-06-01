//
//  maskView.h
//  feiying
//
//  Created by  on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class maskView;

@protocol maskViewDelegate <NSObject>

-(void) touchInside:(maskView*) pMaskView;

@end

@interface maskView : UIView{
    // mask view delegate
    id<maskViewDelegate> _maskViewDelegate;
}

@property (nonatomic, retain) id<maskViewDelegate> maskViewDelegate;

@end
