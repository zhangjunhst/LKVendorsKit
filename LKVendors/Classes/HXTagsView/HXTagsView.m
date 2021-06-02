//
//  HXTagsView.m
//  黄轩 https://github.com/huangxuan518
//
//  Created by 黄轩 on 16/1/13.
//  Copyright © 2015年 IT小子. All rights reserved.
//

#import "HXTagsView.h"
#import "HXTagCollectionViewCell.h"
#import "HXTagAttribute.h"

@interface HXTagsView () <UICollectionViewDelegate, UICollectionViewDataSource>


@end

@implementation HXTagsView

static NSString * const reuseIdentifier = @"HXTagCollectionViewCellId";

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    //初始化样式
    _tagAttribute = [HXTagAttribute new];
    
    [self addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // TODO:
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - self.layout.sectionInset.left - self.layout.sectionInset.right-_tagAttribute.tagSpace, self.layout.itemSize.height);
    
    CGRect frame = [_tags[indexPath.item] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_tagAttribute.titleSize]} context:nil];
    
    if (_tagAttribute.tagMinWidth) {
        return CGSizeMake(MAX(frame.size.width, _tagAttribute.tagMinWidth) + _tagAttribute.tagSpace, self.layout.itemSize.height);
    }
    return CGSizeMake(frame.size.width + _tagAttribute.tagSpace, self.layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HXTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = _tagAttribute.normalBackgroundColor;
    cell.layer.borderColor = _tagAttribute.borderColor.CGColor;
    cell.layer.cornerRadius = _tagAttribute.cornerRadius;
    cell.layer.borderWidth = _tagAttribute.borderWidth;
    cell.titleLabel.textColor = _tagAttribute.textColor;
    cell.titleLabel.font = [UIFont systemFontOfSize:_tagAttribute.titleSize];
    
    NSString *title = self.tags[indexPath.item];
    if (_key.length > 0) {
        cell.titleLabel.attributedText = [self searchTitle:title key:_key keyColor:_tagAttribute.keyColor];
    } else {
        cell.titleLabel.text = title;
    }
    
    if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
        cell.backgroundColor = _tagAttribute.selectedBackgroundColor;
        cell.titleLabel.textColor = _tagAttribute.selectedTextColor;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HXTagCollectionViewCell *cell = (HXTagCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.opaque = YES;
    
    if ([self.tags[indexPath.item] isEqualToString:@"暂无"]) {
        return;
    }
    
    if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
        cell.backgroundColor = _tagAttribute.normalBackgroundColor;
        cell.titleLabel.textColor = _tagAttribute.textColor;
        [self.selectedTags removeObject:self.tags[indexPath.item]];
    }
    else {
        if (_isMultiSelect) {
            cell.backgroundColor = _tagAttribute.selectedBackgroundColor;
            cell.titleLabel.textColor = _tagAttribute.selectedTextColor;
            [self.selectedTags addObject:self.tags[indexPath.item]];
        } else {
            [self.selectedTags removeAllObjects];
            [self.selectedTags addObject:self.tags[indexPath.item]];
            
            [self reloadData];
        }
    }
    
    if (_completion) {
        _completion(self.selectedTags,indexPath.item);
    }
}

// 设置文字中关键字高亮
- (NSMutableAttributedString *)searchTitle:(NSString *)title key:(NSString *)key keyColor:(UIColor *)keyColor {
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:title];
    NSString *copyStr = title;
    
    NSMutableString *xxstr = [NSMutableString new];
    for (int i = 0; i < key.length; i++) {
        [xxstr appendString:@"*"];
    }
    
    while ([copyStr rangeOfString:key options:NSCaseInsensitiveSearch].location != NSNotFound) {
        
        NSRange range = [copyStr rangeOfString:key options:NSCaseInsensitiveSearch];
        
        [titleStr addAttribute:NSForegroundColorAttributeName value:keyColor range:range];
        copyStr = [copyStr stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:xxstr];
    }
    return titleStr;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
}


- (CGSize)intrinsicContentSize{
    CGSize size = self.collectionView.contentSize;
    return size;
}

#pragma mark - 懒加载

- (NSMutableArray *)selectedTags
{
    if (!_selectedTags) {
        _selectedTags = [NSMutableArray array];
    }
    return _selectedTags;
}

- (HXTagCollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [HXTagCollectionViewFlowLayout new];
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
        [_collectionView registerClass:[HXTagCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    
    _collectionView.collectionViewLayout = self.layout;
    if (self.layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        //垂直
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    } else {
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    
    _collectionView.frame = self.bounds;
    
    return _collectionView;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.collectionView.backgroundColor = backgroundColor;
}

+ (CGFloat)getHeightWithTags:(NSArray *)tags layout:(HXTagCollectionViewFlowLayout *)layout tagAttribute:(HXTagAttribute *)tagAttribute width:(CGFloat)width
{
    CGFloat contentHeight;
    
    if (!layout) {
        layout = [[HXTagCollectionViewFlowLayout alloc] init];
    }
    
    if (tagAttribute.titleSize <= 0) {
        tagAttribute = [[HXTagAttribute alloc] init];
    }
    
    //cell的高度 = 顶部 + 高度
    contentHeight = layout.sectionInset.top + layout.itemSize.height;
    
    CGFloat originX = layout.sectionInset.left;
    CGFloat originY = layout.sectionInset.top;
    
    NSInteger itemCount = tags.count;
    
    for (NSInteger i = 0; i < itemCount; i++) {
        CGSize maxSize = CGSizeMake(width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
        
        CGRect frame = [tags[i] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:tagAttribute.titleSize]} context:nil];
        
        CGSize itemSize = CGSizeMake(ceil(frame.size.width) + tagAttribute.tagSpace, layout.itemSize.height);
        
        if (tagAttribute.tagMinWidth) {
            itemSize = CGSizeMake(ceil(MAX(frame.size.width, tagAttribute.tagMinWidth)) + tagAttribute.tagSpace, layout.itemSize.height);
        }
        if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            //垂直滚动
            //当前CollectionViewCell的起点 + 当前CollectionViewCell的宽度 + 当前CollectionView距离右侧的间隔 > collectionView的宽度
            
            CGFloat widthtotal = originX + itemSize.width + layout.sectionInset.right;
            if (widthtotal > width) {
                originX = layout.sectionInset.left;
                originY += itemSize.height + layout.minimumLineSpacing;
                
                contentHeight += itemSize.height + layout.minimumLineSpacing;
            }
        }
        
        originX += itemSize.width + layout.minimumInteritemSpacing;
    }
    
    contentHeight += layout.sectionInset.bottom;
    return contentHeight;
}

@end
