//
//  MyView.m
//  二维码生成
//
//  Created by zhangmin on 17/4/9.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "MyView.h"
#define kWidth 60
#define kHeight 90
#define YdivisionNum 9
@implementation MyView

static int countq = 0;
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
     [super drawRect:rect];
    
    [self drawXandY:(CGRect)rect];
    //  X文字
    
     [self drawX];
    //  Y文字
    [self createLabelY];
    
    [self dravLine];
    
}
-(void)drawXandY:(CGRect)rect
{
    
    CGContextRef cont = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(cont, 2.0);
    
    CGContextSetRGBFillColor(cont, 1, 0, 0, 1);

//    CGContextSetFillColorWithColor(cont, [[UIColor whiteColor] CGColor]);

    CGContextSetStrokeColorWithColor(cont, [UIColor grayColor].CGColor);

   

    CGContextMoveToPoint(cont, 60, 90);
   


    CGContextAddLineToPoint(cont, 60, rect.size.height-90);
    
    CGContextAddLineToPoint(cont,rect.size.width -  60, rect.size.height - 90);


    CGContextStrokePath(cont);

    
}
-(void)drawX
{

    CGFloat  month = 12;
    for (NSInteger i = 0; i < month; i++) {
        UILabel * LabelMonth = [[UILabel alloc]initWithFrame:CGRectMake(25 * i +kWidth, self.frame.size.height - 90 + 30*0.3, 25, 30)];
        LabelMonth.backgroundColor = [UIColor greenColor];
        LabelMonth.tag = 1000 + i;
        LabelMonth.text = [NSString stringWithFormat:@"%ld月",i+1];
//        LabelMonth.font = [UIFont systemFontOfSize:10];
//        LabelMonth.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self addSubview:LabelMonth];
    }


}
- (void)createLabelY{
    CGFloat Ydivision = YdivisionNum;
    for (NSInteger i = 0; i < Ydivision; i++) {
        UILabel * labelYdivision = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height -  kHeight)/Ydivision *i + kHeight/2.0, kWidth, kHeight/2.0)];
        labelYdivision.backgroundColor = [UIColor greenColor];
        labelYdivision.tag = 2000 + i;
        labelYdivision.text = [NSString stringWithFormat:@"%.0f",(Ydivision - i)*100];
        labelYdivision.font = [UIFont systemFontOfSize:10];
        [self addSubview:labelYdivision];
    }
}

#pragma mark 画折线图
- (void)dravLine{
    
    UILabel * label = (UILabel*)[self viewWithTag:1000];//根据横坐标上面的label 获取直线关键点的x 值
    UIBezierPath * path = [[UIBezierPath alloc]init];
    path.lineWidth = 1.0;
    self.path1 = path;
    [path moveToPoint:CGPointMake( label.frame.origin.x , (100*YdivisionNum -arc4random()%(100*YdivisionNum)) /(100*YdivisionNum) * (self.frame.size.height - kHeight*2 )  )];
    
    //创建折现点标记
    for (NSInteger i = 1; i< 12; i++) {
        UILabel * label1 = (UILabel*)[self viewWithTag:1000 + i];
        CGFloat  arc = arc4random()%(100*YdivisionNum);  //折线点目前给的是随机数
        [path addLineToPoint:CGPointMake(label1.frame.origin.x ,  ((100*YdivisionNum) -arc) /(100*YdivisionNum) * (self.frame.size.height - kHeight*2 ) )];
        UILabel * falglabel = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x , ((100*YdivisionNum) -arc) /(100*YdivisionNum) * (self.frame.size.height - kHeight*2 )  , 30, 15)];
        falglabel.backgroundColor = [UIColor grayColor];
        falglabel.tag = 3000+ i;
        falglabel.text = [NSString stringWithFormat:@"%.1f",arc];
        falglabel.font = [UIFont systemFontOfSize:8.0];
        [self addSubview:falglabel];
    }
    [path stroke];
    
    self.lineChartLayer = [CAShapeLayer layer];
    self.lineChartLayer.path = path.CGPath;
    self.lineChartLayer.strokeColor = [UIColor greenColor].CGColor;
    self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    // 默认设置路径宽度为0，使其在起始状态下不显示
    self.lineChartLayer.lineWidth = 0;
    self.lineChartLayer.lineCap = kCALineCapRound;
    self.lineChartLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:self.lineChartLayer];//直接添加导视图上
   
 
}
#pragma mark 点击重新绘制折线和背景
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    countq++;
    if (countq%2 == 0) {
        //点一下删除折线 和转折点数据
        [self.lineChartLayer removeFromSuperlayer];
        for (NSInteger i = 0; i < 12; i++) {
            UILabel * label = (UILabel*)[self viewWithTag:3000 + i];
            [label removeFromSuperview];
        }
    }else{
        
        [self dravLine];
        
        self.lineChartLayer.lineWidth = 2;
#pragma mark    动画
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 3;
        pathAnimation.repeatCount = 1;
        pathAnimation.removedOnCompletion = YES;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        // 设置动画代理，动画结束时添加一个标签，显示折线终点的信息
        pathAnimation.delegate = self;
        [self.lineChartLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
//        [self setNeedsDisplay];
    }
}
@end
