//
//  GraphViewController.m
//  3_Graph_Calculator
//
//  Created by Zachary Fleischman on 2/5/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"

@interface GraphViewController () <GraphViewDataSource>

@end

@implementation GraphViewController

@synthesize program = _program;

- (void)setGraphView:(GraphView *)graphView {
    _graphView = graphView;
    self.graphView.dataSource = self;
}

//delegate function for graph view
- (CGFloat)yValueForX:(CGFloat)x inView:(GraphView *)sender {
    CGFloat realX = (x - sender.graphOrigin.x) / sender.scale;
    
    CGFloat realY = [CalculatorBrain runProgram:self.program
                            usingVariableValues:[NSDictionary dictionaryWithObject:
                                                 [NSNumber numberWithFloat:realX] forKey:@"x"]];
    
    CGFloat y = (realY * -1.0 * sender.scale + sender.graphOrigin.y);
    return y;
}

//handle the three gestures of graph view
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
