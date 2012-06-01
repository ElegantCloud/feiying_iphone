//
//  searchShareImgView.m
//  feiying
//
//  Created by  on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "searchShareImgView.h"

#import "../util/UIImage+util.h"

@implementation searchShareImgView

// methods implemetation
// set suitable image
-(void) setSuitableImage:(UIImage*) pImg{
    // scale and cut out image
    if(pImg.size.height>pImg.size.width){
        pImg = [pImg scale:self.frame.size.width/pImg.size.width];
        pImg = [pImg getPartOfImage:CGRectMake(0.0, (pImg.size.height-self.frame.size.height)/2, self.frame.size.width, self.frame.size.height)];
    }
    
    // set image
    self.image = pImg;
}

@end
