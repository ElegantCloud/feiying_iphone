//
//  UIImage+util.m
//  feiying
//
//  Created by  on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+util.h"

@implementation UIImage (util)

// returns the scaled image 
- (UIImage *)scale:(float)scaleSize {
    UIGraphicsBeginImageContext( 
                                CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize)); 
    [self drawInRect:CGRectMake(0, 0, self.size.width * scaleSize, self.size.height * scaleSize)]; 
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext(); 
    
    return scaledImage; 
} 


// resize the img to indicated newSize 
- (UIImage *)resizeImage:(CGSize)newSize { 
    UIGraphicsBeginImageContext(CGSizeMake(newSize.width, newSize.height)); 
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)]; 
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext(); 
    
    return resizeImage; 
} 

// get part of the image 
- (UIImage *)getPartOfImage:(CGRect)partRect { 
    CGImageRef imageRef = self.CGImage; 
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, partRect); 
    
    return [UIImage imageWithCGImage:imagePartRef]; 
}

@end
