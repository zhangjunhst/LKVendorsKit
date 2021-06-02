//
//  NSURL+LKFileType.m
//  TZImagePickTest
//
//  Created by Luculent on 2021/5/11.
//

#import "NSURL+LKFileType.h"
#import <objc/message.h>
#import <UIKit/UIKit.h>

@implementation NSURL (LKFileType)

static char parmFileType;

- (void)setFileType:(NSString *)fileType{
    
    [self willChangeValueForKey:@"fileType"];
    objc_setAssociatedObject(self, &parmFileType, fileType, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"ht_indexPath"];
}

- (NSString *)fileType{
    id object = objc_getAssociatedObject(self,&parmFileType);
    return object;
}

@end
