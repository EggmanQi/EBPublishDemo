//
//  UIImage+Scale.h
//  ComicFans-iOS
//
//  Created by EggmanQi on 15/1/2.
//  Copyright (c) 2015年 FabriQate Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)
+ (UIImage*)imageWithImage:(UIImage*)sourceImage
scaledToSizeWithSameAspectRatio:(CGSize)targetSize;

- (UIImage *)scaledToNewSize:(CGSize)size;
@end
