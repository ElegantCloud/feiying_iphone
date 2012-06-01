//
//  commonUtil.m
//  feiying
//
//  Created by  on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "commonUtil.h"

#import "NSString+util.h"

@implementation commonUtil

// get contact's full name according to ABRecordRef
+(NSString *)getFullNameByRecord:(ABRecordRef)record{
    // set default return string
    NSString *_ret = [[NSString alloc] init];
    
    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
    NSString *midName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonMiddleNameProperty);
    NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
    
    if(firstName == nil){
        firstName = @"";
    }
    if(midName == nil){
        midName = @"";
    }
    if(lastName == nil){
        lastName = @"";
    }
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *langName = [languages objectAtIndex:0];
    
    // donn't need to use MiddleName
    if([langName isEqualToString:@"en"]){
        _ret = [NSString stringWithFormat:@"%@ %@", firstName, lastName]; 
    }
    else if([langName isEqualToString:@"zh-Hans"]){
        _ret = [NSString stringWithFormat:@"%@%@", lastName, firstName];
    }
    else{
        _ret = [NSString stringWithFormat:@"%@%@%@", firstName, midName, lastName];
    }
    
    // check the return string
    if ([[_ret trimWhitespaceAndNewlineCharacter] isEqualToString:@""]) {
        _ret = @"未命名";
    }
    
    return _ret;
}

// get phone numbers array
+(NSMutableArray *)getPhoneNumberArray:(ABRecordRef)record{
    // get phones array
    ABMultiValueRef tempArr = (ABMultiValueRef)ABRecordCopyValue(record, kABPersonPhoneProperty);
    
    if(!tempArr){
        return nil;
    }
    
    NSMutableArray *phoneArr  = [NSMutableArray new];
    for(int i = 0; i < ABMultiValueGetCount(tempArr); ++i){
        NSString *phoneNo = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(tempArr, i); 
        
        // add each phone to phones array
        [phoneArr addObject:[phoneNo trimPunctuationCharacter]];
    }
    
    CFRelease(tempArr);
    
    return phoneArr;
}

// get all contacts in addressBook
+(NSArray*) getAllContactsInAddressBook{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // Fetch the address book, addressBook manager object 
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    // get all contacts
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for(int index = 0; index < CFArrayGetCount(results); index++){
        NSMutableDictionary *_dic = [[NSMutableDictionary alloc] init];
        
        // get person object
        ABRecordRef _person = CFArrayGetValueAtIndex(results, index);
        
        // get person info
        // id
        ABRecordID _recordID = ABRecordGetRecordID(_person);
        // full name
        NSString *_fullName = [self getFullNameByRecord:_person];
        // phone number array
        NSArray *_phoneNumbers = [self getPhoneNumberArray:_person];
        // photo
        NSData* _photo = (__bridge NSData*)ABPersonCopyImageData(_person);
        
        [_dic setObject:[NSNumber numberWithInt:_recordID] forKey:@"id"];
        [_dic setObject:_fullName forKey:@"name"];
        if(_phoneNumbers){
            [_dic setObject:_phoneNumbers forKey:@"phones"];
        }
        if(_photo){
            [_dic setObject:_photo forKey:@"photo"];
        }
        
        // add person dic in array
        [_ret addObject:_dic];
    }
    
    // release
    CFRelease(addressBook);
    
    return _ret;
}

// get all contacts phone name dictionary
+(NSDictionary*) getAllContactsPhoneNameDictionary{
    NSMutableDictionary *_ret = [[NSMutableDictionary alloc] init];
    
    // Fetch the address book, addressBook manager object 
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    // get all contacts
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for(int index = 0; index < CFArrayGetCount(results); index++){
        // get person object
        ABRecordRef _person = CFArrayGetValueAtIndex(results, index);
        
        // get person info
        // full name
        NSString *_fullName = [self getFullNameByRecord:_person];
        // phone number array
        NSArray *_phoneNumbers = [self getPhoneNumberArray:_person];
        
        // set dictionary
        for(NSString *_string in _phoneNumbers){
            [_ret setObject:_fullName forKey:_string];
        }
    }
    
    // release
    CFRelease(addressBook);
    
    return _ret;
}

@end
