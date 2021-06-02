//
//  TZImagePickerController+LKWatermark.h
//  TZImagePickTest
//
//  Created by 张军 on 2021/4/30.
//

#import "TZImagePickerController.h"
#import "LKWatermarkModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface TZImagePickerController (LKWatermark)
/// 添加属性方法 用于配置水印相关信息
@property(strong, nonatomic) LKWatermarkModel *watermark;

//创建图片的选择器:(图片 + GIF)
-(instancetype)initImageWithDelegate:(id<TZImagePickerControllerDelegate>)delegate andWatermarkType:(LKWatermarkType)watermarkType;


//创建包含视频的选择器: (图片 + GIF + Video)
-(instancetype)initVideoWithDelegate:(id<TZImagePickerControllerDelegate>)delegate andWatermarkType:(LKWatermarkType)watermarkType;
@end

NS_ASSUME_NONNULL_END
