//
//  CompetitorAnalysisViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/4/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "CompetitorAnalysisViewController.h"
#import "CollectViewController.h"

@interface CompetitorAnalysisViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *submitImageButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *firstObservationTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondObservationTextField;
@property (weak, nonatomic) IBOutlet UITextField *thirdObservationTextField;
@property (weak, nonatomic) IBOutlet UITextField *brandNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *productCategoryTextField;
@property (weak, nonatomic) IBOutlet UIImageView *gift1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gift2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gift3ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gift4ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gift5ImageView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *photoButtons;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *allTextFields;
@end

@implementation CompetitorAnalysisViewController {
    NSInteger pressedButtonTagNumber;
    UITextField *activeTextField;
    BOOL allTextFieldsFinished;
    BOOL allPhotosUploadFinished;
}

#pragma mark - ViewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Resume previously submitted data
    // for text
    self.firstObservationTextField.text = self.firstObservation;
    self.secondObservationTextField.text = self.secondObservation;
    self.thirdObservationTextField.text = self.thirdObservation;
    self.brandNameTextField.text = self.brandName;
    self.productCategoryTextField.text = self.productCategory;
    // for photo
    if (!self.allImageSubmitted) {
        self.allImageSubmitted = [[NSMutableDictionary alloc] init];
    }
    for (UIButton *photoButton in self.photoButtons) {
        [photoButton setImage:[UIImage imageNamed:@"Camera"] forState:UIControlStateNormal];
    }
    if (self.allImageSubmitted.count != 0) {
        for (int i = 0; i < self.allImageSubmitted.count; i++) {
            NSString *key = [NSString stringWithFormat:@"photo%d", i + 1];
            [[self.photoButtons objectAtIndex:i] setImage:[self.allImageSubmitted objectForKey:key] forState:UIControlStateNormal];
        }
    }
    // Hide gift images
    self.gift1ImageView.hidden = YES;
    self.gift2ImageView.hidden = YES;
    self.gift3ImageView.hidden = YES;
    self.gift4ImageView.hidden = YES;
    self.gift5ImageView.hidden = YES;
    // Assign delegate
    self.firstObservationTextField.delegate = self;
    self.secondObservationTextField.delegate = self;
    self.thirdObservationTextField.delegate = self;
    self.brandNameTextField.delegate = self;
    self.productCategoryTextField.delegate = self;
    // Register keyboard notification
    [self registerForKeyboardNotifications];
    // Add stop editing tap gesture
    UITapGestureRecognizer *tapStopEditingRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self action:@selector(tapStopEditingRecognizer:)];
    [self.view addGestureRecognizer: tapStopEditingRecognizer];
    // Add submit button tap gesture
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSubmitDataRecognizer:)];
    [recognizer setNumberOfTapsRequired:1];
    [self.submitImageButton setUserInteractionEnabled:YES];
    [self.view bringSubviewToFront:self.submitImageButton];
    [self.submitImageButton addGestureRecognizer:recognizer];
    // Add left swipe gesture
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeRecognizer:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
}


#pragma mark - ViewWillAppear

- (void)viewWillAppear:(BOOL)animated {
    // Gift image appear based on textfield
    if (self.firstObservationTextField.text.length != 0) {
        self.gift1ImageView.hidden = NO;
    } else {
        self.gift1ImageView.hidden = YES;
    }
    if (self.secondObservationTextField.text.length != 0) {
        self.gift2ImageView.hidden = NO;
    } else {
        self.gift2ImageView.hidden = YES;
    }
    if (self.thirdObservationTextField.text.length != 0) {
        self.gift3ImageView.hidden = NO;
    } else {
        self.gift3ImageView.hidden = YES;
    }
    if (self.brandNameTextField.text.length != 0) {
        self.gift4ImageView.hidden = NO;
    } else {
        self.gift4ImageView.hidden = YES;
    }
    if (self.productCategoryTextField.text.length != 0) {
        self.gift5ImageView.hidden = NO;
    } else {
        self.gift5ImageView.hidden = YES;
    }
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
    // Image appear based on tag
    if (textField.tag == 5 && textField.text.length != 0) {
        self.gift1ImageView.hidden = NO;
    } else if (textField.tag == 5 && textField.text.length == 0) {
        self.gift1ImageView.hidden = YES;
    }
    if (textField.tag == 6 && textField.text.length != 0) {
        self.gift2ImageView.hidden = NO;
    } else if (textField.tag == 6 && textField.text.length == 0) {
        self.gift2ImageView.hidden = YES;
    }
    if (textField.tag == 7 && textField.text.length != 0) {
        self.gift3ImageView.hidden = NO;
    } else if (textField.tag == 7 && textField.text.length == 0) {
        self.gift3ImageView.hidden = YES;
    }
    if (textField.tag == 8 && textField.text.length != 0) {
        self.gift4ImageView.hidden = NO;
    } else if (textField.tag == 8 && textField.text.length == 0) {
        self.gift4ImageView.hidden = YES;
    }
    if (textField.tag == 9 && textField.text.length != 0) {
        self.gift5ImageView.hidden = NO;
    } else if (textField.tag == 9 && textField.text.length == 0) {
        self.gift5ImageView.hidden = YES;
    }
}


