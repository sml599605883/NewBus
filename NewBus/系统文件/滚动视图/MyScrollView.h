//
//  ImageScrollView.h
//  StarrySky
//
//  Created by 苹果爸爸 on 2017/9/12.
//  Copyright © 2017年 BW. All rights reserved.
//

#import <UIKit/UIKit.h>


/// 表示图片滚动视图的样式
typedef enum {
    ImageScrollType_Guide = 100,   // 开机guide视图样式
    ImageScrollType_Banner  // banner栏样式
}ImageScrollType;


/// 协议，触发事件回调的方法
@protocol ImageScrollViewDelegate <NSObject>
@optional
/// “ImageScrollType_Guide”样式的最后一个视图上的“立即体验”按钮触发
-(void)experienceDidHandle;
/// “ImageScrollType_Banner”样式每一个图片触发回调的方法;index表示选中的图片的下标
-(void)bannerImageDidHandleWithIndex:(NSInteger)index;
@end



@interface MyScrollView : UIScrollView

/// 参数1：滚动视图位置（建议以4.7寸屏设置）; 参数2：样式 ; 参数3：图片名称数组 ; 参数4：guide样式的“立即体验”按钮标题；参数5：guide样式的“立即体验”按钮位置；参数6：banner轮播图时间间隔 ; 参数7：代理设置，用于触发事件回调
-(instancetype)initWithFrame:(CGRect)frame
                       style:(ImageScrollType)type
                      images:(NSArray *)imgNameArr
             confirmBtnTitle:(NSString *)title
        confirmBtnTitleColor:(UIColor *)titleColor
             confirmBtnFrame:(CGRect)btnFrame
      autoScrollTimeInterval:(NSTimeInterval)interval
                    delegate:(id<ImageScrollViewDelegate>)delegate;

/// 给ImageScrollView的父视图添加分页控件，这个必须在把ImageScrollView加为父视图的子视图之后再调用此方法
-(void)addPageControlToSuperView:(UIView *)superView;


@end





