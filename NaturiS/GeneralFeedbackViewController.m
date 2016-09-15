//
//  GeneralFeedbackViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/4/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "GeneralFeedbackViewController.h"
#import "FeedbackViewController.h"

@interface GeneralFeedbackViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *problemSolutionTextView;
@property (weak, nonatomic) IBOutlet UITextView *customerFeedbackTextView;
@property (weak, nonatomic) IBOutlet UIImageView *submitButtonImage;
@property (strong, nonatomic) IBOutletCollection(UITextView) NSArray *allTextViews;
@end

@implementation GeneralFeedbackViewController {
    UITextView *activeTextView;
    BOOL allTextViewsFinished;
}

#pragma mark - ViewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Resume previously submitted data
    // for text
    [self loadPreviousTextData];
    // Assign delegate
    self.problemSolutionTextView.delegate = self;
    self.customerFeedbackTextView.delegate = self;
    // Register keyboard notification
    [self registerForKeyboardNotifications];
    // UITextView Placeholder
    self.problemSolutionTextView.text = @"Q: Any Problem & Your Suggestion?";
    self.problemSolutionTextView.textAlignment = NSTextAlignmentCenter;
    self.customerFeedbackTextView.text = @"Q: Tell us some customer feedback?";
    self.customerFeedbackTextView.textAlignment = NSTextAlignmentCenter;
    // Add left swipe gesture
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeRecognizer:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
    // Add stop editing tap gesture
    UITapGestureRecognizer *tapStopEditingRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self action:@selector(tapStopEditingRecognizer:)];
    [self.view addGestureRecognizer: tapStopEditingRecognizer];
    // Add submit button tap gesture
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSubmitDataRecognizer:)];
    [recognizer setNumberOfTapsRequired:1];
    [self.submitButtonImage setUserInteractionEnabled:YES];
    [self.view bringSubviewToFront:self.submitButtonImage];
    [self.submitButtonImage addGestureRecognizer:recognizer];
}

- (void)loadPreviousTextData {
    // NSURLSession Submit/Resubmit data
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    // NSURL
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginUserName"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://localhost:8080/api/users/userName/%@", userName]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    // Set URL Request
    [urlRequest setURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data != nil) {
            // Convert the returned data into a dictionary.
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"returnedDict: %@", returnedDict);
            // Check if no returnedDict
            if (returnedDict == NULL) {
                NSLog(@"No returnedDict when calling (void)loadPreviousTextData.");
                // Check error
            } else if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
                // No error
            } else {
                // If no error occurs, check the HTTP status code.
                NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                // If it's other than 200, then show it on the console.
                if (HTTPStatusCode != 200) {
                    NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
                }
                NSArray *problemSolution = [returnedDict valueForKeyPath:@"generalFeedback.problemSolution"];
                NSArray *customerFeedback = [returnedDict valueForKeyPath:@"generalFeedback.customerFeedback"];
                // UI update must be in mainQueue
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (problemSolution && problemSolution.count != 0) {
                        self.problemSolutionTextView.text = problemSolution[0];
                    }
                    if (customerFeedback && customerFeedback.count != 0) {
                        self.customerFeedbackTextView.text = customerFeedback[0];
                    }
                }];
            }
        }
    }] resume];
}

#pragma mark - Keyboard & Scroll

- (void)registerForKeyboardNotifications
{
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
    CGRect aPoint = activeTextView.frame;
    aPoint.origin.y += aPoint.size.width;
    NSLog(@"self.view: %@", NSStringFromCGRect(aRect));
    NSLog(@"self.activeTextField: %@", NSStringFromCGRect(aPoint));
    if (!CGRectContainsPoint(aRect, aPoint.origin) ) {
        NSLog(@"Hello");
        [self.scrollView scrollRectToVisible:activeTextView.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    activeTextView = textView;
    if ([textView.text isEqualToString:@"Q: Any Problem & Your Suggestion?"] || [textView.text isEqualToString:@"Q: Tell us some customer feedback?"] || [textView.text isEqualToString:@"Nothing to tell us?"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    activeTextView = nil;
    if ([textView.text isEqualToString:@""]) {
        if (textView.tag == 1) {
            textView.text = @"Q: Any Problem & Your Suggestion?";
        } else {
            textView.text = @"Q: Tell us some customer feedback?";
        }
    }
}


#pragma mark - Gesture

- (void) tapStopEditingRecognizer: (UITapGestureRecognizer *)sender {
    [[self view] endEditing: YES];
}

- (void)tapSubmitDataRecognizer:(UISwipeGestureRecognizer *)sender {
    // Initial value
    allTextViewsFinished = YES;
    //Check textfield
    for (UITextView *textView in self.allTextViews) {
        if (textView.text.length == 0) {
            // Set placeholder and color
            textView.text = @"Nothing to tell us?";
            textView.textColor = [UIColor redColor];
            self.submitButtonImage.image = [UIImage imageNamed:@"WrongSubmit"];
            allTextViewsFinished = NO;
        }
    }
    // Upload text data
    [self uploadTextData];
    // Updata UI
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.submitButtonImage.image = [UIImage imageNamed:@"Correct"];
    }];
}

- (void) uploadTextData {
    // NSURLSession Submit/Resubmit data
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginUserName"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://localhost:8080/api/users/generalFeedbackTextData/%@", userName]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    // "Put" method
    // Request setup
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    // Set params
    NSString *params = [NSString stringWithFormat:@"problemSolution=%@&customerFeedback=%@", self.problemSolutionTextView.text, self.customerFeedbackTextView.text];
    // Set http body
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    // Send dataTaskWithRequest
    [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSLog(@"Successfully submitted text data. No error.");
        } else {
            NSLog(@"Text data Error: %@", [error localizedDescription]);
            // Updata UI
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.submitButtonImage.image = [UIImage imageNamed:@"WrongUser"];
            }];
        }
    }] resume];
}

- (void)leftSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    FeedbackViewController *feedback = [[FeedbackViewController alloc] init];
    feedback = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
    [self.navigationController showViewController:feedback sender:self];
}


#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
