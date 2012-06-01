//
//  NSString+md5.h
//  feiying
//
//  Created by  on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AddressBookUI/AddressBookUI.h>

@interface NSString (util)

// string md5
-(NSString*) md5;

// trim punctuation character
-(NSString*) trimPunctuationCharacter;

// trim whitespace and new line character
-(NSString*) trimWhitespaceAndNewlineCharacter;

// get phone number array
-(NSArray*) getPhoneNumberArray;

// get video shared note
-(NSString*) getVideoSharedNote;

// get video shared persons in address book
-(NSString*) getVideoSharedPersonsInAddressBook;

// 获取字符在字符串第一次出现的位置
- (NSInteger)firstIndexOfChar:(unichar)ch;
// 获取字符在字符串最后一次出现的位置
- (NSInteger)lastIndexOfChar:(unichar)ch;
// 获取字符在字符串第N次出现的位置, the appear count starts with 1.
- (NSInteger)firstIndexOfChar:(unichar)ch withAppearCount:(NSInteger)count;

// 根据字符串的字体大小获取字符串的像素长度
- (CGFloat)getStrPixelLenByFontSize:(CGFloat)fontSize;
// 根据字符串的字体大小获取字符串的像素高度
- (CGFloat)getStrPixelHeightByFontSize:(CGFloat)fontSize;
// 获得字符串的段落数组
-(NSArray*)getStrParagraphArray;

// get internal video url
-(NSString*) getInternalVideoUrl;
// get external video url
-(NSString*) getExternalVideoUrl;

@end
