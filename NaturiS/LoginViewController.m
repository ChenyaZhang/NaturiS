//
//  LoginViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/4/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "DemoIntroViewController.h"
#import "NextDemoViewController.h"
#include <CommonCrypto/CommonDigest.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameOrEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *viewInsideScrollView;

@end

@implementation LoginViewController {
    UITextField *activeTextField;
    NSString *dataURL;
    NSString *passwordStoredInDatabase;
    NSString *currentDemo;
    NSString *userName;
}


#pragma mark - View Did Load

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Assign delegate
    self.userNameOrEmailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    // Register keyboard notification
    [self registerForKeyboardNotifications];
    
    // Add stop editing tap gesture
    UITapGestureRecognizer *tapStopEditingRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self action:@selector(tapStopEditingRecognizer:)];
    [self.view addGestureRecognizer: tapStopEditingRecognizer];
    
    // Add login button tap gesture
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSubmitDataRecognizer:)];
    [recognizer setNumberOfTapsRequired:1];
    [self.loginButton setUserInteractionEnabled:YES];
    [self.view bringSubviewToFront:self.loginButton];
    [self.loginButton addGestureRecognizer:recognizer];
    
    // Add left swipe gesture
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeRecognizer:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
}


#pragma mark - Keyboard & Scroll

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    CGRect aPoint = activeTextField.frame;
    aPoint.origin.y += aPoint.size.height;
    
    //    NSLog(@"self.view: %@", NSStringFromCGRect(aRect));
    //    NSLog(@"self.activeTextField: %@", NSStringFromCGRect(aPoint));
    
    if (!CGRectContainsPoint(aRect, aPoint.origin) ) {
        //        NSLog(@"Hello!");
        [self.scrollView scrollRectToVisible:activeTextField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    activeTextField = nil;
}


#pragma mark - Password Hash

- (NSString *) createSHA512:(NSString *)source {
    
    const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    CC_SHA512(keyData.bytes, (int)keyData.length, digest);
    
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    
    // NSLog(@"Password Hash: %@", [out description]);
    return [out description];
}


#pragma mark - Gesture

- (void)tapSubmitDataRecognizer:(UISwipeGestureRecognizer *)sender {
    
    if (_userNameOrEmailTextField.text != NULL) {
        
        if ([_userNameOrEmailTextField.text rangeOfString:@"@"].location == NSNotFound) {
            dataURL = [NSString stringWithFormat: @"http://localhost:8080/api/users/userName/%@", _userNameOrEmailTextField.text];
        } else {
            dataURL = [NSString stringWithFormat: @"http://localhost:8080/api/users/email/%@", _userNameOrEmailTextField.text];
        }
        
        // NSURLSession
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:dataURL]];
        [request setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (data != nil) {
                // Convert the returned data into a dictionary.
                NSError *error;
                NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                // Check if no returnedDict
                if (returnedDict == NULL) {
                    // UI update must be in mainQueue
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        self.loginButton.image = [UIImage imageNamed:@"WrongUser"];
                    }];
                    // Check error
                } else if (error != nil) {
                    NSLog(@"%@", [error localizedDescription]);
                    // UI update must be in mainQueue
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        self.loginButton.image = [UIImage imageNamed:@"WrongUser"];
                    }];
                    // No error
                } else {
                    // If no error occurs, check the HTTP status code.
                    NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                    // If it's other than 200, then show it on the console.
                    if (HTTPStatusCode != 200) {
                        NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
                    }
                    
                    userName = [returnedDict valueForKey:@"userName"];
                    passwordStoredInDatabase = [returnedDict valueForKey:@"password"];
                    currentDemo = [returnedDict valueForKey:@"currentDemo"];
                    
                    // UI update must be in mainQueue
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        if ([passwordStoredInDatabase isEqualToString:[self createSHA512:self.passwordTextField.text]]) {
                            
                            DemoIntroViewController *demoIntro = [[DemoIntroViewController alloc] init];
                            demoIntro = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoIntroViewController"];
                            // "Prepare for segue"
                            demoIntro.currentDemo = currentDemo;
                            demoIntro.userName = userName;
                            
                            [self.navigationController showViewController:demoIntro sender:self];
                            
                        } else {
                            self.loginButton.image = [UIImage imageNamed:@"WrongUser"];
                        }
                    }];
                }
            }
        }] resume];
    }
}

- (void) tapStopEditingRecognizer: (UITapGestureRecognizer *)sender {
    [[self view] endEditing: YES];
}

- (void)leftSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    UIViewController *view = [[ViewController alloc] init];
    view = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController showViewController:view sender:self];
}


#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
