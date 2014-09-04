//
//  ViewController.m
//  HausVomNikolaus
//
//  Created by Stanley Rost on 05.09.14.
//  Copyright (c) 2014 Stanley Rost.
//

#import "ViewController.h"

@implementation ViewController
            
- (void)loadView
{
  self.view = [UIView new];
  self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
  self.title = @"Haus vom Nikolaus";
  [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  // draw 3 variants after another
  [self drawHausVomNikolaus:CGRectMake(30, 30, 100, 200)];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self drawHausVomNikolaus2:CGRectMake(180, 30, 100, 200)];
  });
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self drawHausVomNikolaus3:CGRectMake(110, 300, 100, 200)];
  });
}

- (void)drawHausVomNikolaus:(CGRect)frame
{
  // create a new shape layer
  CAShapeLayer *shapeLayer = [self createShapeLayer];
  shapeLayer.frame = frame;
  // convert y coordinates so 0 is down ¯\_(ツ)_/¯
  shapeLayer.transform = CATransform3DMakeScale(1, -1, 1);
  [self.view.layer addSublayer:shapeLayer];
  
  // start point and all segment end points in succession
  CGPoint startPoint = CGPointMake(0, 0);
  NSArray *points = @[
                      [NSValue valueWithCGPoint:CGPointMake(0, 100)],
                      [NSValue valueWithCGPoint:CGPointMake(100, 0)],
                      [NSValue valueWithCGPoint:CGPointMake(100, 100)],
                      [NSValue valueWithCGPoint:CGPointMake(0, 100)],
                      [NSValue valueWithCGPoint:CGPointMake(50, 186.6)],
                      [NSValue valueWithCGPoint:CGPointMake(100, 100)],
                      [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                      [NSValue valueWithCGPoint:CGPointMake(100, 0)],
                      ];
  
  // create a path and make it paint a dot at the start point, otherwise the first stroke will not animate
  UIBezierPath *path = [UIBezierPath new];
  [path moveToPoint:startPoint];
  [path addLineToPoint:startPoint];
  shapeLayer.path = path.CGPath;
  
  // recursive method, see below
  [self drawSegmentToShapeLayer:shapeLayer points:points path:path lastPoint:startPoint];
}

- (void)drawHausVomNikolaus2:(CGRect)frame
{
  CAShapeLayer *shapeLayer = [self createShapeLayer];
  shapeLayer.frame = frame;
  shapeLayer.transform = CATransform3DMakeScale(1, -1, 1);
  [self.view.layer addSublayer:shapeLayer];
  
  CGPoint startPoint = CGPointMake(100, 0);
  NSArray *points = @[
                      [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                      [NSValue valueWithCGPoint:CGPointMake(100, 100)],
                      [NSValue valueWithCGPoint:CGPointMake(0, 100)],
                      [NSValue valueWithCGPoint:CGPointMake(50, 186.6)],
                      [NSValue valueWithCGPoint:CGPointMake(100, 100)],
                      [NSValue valueWithCGPoint:CGPointMake(100, 0)],
                      [NSValue valueWithCGPoint:CGPointMake(0, 100)],
                      [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                      ];
  
  UIBezierPath *path = [UIBezierPath new];
  [path moveToPoint:startPoint];
  [path addLineToPoint:startPoint];
  shapeLayer.path = path.CGPath;
  
  [self drawSegmentToShapeLayer:shapeLayer points:points path:path lastPoint:startPoint];
}

- (void)drawHausVomNikolaus3:(CGRect)frame
{
  CAShapeLayer *shapeLayer = [self createShapeLayer];
  shapeLayer.frame = frame;
  shapeLayer.transform = CATransform3DMakeScale(1, -1, 1);
  [self.view.layer addSublayer:shapeLayer];
  
  CGPoint startPoint = CGPointMake(0, 0);
  NSArray *points = @[
                      [NSValue valueWithCGPoint:CGPointMake(0, 100)],
                      [NSValue valueWithCGPoint:CGPointMake(50, 186.6)],
                      [NSValue valueWithCGPoint:CGPointMake(100, 100)],
                      [NSValue valueWithCGPoint:CGPointMake(100, 0)],
                      [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                      [NSValue valueWithCGPoint:CGPointMake(100, 100)],
                      [NSValue valueWithCGPoint:CGPointMake(0, 100)],
                      [NSValue valueWithCGPoint:CGPointMake(100, 0)],
                      ];
  
  UIBezierPath *path = [UIBezierPath new];
  [path moveToPoint:startPoint];
  [path addLineToPoint:startPoint];
  shapeLayer.path = path.CGPath;
  
  [self drawSegmentToShapeLayer:shapeLayer points:points path:path lastPoint:startPoint];
}

// recursive method
- (void)drawSegmentToShapeLayer:(CAShapeLayer *)shapeLayer
                         points:(NSArray *)points
                           path:(UIBezierPath *)path
                      lastPoint:(CGPoint)lastPoint
{
  // bail out if no more points to connect
  if ([points count] == 0) { return; }
  
  // “config”
  CGFloat duration = 0.25; // duration to draw each segment
  u_int32_t randomizer = 20; // a bit of fun, drawing completely straight lines is boring!
  
  // also the algorithm would be much easier and non-recursive if we just drew straight lines
  
  // get the next point
  CGPoint newPoint = [[points firstObject] CGPointValue];
  
  // create a new shape layer to draw a connection from the last point to the next point
  // we animate strokeEnd instead of just animating to the new path, because that does not look good with arcs and curves!
  CAShapeLayer *newShapeLayer = [self createShapeLayer];
  newShapeLayer.frame = shapeLayer.bounds;
  [shapeLayer addSublayer:newShapeLayer];
  
  // generate some control points for the bezier curves we use instead of the straight lines
  CGPoint controlPoint1 = CGPointMake(lastPoint.x + arc4random_uniform(randomizer) - randomizer/2, lastPoint.y + arc4random_uniform(randomizer) - randomizer/2);
  CGPoint controlPoint2 = CGPointMake(newPoint.x + arc4random_uniform(randomizer) - randomizer/2, newPoint.y + arc4random_uniform(randomizer) - randomizer/2);
  
  // path for the new layer
  UIBezierPath *newPath = [UIBezierPath new];
  [newPath moveToPoint:lastPoint];
  [newPath addCurveToPoint:newPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
  
  newShapeLayer.path = newPath.CGPath;
  newShapeLayer.strokeEnd = 0.0;
  
  // use a transaction to get a completion block
  [CATransaction begin];
  [CATransaction setAnimationDuration:duration];
  [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  [CATransaction setCompletionBlock:^{
    
    // another transaction that disables implicit animations
    [CATransaction begin];
    [CATransaction disableActions];
    // add the new point to the original bezier path and remove the layer for just this segment
    [path addCurveToPoint:newPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    shapeLayer.path = path.CGPath;
    [newShapeLayer removeFromSuperlayer];
    [CATransaction commit];
    
    // recurse if there is more to do
    if ([points count] > 1)
    {
      // by taking the remainder of the list
      NSArray *remainingPoints = [points subarrayWithRange:NSMakeRange(1, [points count] - 1)];
      [self drawSegmentToShapeLayer:shapeLayer points:remainingPoints path:path lastPoint:newPoint];
    }
  }];
  
  // animate strokeEnd for this segment, easy peasy
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
  animation.duration = duration;
  animation.fromValue = @0.0;
  animation.toValue = @1.0;
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  
  [newShapeLayer addAnimation:animation forKey:@"strokeEnd"];
  newShapeLayer.strokeEnd = 1.0;
  
  [CATransaction commit];
}

// Helper method to create a shape layer with common attributes
- (CAShapeLayer *)createShapeLayer
{
  CAShapeLayer *shapeLayer = [CAShapeLayer new];

  shapeLayer.lineWidth = 5;
  shapeLayer.fillColor   = [UIColor clearColor].CGColor;
  shapeLayer.strokeColor = [UIColor darkGrayColor].CGColor;
  shapeLayer.lineJoin = kCALineJoinRound;
  shapeLayer.lineCap = kCALineCapRound;
  
  return shapeLayer;
}

@end
