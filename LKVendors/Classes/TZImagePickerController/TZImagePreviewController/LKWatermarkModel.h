//
//  LKWatermarkModel.h
//  TZImagePickTest
//
//  Created by 张军 on 2021/4/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LKWatermarkModelType) {
    LKWatermarkModelTypeTopLeft = 1,//左上
    LKWatermarkModelTypeTopRight,//右上
    LKWatermarkModelTypeBottomLeft,//左下。 默认
    LKWatermarkModelTypeBottomRight,//右下
};

typedef NS_ENUM(NSInteger, LKWatermarkType) {
    LKWatermarkTypeNone = 0,//不展示
    LKWatermarkTypeTime = 1,//时间戳
    LKWatermarkTypeImage,//图片
    LKWatermarkTypeTitle,//自定义文字
};


NS_ASSUME_NONNULL_BEGIN

@interface LKWatermarkModel : NSObject

//添加水印文字
@property(copy, nonatomic) NSString *title;
//水印相应位置默认为左下
@property(assign, nonatomic) LKWatermarkModelType watermarkModelType;
//水印类型
@property(assign, nonatomic) LKWatermarkType watermarkType;

//水印是否当前是时间戳 选择了时间戳添加文字水印将会无效
@property(assign, nonatomic) BOOL isWaterTime;

//水印文字的色值
@property(strong, nonatomic) UIColor *color;
//水印文字的大小
@property(strong, nonatomic) UIFont *font;

//水印图片。水印图片的优先级最大 当有图片是不在添加文字和时间戳
@property(strong, nonatomic) UIImage *markImage;

//时间戳格式
@property(copy, nonatomic) NSString *dateForMatter;

@end

NS_ASSUME_NONNULL_END
