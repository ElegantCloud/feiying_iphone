//
//  NSString+md5.m
//  feiying
//
//  Created by  on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+util.h"
#import "commonUtil.h"
#import "AppDelegate.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (util)

// string md5
-(NSString*) md5{
    const char *cCharString = [self UTF8String];
    unsigned char result[16];
    
    CC_MD5(cCharString, strlen(cCharString), result);
    
    NSString *ret = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
    
    //NSLog(@"orig string: %@ and md5 = %@", ret, [ret uppercaseString]);
    
    return [ret uppercaseString];
}

// trim punctuation character
-(NSString*) trimPunctuationCharacter{
    NSMutableString *_ret = [[NSMutableString alloc] init];
    
    NSArray *_separatedArray = [self componentsSeparatedByCharactersInSet:[NSCharacterSet /*punctuationCharacterSet*/characterSetWithCharactersInString:@"()- "]];
    
    for(NSString *_string in _separatedArray){
        [_ret appendString:_string];
    }
    
    return _ret;
}

// trim whitespace and new line character
-(NSString*) trimWhitespaceAndNewlineCharacter{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// get phone number array
-(NSArray*) getPhoneNumberArray{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    NSArray *_separatedArray = [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",，"]];
    
    for(NSString *_string in _separatedArray){
        // slip nil phone number
        if([[_string trimWhitespaceAndNewlineCharacter] isEqualToString:@""]){
            continue;
        }
        
        NSRange _range = [_string rangeOfString:@")"];
        if(_range.length==0){
            [_ret addObject:_string];
        }
        else{
            [_ret addObject:[_string substringFromIndex:(_range.location+1)]];
        }
    }
    
    return _ret;
}

// get video shared note
-(NSString*) getVideoSharedNote{
    NSString *_ret = nil;
    
    NSString *_findTag = @"留言: ";
    NSRange _range = [self rangeOfString:_findTag];
    if(_range.length!=0){
        _ret = [self substringFromIndex:(_range.location+[_findTag length])];
    }
    
    return _ret;
}

// get video shared persons in address book
-(NSString*) getVideoSharedPersonsInAddressBook{
    NSMutableString *_ret = [[NSMutableString alloc] init];
    
    // get getAllContactsInAddressBook
    if(!gPhoneNameDic){
        gPhoneNameDic = [NSMutableDictionary dictionaryWithDictionary:[commonUtil getAllContactsPhoneNameDictionary]];
    }
    
    NSArray *_separatedArray = [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    for(NSString *_string in _separatedArray){
        NSString *_replaceString = _string;
        
        // method 1
        /*
        for(NSDictionary *_object in [commonUtil getAllContactsInAddressBook]){
            if ([(NSArray*)[_object objectForKey:@"phones"] containsObject:_string]) {
                // set replace string
                _replaceString = [_object objectForKey:@"name"];
                
                break;
            }
        }
         */
        
        // methods 2
        if([gPhoneNameDic.allKeys containsObject:_string]){
            // set replace string
            _replaceString = [gPhoneNameDic objectForKey:_string];
        }
        
        // append string
        [_ret appendFormat:@"%@ ", _replaceString];
    }
    
    return  _ret;
}

// 获取字符在字符串第一次出现的位置
- (NSInteger)firstIndexOfChar:(unichar)ch
{
    return [self firstIndexOfChar:ch withAppearCount:1];
}

// 获取字符在字符串最后一次出现的位置
- (NSInteger)lastIndexOfChar:(unichar)ch
{
    for(NSInteger i = self.length - 1; i >= 0; i--)
    {
        if(ch == [self characterAtIndex:i])
        {
            return i;
        }
    }
    
    return -1;              // 没找到
}


// 获取字符在字符串第N次出现的位置
- (NSInteger)firstIndexOfChar:(unichar)ch withAppearCount:(NSInteger)count
{
    NSInteger appearCount = 0;
    
    for(NSInteger i = 0; i < self.length; i++)
    {
        if(ch == [self characterAtIndex:i])
        {
            appearCount++;
            if(appearCount == count)
            {
                return i;
            }
        }
    }
    
    return -1;              // 没找到
}

// 根据字符串的字体大小获取字符串的像素长度
- (CGFloat)getStrPixelLenByFontSize:(CGFloat)fontSize
{
    CGSize size = [self sizeWithFont:[UIFont systemFontOfSize:fontSize]];
    return size.width;
}

// 根据字符串的字体大小获取字符串的像素高度
- (CGFloat)getStrPixelHeightByFontSize:(CGFloat)fontSize
{
    CGSize size = [self sizeWithFont:[UIFont systemFontOfSize:fontSize]];
    return size.height;
}

// 获得字符串的段落数组
-(NSArray*)getStrParagraphArray
{
    // string paragraph array
    NSArray *_paragraphArray = [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    //NSLog(@"paragraph array = %@ and count = %d", _paragraphArray, [_paragraphArray count]);
    
    return _paragraphArray;
}

// get internal video url
-(NSString*) getInternalVideoUrl{
    NSString *_ret = self;
    
    NSString *_findTag = @"||";
    NSRange _range = [self rangeOfString:_findTag];
    if(_range.length!=0){
        _ret = [self substringToIndex:(_range.location)];
    }
    
    return _ret;
}

// get external video url
-(NSString*) getExternalVideoUrl{
    NSString *_ret = self;
    
    NSString *_findTag = @"||";
    NSRange _range = [self rangeOfString:_findTag];
    if(_range.length!=0){
        _ret = [self substringFromIndex:(_range.location+[_findTag length])];
    }
    
    return _ret;
}

@end
