//
//  TZPhotoPickerController+addWarter.m
//  TZImagePickTest
//
//  Created by 张军 on 2021/4/8.
//

#import "TZPhotoPickerController+LKWatermark.h"
#import <objc/runtime.h>
#import "TZImagePickerController+LKWatermark.h"
#import "LKWatermarkModel.h"

#define space 20
@implementation TZPhotoPickerController (LKWatermark)
/// 重写TZImage的图片编辑页面方法 ，在这个方法里面给返回的image添加水印
- (void)callDelegateMethodWithPhotos:(NSArray *)photos assets:(NSArray *)assets infoArr:(NSArray *)infoArr {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    BOOL isSelectOriginalPhoto = tzImagePickerVc.isSelectOriginalPhoto;
    if (tzImagePickerVc.allowPickingVideo && tzImagePickerVc.maxImagesCount == 1) {
        if ([[TZImageManager manager] isVideo:[assets firstObject]]) {
            if ([tzImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingVideo:sourceAssets:)]) {
                [tzImagePickerVc.pickerDelegate imagePickerController:tzImagePickerVc didFinishPickingVideo:[photos firstObject] sourceAssets:[assets firstObject]];
            }
            if (tzImagePickerVc.didFinishPickingVideoHandle) {
                tzImagePickerVc.didFinishPickingVideoHandle([photos firstObject], [assets firstObject]);
            }
            return;
        }
    }
    
    LKWatermarkModel *watermark = tzImagePickerVc.watermark;
    //判断水印是否添加
    if (watermark.watermarkType != LKWatermarkTypeNone) {
        NSMutableArray *photosarray = [NSMutableArray new];
        for (int i = 0; i<photos.count; i++) {
            PHAsset *asset = assets[i];
            //只对图片添加时水印
            if (asset.mediaType == PHAssetMediaTypeImage) {
                if (@available(iOS 11, *)) {
                    if (asset.playbackStyle == PHAssetPlaybackStyleImageAnimated) {
                        [photosarray addObject:photos[i]];
                    }else{
                        [photosarray addObject:[self watermarkImage:photos[i] withWaterModel:watermark]];
                    }
                } else {
                    [photosarray addObject:[self watermarkImage:photos[i] withWaterModel:watermark]];
                }
            }else{
                [photosarray addObject:photos[i]];
            }
         
        }
        photos = [photosarray  copy];
    }

    if ([tzImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
        [tzImagePickerVc.pickerDelegate imagePickerController:tzImagePickerVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:isSelectOriginalPhoto];
    }
    if ([tzImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:infos:)]) {
        [tzImagePickerVc.pickerDelegate imagePickerController:tzImagePickerVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:isSelectOriginalPhoto infos:infoArr];
    }
    if (tzImagePickerVc.didFinishPickingPhotosHandle) {
        tzImagePickerVc.didFinishPickingPhotosHandle(photos,assets,isSelectOriginalPhoto);
    }
    if (tzImagePickerVc.didFinishPickingPhotosWithInfosHandle) {
        tzImagePickerVc.didFinishPickingPhotosWithInfosHandle(photos,assets,isSelectOriginalPhoto,infoArr);
    }
}


-(UIImage *)watermarkImage:(UIImage *)img withWaterModel:(LKWatermarkModel *)model{
    

    if (model.watermarkType == LKWatermarkTypeImage) {
        //图片添加图片水印
        UIImage *mask = model.markImage;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0){
            UIGraphicsBeginImageContextWithOptions([img size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
        }
#else
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0){
            UIGraphicsBeginImageContext([img size]);
        }
#endif
        //原图
        [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
        CGRect rect;
        switch (model.watermarkModelType) {
            case LKWatermarkModelTypeTopLeft:
                rect = CGRectMake(space, space, mask.size.width, mask.size.height);
                break;
            case LKWatermarkModelTypeTopRight:
                rect = CGRectMake(img.size.width-space-mask.size.width, space, mask.size.width, mask.size.height);
                break;
            case LKWatermarkModelTypeBottomLeft:
                rect = CGRectMake(space, img.size.height - mask.size.height - 10, mask.size.width, mask.size.height);
                break;
            case LKWatermarkModelTypeBottomRight:
                rect = CGRectMake(img.size.width-space-mask.size.width, img.size.height - mask.size.height - 10, mask.size.width, mask.size.height);
                break;
            default:
                rect = CGRectMake(space, img.size.height - mask.size.height - 10, mask.size.width, mask.size.height);
                break;
        }
            //水印图
            [mask drawInRect:rect];
  
        UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newPic;
    }
    
    //图片添加文字水印
    NSString* mark = model.title;
    //水印是否是当前时间戳
    if (model.watermarkType == LKWatermarkTypeTime) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:model.dateForMatter];
        mark = [formatter stringFromDate:date];
    }
    int w = img.size.width;
    int h = img.size.height;
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0,0 , w, h)];
    NSDictionary *attr = @{
        NSFontAttributeName: model.font,  //设置字体
        NSForegroundColorAttributeName : model.color   //设置字体颜色
    };
    CGRect rect =  [mark boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    switch (model.watermarkModelType) {
        case LKWatermarkModelTypeTopLeft:
            [mark drawInRect:CGRectMake(space, space, rect.size.width, 32) withAttributes:attr];         //左上角
            break;
        case LKWatermarkModelTypeTopRight:
            [mark drawInRect:CGRectMake(w - rect.size.width -space, space, rect.size.width, 32)  withAttributes:attr];      //右上角
            break;
        case LKWatermarkModelTypeBottomLeft:
            [mark drawInRect:CGRectMake(space, h - 32 - space, rect.size.width, 32) withAttributes:attr];        //左下角
            break;
        case LKWatermarkModelTypeBottomRight:
            [mark drawInRect:CGRectMake(w - rect.size.width- space, h - 32 - space, rect.size.width, 32) withAttributes:attr];   //右下角
            break;
        default:
            [mark drawInRect:CGRectMake(space, h - 32 - space, rect.size.width, 32) withAttributes:attr];        //左下角
            break;
    }

    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}





@end
