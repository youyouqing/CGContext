//
//  ViewController.m
//  二维码生成
//
//  Created by zhangmin on 17/4/5.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MyView" owner:self options:nil];
    //得到第一个UIView
    UIView *tmpCustomView = [nib objectAtIndex:0];
    
    
   
    
    
    //获得屏幕的Frame
    CGRect tmpFrame = [[UIScreen mainScreen] bounds];
    //设置自定义视图的中点为屏幕的中点
    [tmpCustomView setFrame:tmpFrame];
    //添加视图
    [self.view addSubview:tmpCustomView];
    
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
       CGRect extent = CGRectIntegral(image.extent);
        CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
  
      // 1.创建bitmap;
      size_t width = CGRectGetWidth(extent) * scale;
      size_t height = CGRectGetHeight(extent) * scale;
       CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
     CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
      CIContext *context = [CIContext contextWithOptions:nil];
     CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
      CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
       CGContextScaleCTM(bitmapRef, scale, scale);
       CGContextDrawImage(bitmapRef, extent, bitmapImage);
       // 2.保存bitmap到图片
      CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
      CGContextRelease(bitmapRef);
        CGImageRelease(bitmapImage);
         return [UIImage imageWithCGImage:scaledImage];
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//  
//       CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//   
//         [filter setDefaults];
//       // 3.给过滤器添加数据(正则表达式/帐号和密码) -- 通过KVC设置过滤器,只能设置NSData类型
//       NSString *dataString = @"12345677";
//      NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
//      [filter setValue:data forKeyPath:@"inputMessage"];
//  
//      // 4.获取输出的二维码
//      CIImage *outputImage = [filter outputImage];
//    
//       // 5.显示二维码
//    self.imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:100];
//    
//    //[UIImage imageWithCIImage:outputImage];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
