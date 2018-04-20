//
//  ViewController.m
//  TipCalculator
//
//  Created by Raman Singh on 2018-04-19.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *billAmountTextField;
@property (strong, nonatomic) IBOutlet UILabel *tipAmountLabel;
@property (strong, nonatomic) IBOutlet UITextField *tipPercentageTextField;
@property  CGFloat kbH;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *calculateBottomConstraint;
@property (strong, nonatomic) IBOutlet UISlider *slider;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [self watchKeyboardNotifications:notificationCenter];
    
    
    
    
    
    self.billAmountTextField.delegate = self;
    self.tipPercentageTextField.delegate = self;
    
}


- (IBAction)calculateTip:(id)sender {

    [self calculationMethod];
    
}//calculateTip



- (void)watchKeyboardNotifications:(NSNotificationCenter *)notificationCenter {
    
    [notificationCenter addObserver:self
                           selector:@selector(keyboardDidShowNotificationReceived:)
                               name:UIKeyboardWillShowNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(UIKeyboardDidHideNotification:)
                               name:UIKeyboardDidHideNotification
                             object:nil];
    
}//watchKeyboardNotifications


- (void)keyboardDidShowNotificationReceived:(NSNotification *)notification {
    NSLog(@"In keyboardDidShowNotificationReceived: %@", notification.name);
    
    
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.kbH = kbSize.height;

    [UIView animateWithDuration:0.3 animations:^{
    self.calculateBottomConstraint.constant = 10 +  kbSize.height;
    } completion:^(BOOL finished){
//            self.calculateBottomConstraint.constant = 10 +  kbSize.height;
        
    }];

    
    
}//keyboardDidShowNotificationReceived

- (void)UIKeyboardDidHideNotification:(NSNotification *)notification {
    NSLog(@"%@", notification.name);
    
    
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self.mainView layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{

        self.calculateBottomConstraint.constant = 10;
        [self.mainView layoutIfNeeded];
    } completion:^(BOOL finished){


    }];
    
    
}//keyboardDidShowNotificationReceived
    

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.tipPercentageTextField resignFirstResponder];
    [self.billAmountTextField resignFirstResponder];
    return NO;
}

- (IBAction)adjustTipPercentage:(id)sender {
    
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 100;
    
    
    [self.slider addTarget:self action:@selector(sliderMoved) forControlEvents:UIControlEventValueChanged];
    
    
}


-(void)sliderMoved {
    float a = self.slider.value;
    int b = (int) a;
    self.tipPercentageTextField.text = [NSString stringWithFormat:@"%d", b];
    NSLog(@"Slider at: %d", b);
    [self calculationMethod];
}//sliderMethod


-(void)calculationMethod {
    NSString *enteredAmount = self.billAmountTextField.text;
    [self.tipPercentageTextField resignFirstResponder];
    [self.billAmountTextField resignFirstResponder];
    
    if ([self.tipPercentageTextField.text isEqualToString:@""]) {
        
        float enteredAmountInt = [enteredAmount floatValue];
        if (enteredAmountInt) {
            float returnedAmountFloat = enteredAmountInt * 0.15;
            NSString *returnedAmountString = [NSString stringWithFormat:@"%f", returnedAmountFloat];
            returnedAmountString = [returnedAmountString stringByReplacingOccurrencesOfString:@"0000" withString:@""];
            
            self.tipAmountLabel.text = [NSString stringWithFormat:@"Tip amount is %@ $", returnedAmountString];
            
        } else {
            self.tipAmountLabel.text = @"";
            self.billAmountTextField.text = @"";
        }//if user entered a string instead of an int
    }//if tip percentage textField is ""
    else {
        NSString *enteredAmount = self.billAmountTextField.text;
        float enteredAmountInt = [enteredAmount floatValue];
        if (enteredAmountInt) {
            NSString *enteredTipAmount = self.tipPercentageTextField.text;
            float enteredTipAmountFloat = [enteredTipAmount floatValue];
            if (enteredTipAmountFloat) {
                float returnValue = enteredAmountInt * enteredTipAmountFloat/100.0;
                NSString *returnedAmountString = [NSString stringWithFormat:@"%f", returnValue];
                returnedAmountString = [returnedAmountString stringByReplacingOccurrencesOfString:@"0000" withString:@""];
                self.tipAmountLabel.text = [NSString stringWithFormat:@"Tip amount is %@ $", returnedAmountString];
            }//if tip is float
            else {
                self.tipPercentageTextField.text = @"";
                self.tipAmountLabel.text = @"";
            }
            
            
            
        }//if total dollar value is int
        
        
    }//if user manually entered tip percentage
}//)calculationMethod


@end
