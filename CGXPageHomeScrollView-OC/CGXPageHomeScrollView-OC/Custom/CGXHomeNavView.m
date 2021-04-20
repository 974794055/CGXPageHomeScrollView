//
//  CGXHomeNavView.m
//  CGXPageHomeScrollView-OC
//
//  Created by CGX on 2020/9/12.
//  Copyright © 2020 CGX. All rights reserved.
//

#import "CGXHomeNavView.h"

@interface CGXHomeNavView()

@property (nonatomic, strong) UIButton   *cancelBtn;
@property (nonatomic, strong) UILabel       *nameLabel;
@property (nonatomic, strong) UIView       *lineLabel;
@end

@implementation CGXHomeNavView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelBtn setImage:[UIImage imageNamed:@"btn_back_black"] forState: UIControlStateSelected];
        [self.cancelBtn setImage:[UIImage imageNamed:@"btn_back_black"] forState:UIControlStateHighlighted | UIControlStateSelected];
        [self.cancelBtn setAdjustsImageWhenHighlighted:NO];
        [self.cancelBtn setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelBtn];
        self.cancelBtn.selected = NO;
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:18.0f];
        _nameLabel.text = @"CGX_鑫";
        _nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.nameLabel];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        self.lineLabel = [[UIView alloc] init];
        self.lineLabel.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        [self addSubview:self.lineLabel];
        self.lineLabel.hidden = YES;
    }
    return self;
}
- (void)cancelBtnClick:(UIButton *)btn
{
    if (self.cancelBtnBlock) {
        self.cancelBtnBlock();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(kNavBarHeight);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(0);
        make.height.mas_equalTo(kNavBarHeight);
        make.width.mas_equalTo(100);
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
    }];
    
}
- (void)scrollNavAlpha:(CGFloat)alpha IsOpaque:(BOOL)isOpaque
{
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
    self.cancelBtn.selected = isOpaque;
    self.nameLabel.textColor =  isOpaque ? [UIColor blackColor]:[UIColor whiteColor];
    self.lineLabel.hidden = !isOpaque;
}

@end