#pragma mark - Choose Photo

- (IBAction)choosePhotoButtonPressed:(UIButton *)sender {
    pressedButtonTagNumber = sender.tag;
    // UIAlertController action sheet
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    // UIAlertController action button
    UIAlertAction *takePhotoActionButton = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePhoto];
    }];
    UIAlertAction *uploadPhotoActionButton = [UIAlertAction actionWithTitle:@"Upload from Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self uploadPhoto];
    }];
    // Disable take a photo button if source not available
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [takePhotoActionButton setEnabled:NO];
    }
    // Disable upload a photo button if source not available
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [uploadPhotoActionButton setEnabled:NO];
    }
    // Add action to action sheet
    [actionSheet addAction:takePhotoActionButton];
    [actionSheet addAction:uploadPhotoActionButton];
    // Present action sheet
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)takePhoto {
    // Take Photo button tapped
    // Initialize UIImagePickerController
    UIImagePickerController *takePhotoImagePickerController = [[UIImagePickerController alloc] init];            takePhotoImagePickerController.delegate = self;
    takePhotoImagePickerController.allowsEditing = YES;
    
    takePhotoImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    // Present UIImagePickerController
    [self presentViewController:takePhotoImagePickerController animated:YES completion:NULL];
}

- (void)uploadPhoto {
    // Upload Photo button tapped
    // Initialize UIImagePickerController
    UIImagePickerController *uploadPhotoImagePickerController = [[UIImagePickerController alloc] init];            uploadPhotoImagePickerController.delegate = self;
    uploadPhotoImagePickerController.allowsEditing = YES;
    uploadPhotoImagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // Present UIImagePickerController
    [self presentViewController:uploadPhotoImagePickerController animated:YES completion:NULL];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Find the button pressed with tag
    UIButton *choosePhotoButton = (UIButton *)[self.view viewWithTag:pressedButtonTagNumber];
    // Get the image picked
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    // Create a reference ImageView
    UIImageView *referenceImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135, 135)];
    // Round the image
    UIImage *roundedChosenImage = [self getRoundedRectImageFromImage:chosenImage onReferenceView:referenceImageView withCornerRadius: referenceImageView.frame.size.width/2];
    // Set button image
    [choosePhotoButton setImage:roundedChosenImage forState:UIControlStateNormal];
    // add to image array for reappear
    NSString *key = [NSString stringWithFormat:@"photo%ld", (long)pressedButtonTagNumber];
    [self.allImageSubmitted setObject:roundedChosenImage forKey:key];
    NSLog(@"!!!!!!!!self.allImageSubmitted.count: %lu", (unsigned long)self.allImageSubmitted.count);
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage *)getRoundedRectImageFromImage :(UIImage *)image onReferenceView :(UIImageView*)imageView withCornerRadius :(float)cornerRadius
{
    
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius] addClip];
    [image drawInRect:imageView.bounds];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}


#pragma mark - Gesture

- (void)tapSubmitDataRecognizer:(UISwipeGestureRecognizer *)sender {
    // Initial value
    allTextFieldsFinished = YES;
    allPhotosUploadFinished = YES;
    //Check textfield
    for (UITextField *textField in self.allTextFields) {
        if (textField.text.length == 0) {
            // Set placeholder and color
            textField.placeholder = @"Tell Us Something?";
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
            self.submitImageButton.image = [UIImage imageNamed:@"WrongSubmit"];
            allTextFieldsFinished = NO;
        }
    }
    // Check photo
    for (UIButton *button in self.photoButtons) {
        // Image Comparison
        UIImage *buttonImage = [button imageForState:UIControlStateNormal];
        UIImage *cameraImage = [UIImage imageNamed:@"Camera"];
        UIImage *noPicImage = [UIImage imageNamed:@"NoPic"];
        if ([UIImagePNGRepresentation(buttonImage) isEqualToData:UIImagePNGRepresentation(cameraImage)] || [UIImagePNGRepresentation(buttonImage) isEqualToData:UIImagePNGRepresentation(noPicImage)]) {
            [button setImage:[UIImage imageNamed:@"NoPic"] forState:UIControlStateNormal];
            self.submitImageButton.image = [UIImage imageNamed:@"WrongSubmit"];
            allPhotosUploadFinished = NO;
        }
    }
    // Check data submission
    if (allTextFieldsFinished && allPhotosUploadFinished) {
        // Disable text field and photo upload
        self.firstObservationTextField.enabled = NO;
        self.secondObservationTextField.enabled = NO;
        self.thirdObservationTextField.enabled = NO;
        self.brandNameTextField.enabled = NO;
        self.productCategoryTextField.enabled = NO;
        for (UIButton *button in self.photoButtons) {
            button.enabled = NO;
        }
        // Upload text data
        [self uploadTextData];
        // Upload photo data
        [self uploadPhotoData];
        // Updata UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.submitImageButton.image = [UIImage imageNamed:@"Correct"];
        }];
        self.submitImageButton.userInteractionEnabled = NO;
        self.alreadySubmitted = YES;
    }
}

