//
//  LKWatermarkModel.m
//  TZImagePickTest
//
//  Created by 张军 on 2021/4/8.
//

#import "LKWatermarkModel.h"

@implementation LKWatermarkModel


-(instancetype)init{
    if (self =[super init]) {
    }
    return self;
}

-(UIColor *)color{
    if (!_color) {
        _color = [UIColor redColor];
    }
    return _color;
}


-(UIFont *)font{
    if (!_font) {
        _font = [UIFont boldSystemFontOfSize:25];
    }
    return _font;
}


-(NSString *)title{
    if (!_title) {
        _title = @"LK";
    }
    return _title;
}

-(NSString *)dateForMatter{
    if (!_dateForMatter) {
        _dateForMatter = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateForMatter;;
}


-(LKWatermarkModelType)watermarkModelType{
    if (!_watermarkModelType) {
        _watermarkModelType = LKWatermarkModelTypeBottomLeft;
    }
    return _watermarkModelType;
}

-(LKWatermarkType)watermarkType{
    if (!_watermarkType) {
        _watermarkType = LKWatermarkTypeNone;
    }
    return _watermarkType;
}

@end
