//
//  CalculatorViewController.m
//  1_Calculator
//
//  Created by Zachary Fleischman on 1/14/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsEnteringNumber;
@property (nonatomic) BOOL userHasEnteredDecimal;
@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController

@synthesize display = _display, operationsDisplay = _operationsDisplay;
@synthesize userIsEnteringNumber = _userIsEnteringNumber;
@synthesize userHasEnteredDecimal = _userHasEnteredDecimal;
@synthesize  brain = _brain;


- (CalculatorBrain *)brain {
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)updateOperationsDisplay {
    self.operationsDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowGraph"]) {
        GraphViewController *target = segue.destinationViewController;
        target.program = self.brain.program;
    }
}

- (IBAction)digitPressed:(UIButton*)sender {
    NSString *digit = [sender currentTitle];
    if(self.userIsEnteringNumber) {
        [self.display setText:[self.display.text stringByAppendingString:digit]];
    } else {
        self.display.text = digit;
        self.userIsEnteringNumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsEnteringNumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    
    self.display.text = [NSString stringWithFormat:@"%g", result];
    [self updateOperationsDisplay];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self updateOperationsDisplay];
    self.userIsEnteringNumber = NO;
    self.userHasEnteredDecimal = NO;
}

- (IBAction)decimalPressed {
    if(!self.userHasEnteredDecimal) {
        if(self.userIsEnteringNumber) {
            [self.display setText:[self.display.text stringByAppendingString:@"."]];
        } else {
            self.display.text = @"0.";
            self.userIsEnteringNumber = YES;
        }
        self.userHasEnteredDecimal = YES;
    }
}

- (IBAction)clearPressed {
    self.display.text = @"0";
    self.operationsDisplay.text = @"";
    self.userIsEnteringNumber = NO;
    self.userHasEnteredDecimal = NO;
    [self.brain clear];
}

- (IBAction)changeSignPressed {
    if(self.userIsEnteringNumber) {
        NSString *num = self.display.text;
        if([num characterAtIndex:0] != '-') {
            self.display.text = [@"-" stringByAppendingString:num];
        } else {
            self.display.text = [num substringFromIndex:1];
            if(self.display.text.length == 0) self.display.text = @"0";
        }
    } else {
        double result = [self.brain performOperation:@"+/-"];
        self.display.text = [NSString stringWithFormat:@"%g", result];
        [self updateOperationsDisplay];
    }
}

- (IBAction)deletePressed {
    if(self.userIsEnteringNumber) {
        NSString *num = self.display.text;
        if([num isEqualToString:@""] || num.length < 2) {
            num = @"0";
            self.userHasEnteredDecimal = NO;
        } else {
            if([num characterAtIndex:(num.length-1)] == '.') self.userHasEnteredDecimal = NO;
            num = [num substringToIndex:num.length - 1];
        }
        self.display.text = num;
    } else {
        [self.brain undo]; 
        [self updateOperationsDisplay];
        double result;
        
        result = [CalculatorBrain runProgram:self.brain.program];

        self.display.text = [NSString stringWithFormat:@"%g", result];
        
    }
}

- (IBAction)varPressed:(id)sender {
    if(self.userIsEnteringNumber) {
        [self enterPressed];
    }
    [self.brain pushVariable:[sender currentTitle]];
    [self updateOperationsDisplay];
}

@end
