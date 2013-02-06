//
//  GraphView.h
//  3_Graph_Calculator
//
//  Created by Zachary Fleischman on 2/5/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;
@protocol GraphViewDataSource
- (CGFloat)yValueForX: (CGFloat)x inView: (GraphView *)sender;
@end

@interface GraphView : UIView

@property (weak, nonatomic) IBOutlet id <GraphViewDataSource> dataSource;

@property (nonatomic) CGPoint graphOrigin;
@property (nonatomic) CGFloat scale;

- (void)translateOriginByPoint: (CGPoint) point;

@end
