//
//  PinYinForObjc.m
//  Search
//
//  Created by LYZ on 14-1-24.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import "PinYinForObjc.h"

@implementation PinYinForObjc

+ (NSString*)chineseConvertToPinYin:(NSString*)chinese {
    NSString *sourceText = chinese;
    HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSString *outputPinyin = [PinyinHelper toHanyuPinyinStringWithNSString:sourceText withHanyuPinyinOutputFormat:outputFormat withNSString:@""];

    /**<适配多音字!!!*/
    if ([[sourceText substringToIndex:1] isEqualToString:@"单"]) { // dan -> shan
        outputPinyin = [NSString stringWithFormat:@"shan%@",[outputPinyin substringFromIndex:3]];
    }
    if([[sourceText substringToIndex:1] isEqualToString:@"仇"]){ // chou -> qiu
        outputPinyin = [NSString stringWithFormat:@"qiu%@",[outputPinyin substringFromIndex:4]];
    }
    
    return outputPinyin;
    
    
}

+ (NSString*)chineseConvertToPinYinHead:(NSString *)chinese {
    
    HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSMutableString *outputPinyin = [[NSMutableString alloc] init];
    for (int i=0;i <chinese.length;i++) {
        NSString *mainPinyinStrOfChar = [PinyinHelper getFirstHanyuPinyinStringWithChar:[chinese characterAtIndex:i] withHanyuPinyinOutputFormat:outputFormat];
        if (nil!=mainPinyinStrOfChar) {
            [outputPinyin appendString:[mainPinyinStrOfChar substringToIndex:1]];
        } else {
            break;
        }
    }
    
    /**<适配多音字!!!*/
    if ([[chinese substringToIndex:1] isEqualToString:@"单"]) {
        outputPinyin = [NSMutableString stringWithFormat:@"s%@",[outputPinyin substringFromIndex:1]];
    }
    
    if([[chinese substringToIndex:1] isEqualToString:@"仇"]){
        outputPinyin = [NSMutableString stringWithFormat:@"q%@",[outputPinyin substringFromIndex:1]];
    }
    
    return outputPinyin;
}
@end
