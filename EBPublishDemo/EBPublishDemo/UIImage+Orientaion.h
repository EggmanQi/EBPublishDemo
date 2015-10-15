//
//  UIImage+Orientaion.h
//  ComicFans-iOS
//
//  Created by EggmanQi on 14/10/11.
//  Copyright (c) 2014年 FabriQate Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Orientaion)

/*
 * 调整图片方向
 */
- (UIImage *)fixOrientation;


/*
 * 根据 ALAsset 的 ALAssetPropertyOrientation 方向来调整
 */
- (UIImage *)scaleAndRotateImage:(UIImage *)image
               originalOriention:(NSNumber*)oriention;
@end
