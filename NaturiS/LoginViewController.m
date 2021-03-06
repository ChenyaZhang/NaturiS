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
}


#pragma mark - View Did Load

- (void)viewDidLoad {
    [super viewDidLoad];
    // Check Launch Date
    NSDate *firstLaunchDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLaunchDate"];
    //  If this is the first time the app has been launched we record right now as the first time the app was launched.
    if (!firstLaunchDate) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"FirstLaunchDate"];
        return;
    }
    NSTimeInterval diff = fabs([firstLaunchDate timeIntervalSinceNow]);
    if (diff > 60 * 60 * 24 * 1) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginUserName"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"FirstLaunchDate"];
    }
    // Resume user data
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginUserName"];
    if (userName != NULL || userName.length != 0) {
        self.userNameOrEmailTextField.text = userName;
    }
    // Clear previous user data
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"CompetitorProductDataSubmitted"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"OurProductDataSubmitted"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"SpecificQuestionDataSubmitted"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"GeneralFeedbackDataSubmitted"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
            dataURL = [NSString stringWithFormat: @"http://ec2-54-163-207-173.compute-1.amazonaws.com:8080/api/users/userName/%@", _userNameOrEmailTextField.text];
        } else {
            dataURL = [NSString stringWithFormat: @"http://ec2-54-163-207-173.compute-1.amazonaws.com:8080/api/users/email/%@", _userNameOrEmailTextField.text];
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
                    NSString *userName = [returnedDict valueForKey:@"userName"];
                    passwordStoredInDatabase = [returnedDict valueForKey:@"password"];
                    currentDemo = [returnedDict valueForKey:@"currentDemo"];
                    // UI update must be in mainQueue
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        if ([passwordStoredInDatabase isEqualToString:[self createSHA512:self.passwordTextField.text]]) {
                            DemoIntroViewController *demoIntro = [[DemoIntroViewController alloc] init];
                            demoIntro = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoIntroViewController"];
                            // Store user name
                            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"LoginUserName"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            // "Prepare for segue"
                            demoIntro.currentDemo = currentDemo;
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


#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