- (void) uploadTextData {
    // NSURLSession Submit/Resubmit data
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://localhost:8080/api/users/competitorProductTextData/%@", self.userName]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    // "Put" method
    // Request setup
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    // Set params
    NSString *params = [NSString stringWithFormat:@"firstObservation=%@&secondObservation=%@&thirdObservation=%@&brandName=%@&productCategory=%@", self.firstObservationTextField.text, self.secondObservationTextField.text, self.thirdObservationTextField.text, self.brandNameTextField.text, self.productCategoryTextField.text];
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
                self.submitImageButton.image = [UIImage imageNamed:@"WrongUser"];
            }];
        }
    }] resume];
}

- (void) uploadPhotoData {
    // NSURLSession Submit/Resubmit data
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    // NSURL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://localhost:8080/api/users/competitorProductPhotoData/%@", self.userName]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    // "Put" method
    // Request setup
    // [urlRequest setHTTPMethod:@"PUT"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    //    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    //    [urlRequest setHTTPShouldHandleCookies:NO];
    //    [urlRequest setTimeoutInterval:3000];
    // Set boundary and content type (boundary is a random String)
    NSString *boundaryConstant = [NSString stringWithFormat:@"---------------------------14737809831464368775746641449"];
    NSString* fileParamConstant = @"photo";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundaryConstant];
    [urlRequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
    // Image data array
    NSMutableArray *allImgData = [[NSMutableArray alloc] init];
    for (UIButton *photoButton in self.photoButtons) {
        UIImage *buttonImage = [photoButton imageForState:UIControlStateNormal];
        NSData *imgData = UIImagePNGRepresentation(buttonImage);
        // add to image data array for upload
        [allImgData addObject:imgData];
    }
    // Append image data to body data
    NSMutableData *bodyData = [NSMutableData data];
    int i = 1;
    for (NSData *imgData in allImgData) {
        [bodyData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@%d.png\"\r\n", fileParamConstant, i] dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:imgData];
        [bodyData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        i++;
    }
    // Append one last boundary
    [bodyData appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [urlRequest setHTTPBody:bodyData];
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[bodyData length]];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    // Start session task
    NSURLSessionUploadTask* task = [session uploadTaskWithRequest:urlRequest fromData:bodyData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil && [(NSHTTPURLResponse*)response statusCode] < 300) {
            if (error == nil) {
                NSLog(@"Successfully submitted photo data. No error.");
            } else {
                NSLog(@"Photo data Error: %@", [error localizedDescription]);
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.submitImageButton.image = [UIImage imageNamed:@"WrongUser"];
                }];
            }
        }
    }];
    [task resume];
}

- (void) tapStopEditingRecognizer: (UITapGestureRecognizer *)sender {
    [[self view] endEditing: YES];
}

- (void)leftSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    // Navigation
    CollectViewController *collect = [[CollectViewController alloc] init];
    collect = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectViewController"];
    collect.userName = _userName;
    collect.competitorAnalysisFirstObservation = self.firstObservationTextField.text;
    collect.competitorAnalysisSecondObservation = self.secondObservationTextField.text;
    collect.competitorAnalysisThirdObservation = self.thirdObservationTextField.text;
    collect.competitorAnalysisBrandName = self.brandNameTextField.text;
    collect.competitorAnalysisProductCategory = self.productCategoryTextField.text;
    collect.competitorAnalysisPhotoSubmitted = self.allImageSubmitted;
    collect.competitorAnalysisAlreadySubmitted = self.alreadySubmitted;
    [self.navigationController showViewController:collect sender:self];
}


#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
