//
//  ViewController.h
//  1_Calculator
//
//  Created by Zachary Fleischman on 1/14/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *operationsDisplay;
- (IBAction)digitPressed:(id)sender;
- (IBAction)operationPressed:(id)sender;
- (IBAction)enterPressed;
- (IBAction)decimalPressed;
- (IBAction)clearPressed;
- (IBAction)changeSignPressed;
- (IBAction)deletePressed;
- (IBAction)varPressed:(id)sender;
- (IBAction)test1:(id)sender;
- (IBAction)test2:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *variableValueDisplay;

@end
