//
//  commonUtil.h
//  feiying
//
//  Created by  on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AddressBook/AddressBook.h>

@interface commonUtil : NSObject

// get contact's full name according to ABRecordRef
+(NSString *)getFullNameByRecord:(ABRecordRef)record;
// get phone numbers array
+(NSMutableArray *)getPhoneNumberArray:(ABRecordRef)record;

// get all contacts in addressBook
+(NSArray*) getAllContactsInAddressBook;

// get all contacts phone name dictionary
+(NSDictionary*) getAllContactsPhoneNameDictionary;

@end
