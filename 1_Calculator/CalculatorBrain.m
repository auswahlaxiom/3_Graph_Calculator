//
//  CalculatorBrain.m
//  1_Calculator
//
//  Created by Zachary Fleischman on 1/14/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "CalculatorBrain.h"
#include <math.h>

@interface CalculatorBrain ()

@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack {
    if(_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}
- (id)program {
    return [self.programStack copy];
}
- (void)clear {
    [self.programStack removeAllObjects];
}
- (void)undo {
    [self.programStack removeLastObject];
}
- (void)pushOperand: (double)operand {

    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
    
}
- (void)pushVariable:(NSString *)variable {
    
    [self.programStack addObject:variable];
    
}
- (double)performOperation: (NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}
+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableSet *variables = [[NSMutableSet alloc] init];
    if([program isKindOfClass:[NSArray class]]) {
        NSArray *stack = program;
        for(id obj in stack) {
            if([obj isKindOfClass:[NSString class]] ) {
                if(![CalculatorBrain isOperator:obj]) {
                    [variables addObject: obj];
                }
            }
        }
    }
    if([variables count] == 0) return nil;
    return [variables copy];
}
+ (BOOL)isOperator: (id) symbol {
    if([symbol isKindOfClass:[NSNumber class]]) {
        return true;
    }
    return [symbol isEqualToString:@"+"] ||
        [symbol isEqualToString:@"-"] ||
        [symbol isEqualToString:@"*"] ||
        [symbol isEqualToString:@"/"] ||
        [symbol isEqualToString:@"sin"] ||
        [symbol isEqualToString:@"cos"] ||
        [symbol isEqualToString:@"sqrt"] ||
        [symbol isEqualToString:@"pi"] ||
        [symbol isEqualToString:@"√"] ||
        [symbol isEqualToString:@"π"] ||
        [symbol isEqualToString:@"+/-"];
    
}

+ (double)runProgram:(id)program {
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {

    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    //replace all variables with their values
    for(int i = 0; i < stack.count; i++) {
        if ([variableValues objectForKey:[stack objectAtIndex:i]] != nil) {
            [stack replaceObjectAtIndex:i withObject:
             [variableValues objectForKey:[stack objectAtIndex:i]]];
        } else if (![CalculatorBrain isOperator:[stack objectAtIndex:i]]){
            [stack replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
        }
    }
    //execute program normally now

    return [self popOperandOffStack:stack];
}
+ (double)popOperandOffStack:(NSMutableArray *)stack {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if(topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            if(divisor) result =  [self popOperandOffStack:stack] / divisor;
        } else if([operation isEqualToString:@"sin"]) {
            double op = [self popOperandOffStack:stack];
            result = sin(op);
        } else if([operation isEqualToString:@"cos"]) {
            double op = [self popOperandOffStack:stack];
            result = cos(op);
        } else if([operation isEqualToString:@"√"] || [operation isEqualToString:@"sqrt"]) { //square root symbol: √
            double op = [self popOperandOffStack:stack];
            if(op >= 0) {
                result = sqrt(op);
            } else {
                result = 0;
            }
        } else if([operation isEqualToString:@"π"] || [operation isEqualToString:@"pi"]) {
            result = M_PI;
        } else if([operation isEqualToString:@"+/-"]) {
            result = -1 * [self popOperandOffStack:stack];
        }
    }
    return result;

}
+ (NSString *)descriptionOfProgram:(id)program {
    NSMutableArray *stack;
    NSMutableString *description = [[NSMutableString alloc] init];
    if([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    NSMutableString *section = [[NSMutableString alloc] init];
    section = [[self popStringDescriptionOffStack:stack intoString:section] mutableCopy];
    if([section characterAtIndex:0] == '(' && [section characterAtIndex:[section length]-1] == ')'
       && [section characterAtIndex:1] == '(' && [section characterAtIndex:[section length]-2] == ')') {
        [section deleteCharactersInRange:NSMakeRange(0, 1)];
        [section deleteCharactersInRange:NSMakeRange([section length]-1, 1)];
    }
    [description appendString:section];
    while(stack.lastObject) {
        [description appendString:@", "];
        NSMutableString *section = [[self popStringDescriptionOffStack:stack intoString:section] mutableCopy];
        if([section characterAtIndex:0] == '(' && [section characterAtIndex:[section length]-1] == ')'
           && [section characterAtIndex:1] == '(' && [section characterAtIndex:[section length]-2] == ')' ) {
            [section deleteCharactersInRange:NSMakeRange(0, 1)];
            [section deleteCharactersInRange:NSMakeRange([section length]-1, 1)];
        }
        [description appendString:section];
    }
    return description;
}
+ (NSString *)popStringDescriptionOffStack:(NSMutableArray *)stack intoString:(NSString *)description {
    id topOfStack = [stack lastObject];
    if(topOfStack) {[stack removeLastObject];}
    else {return @"0";}
    
    if([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        //NSLog([NSString stringWithFormat:@"recieved: %@", operation]);
        
        if([operation isEqualToString:@"+"]) {
            NSString *firstPart = [self popStringDescriptionOffStack:stack intoString:description];
            description =[NSString stringWithFormat:@"(%@ %@ %@)", [self popStringDescriptionOffStack:stack intoString:description], operation, firstPart];
        } else if([@"*" isEqualToString:operation]) {
            NSString *firstPart = [self popStringDescriptionOffStack:stack intoString:description];
            description =[NSString stringWithFormat:@"%@ %@ %@", [self popStringDescriptionOffStack:stack intoString:description], operation, firstPart];
        } else if([operation isEqualToString:@"/"]) {
            NSString *subtravisor = [self popStringDescriptionOffStack:stack intoString:description];
            if(subtravisor) description =[NSString stringWithFormat:@"%@ %@ %@", [self popStringDescriptionOffStack:stack intoString:description], operation, subtravisor];
        }else if([operation isEqualToString:@"-"]) {
            NSString *subtravisor = [self popStringDescriptionOffStack:stack intoString:description];
            if(subtravisor) description =[NSString stringWithFormat:@"(%@ %@ %@)", [self popStringDescriptionOffStack:stack intoString:description], operation, subtravisor];
            
        } else if([operation isEqualToString:@"sin"] || [operation isEqualToString:@"cos"] || [operation isEqualToString:@"√"]) {
            description =[NSString stringWithFormat:@"%@(%@)", operation, [self popStringDescriptionOffStack:stack intoString:description]];
        } else if([operation isEqualToString:@"sqrt"]) {
            description =[NSString stringWithFormat:@"√(%@)", [self popStringDescriptionOffStack:stack intoString:description]];
        }else if([operation isEqualToString:@"π"] || [operation isEqualToString:@"pi"]) {
            description = @"π";
        } else if([operation isEqualToString:@"+/-"]) {
            NSMutableString *operand = [[self popStringDescriptionOffStack:stack intoString:description] mutableCopy];
            if([operand characterAtIndex:0] == '-' ) {
                [operand deleteCharactersInRange:NSMakeRange(0, 1)];
            } else {
                operand = [NSString stringWithFormat:@"-%@", operand];
            }
            description = operand;
        } else {
            return operation; //in this case it's a variable, just return it
        }
    } else if([topOfStack isKindOfClass:[NSNumber class]]) {
        NSNumber *operand = topOfStack;
        // NSLog([NSString stringWithFormat:@"recieved: %@", [operand stringValue]]);
        return [operand stringValue];
    }
    
    //NSLog([NSString stringWithFormat:@"current description: %@", description]);
    return description;
}



@end
