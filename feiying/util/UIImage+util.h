//
//  UIImage+util.h
//  feiying
//
//  Created by  on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (util)

// returns the scaled image 
- (UIImage *)scale:(float)scaleSize;

// resize the img to indicated newSize 
- (UIImage *)resizeImage:(CGSize)newSize;

// get part of the image 
- (UIImage *)getPartOfImage:(CGRect)partRect;

@end
