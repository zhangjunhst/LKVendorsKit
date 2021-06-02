//
//  XHPopMenuItemView.m
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-6-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPopMenuItemView.h"

@interface XHPopMenuItemView ()

@property (nonatomic, strong) UIView *menuSelectedBackgroundView;

@property (nonatomic, strong) UIImageView *separatorLineImageView;

@end

@implementation XHPopMenuItemView

- (void)setupPopMenuItem:(XHPopMenuItem *)popMenuItem atIndexPath:(NSIndexPath *)indexPath isBottom:(BOOL)isBottom {
    
    self.popMenuItem = popMenuItem;
    self.textLabel.text = popMenuItem.title;
    self.imageView.image = popMenuItem.image;
    self.separatorLineImageView.hidden = isBottom;
}

#pragma mark - Propertys

- (UIView *)menuSelectedBackgroundView {
    if (!_menuSelectedBackgroundView) {
        _menuSelectedBackgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        _menuSelectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _menuSelectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.216 green:0.242 blue:0.263 alpha:0.9];
        _menuSelectedBackgroundView.backgroundColor = [UIColor colorWithRed:22.0/255 green:92.0/255 blue:162.0/255 alpha:0.9];
    }
    return _menuSelectedBackgroundView;
}

- (UIImageView *)separatorLineImageView {
    if (!_separatorLineImageView) {
        
        CGFloat maxWidth = CGRectGetWidth(self.contentView.bounds);
        _separatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kXHMenuItemViewImageSapcing, kXHMenuItemViewHeight - kXHSeparatorLineImageViewHeight, maxWidth - kXHMenuItemViewImageSapcing * 2, kXHSeparatorLineImageViewHeight)];
        _separatorLineImageView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    }
    return _separatorLineImageView;
}

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        UIView *selectV = [UIView new];
        selectV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.selectedBackgroundView = selectV;//self.menuSelectedBackgroundView;
        [self.contentView addSubview:self.separatorLineImageView];
    }
    return self;
}

@end
