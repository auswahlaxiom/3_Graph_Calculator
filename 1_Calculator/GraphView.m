//
//  GraphView.m
//  3_Graph_Calculator
//
//  Created by Zachary Fleischman on 2/5/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize graphOrigin = _graphOrigin;
@synthesize scale = _scale;

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
    
    if([[NSUserDefaults standardUserDefaults] floatForKey:@"OriginX"] && [[NSUserDefaults standardUserDefaults] floatForKey:@"OriginY"]) {
        self.graphOrigin = CGPointMake([[NSUserDefaults standardUserDefaults] floatForKey:@"OriginX"], [[NSUserDefaults standardUserDefaults] floatForKey:@"OriginY"]);
    } else {
        self.graphOrigin = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    }
        
    if([[NSUserDefaults standardUserDefaults] floatForKey:@"Scale"]) {
        self.scale = [[NSUserDefaults standardUserDefaults] floatForKey:@"Scale"];
    } else {
        self.scale = 50;
    }
}

- (CGFloat)scale
{
    if (!_scale) {
        if([[NSUserDefaults standardUserDefaults] floatForKey:@"Scale"]) {
            self.scale = [[NSUserDefaults standardUserDefaults] floatForKey:@"Scale"];
        } else {
            self.scale = 50;
        }
    }
    return _scale;
}

- (void)setGraphOrigin:(CGPoint)graphOrigin {
    if(graphOrigin.x != _graphOrigin.x && graphOrigin.y != _graphOrigin.y) {
        _graphOrigin = graphOrigin;
        [self setNeedsDisplay];
    }
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}

- (void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGPoint point = CGPointMake(0, [self.dataSource yValueForX:0 inView:self]);
    CGContextMoveToPoint(context, point.x, point.y);
    
    for(CGFloat x = 1; x < self.bounds.size.width * self.contentScaleFactor; x += (1.0/self.contentScaleFactor)) {
        point = CGPointMake(x, [self.dataSource yValueForX:x inView:self]);
        CGContextAddLineToPoint(context, point.x, point.y);
        CGContextStrokePath(context);
        UIGraphicsPopContext();
        
        UIGraphicsPushContext(context);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, point.x, point.y);
        
    }
    UIGraphicsPopContext();
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.graphOrigin scale:self.scale];
}

- (void)translateOriginByPoint: (CGPoint) point {
    
    self.graphOrigin = CGPointMake(point.x + self.graphOrigin.x, point.y + self.graphOrigin.y);
    [self setNeedsDisplay];
}

- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup]; // get initialized if someone uses alloc/initWithFrame: to create us
    }
    return self;
}





@end
