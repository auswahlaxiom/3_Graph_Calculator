//
//  GraphViewController.m
//  3_Graph_Calculator
//
//  Created by Zachary Fleischman on 2/5/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController () <GraphViewDataSource>

@end

@implementation GraphViewController
- (void)setGraphView:(GraphView *)graphView {
    _graphView = graphView;
    self.graphView.dataSource = self;
}

- (CGFloat)yValueForX:(CGFloat)x inView:(GraphView *)sender {
    CGFloat realX = (x - sender.graphOrigin.x) / sender.scale;
    
    CGFloat realY = realX * (realX + 1) * (realX - 1) * (realX + 2) * (realX - 2);
    
    CGFloat y = (realY * -1.0 * sender.scale + sender.graphOrigin.y);
    return y;
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    if ((sender.state == UIGestureRecognizerStateChanged) ||
        (sender.state == UIGestureRecognizerStateEnded)) {

        CGPoint translation = [sender translationInView:self.graphView];

        [self.graphView translateOriginByPoint:translation];

        [sender setTranslation:CGPointMake(0, 0) inView:self.graphView];
    }
    if(sender.state == UIGestureRecognizerStateEnded) {
        [[NSUserDefaults standardUserDefaults] setFloat:self.graphView.graphOrigin.x forKey:@"OriginX"];
        [[NSUserDefaults standardUserDefaults] setFloat:self.graphView.graphOrigin.y forKey:@"OriginY"];
    }
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender {
    if ((sender.state == UIGestureRecognizerStateChanged) ||
        (sender.state == UIGestureRecognizerStateEnded)) {
        
        self.graphView.scale *= sender.scale;
        
        sender.scale = 1;
    }
    if(sender.state == UIGestureRecognizerStateEnded) {
        [[NSUserDefaults standardUserDefaults] setFloat:self.graphView.scale forKey:@"Scale"];
    }
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    if ((sender.state == UIGestureRecognizerStateChanged) ||
        (sender.state == UIGestureRecognizerStateEnded)) {
        
        self.graphView.graphOrigin = [sender locationInView:self.graphView];
        [[NSUserDefaults standardUserDefaults] setFloat:self.graphView.graphOrigin.x forKey:@"OriginX"];
        [[NSUserDefaults standardUserDefaults] setFloat:self.graphView.graphOrigin.y forKey:@"OriginY"];
    }
}
@end
