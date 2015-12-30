//
//  MRNavigitionController.h
//  MR.PopNavigationGestrue
//
//  Created by mac on 15/12/28.
//  Copyright © 2015年 MR. All rights reserved.


#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    horizTranform,
    scaleTransform,
} TransformStyle;


@interface MRNavigitionController : UINavigationController

@property (nonatomic, assign) TransformStyle transformStyle;

@end
