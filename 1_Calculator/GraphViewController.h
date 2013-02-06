//
//  GraphViewController.h
//  3_Graph_Calculator
//
//  Created by Zachary Fleischman on 2/5/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController: UIViewController

@property(weak, nonatomic) IBOutlet GraphView *graphView;
- (IBAction)pan:(UIPanGestureRecognizer *)sender;
- (IBAction)pinch:(UIPinchGestureRecognizer *)sender;
- (IBAction)tap:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UILabel *graphDescription;

@end
