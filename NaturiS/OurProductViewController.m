//
//  OurProductViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/4/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "OurProductViewController.h"
#import "CollectViewController.h"

@interface OurProductViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *submitImageButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *firstObservationTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondObservationTextField;
@property (weak, nonatomic) IBOutlet UITextField *thirdObservationTextField;
@property (weak, nonatomic) IBOutlet UIImageView *gift6ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gift7ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gift8ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gift9ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gift10ImageView;
@property (weak, nonatomic) IBOutlet UITextField *lemonQTextField;
@property (weak, nonatomic) IBOutlet UITextField *bberryTextField;
@property (weak, nonatomic) IBOutlet UITextField *vanilaTextField;
@property (weak, nonatomic) IBOutlet UITextField *bananaTextField;
@property (weak, nonatomic) IBOutlet UITextField *sberryTextField;
@property (weak, nonatomic) IBOutlet UITextField *honeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *peachTextField;
@property (weak, nonatomic) IBOutlet UITextField *cherryTextField;
@property (weak, nonatomic) IBOutlet UITextField *plainTextField;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *photoButtons;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *allTextFields;
@property (strong, nonatomic) NSMutableDictionary *allImageSubmitted;
@end

@implementation OurProductViewController {
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
    //[self loadPreviousTextData];    
    // Hide gift images
    self.gift6ImageView.hidden = YES;
    self.gift7ImageView.hidden = YES;
    self.gift8ImageView.hidden = YES;
    self.gift9ImageView.hidden = YES;
    self.gift10ImageView.hidden = YES;
    // Assign delegate
    self.firstObservationTextField.delegate = self;
    self.secondObservationTextField.delegate = self;
    self.thirdObservationTextField.delegate = self;
    self.lemonQTextField.delegate = self;
    self.bberryTextField.delegate = self;
    self.vanilaTextField.delegate = self;
    self.bananaTextField.delegate = self;
    self.sberryTextField.delegate = self;
    self.honeyTextField.delegate = self;
    self.peachTextField.delegate = self;
    self.cherryTextField.delegate = self;
    self.plainTextField.delegate = self;
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
    // Add right swipe gesture
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeRecognizer:)];
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizerRight];
    // Bring buttons to front
    for (UIButton *button in self.photoButtons) {
        [self.view bringSubviewToFront:button];
    }
}

/**- (void)loadPreviousTextData {
    // NSURLSession Submit/Resubmit data
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    // NSURL
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginUserName"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://ec2-54-163-207-173.compute-1.amazonaws.com:8080/api/users/userName/%@", userName]];
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
                NSArray *firstObservation = [returnedDict valueForKeyPath:@"ourProduct.firstObservation"];
                NSArray *secondObservation = [returnedDict valueForKeyPath:@"ourProduct.secondObservation"];
                NSArray *thirdObservation = [returnedDict valueForKeyPath:@"ourProduct.thirdObservation"];
                NSArray *lemonQ = [returnedDict valueForKeyPath:@"ourProduct.lemonQ"];
                NSArray *bananaQ = [returnedDict valueForKeyPath:@"ourProduct.bananaQ"];
                NSArray *peachQ = [returnedDict valueForKeyPath:@"ourProduct.peachQ"];
                NSArray *bBerryQ = [returnedDict valueForKeyPath:@"ourProduct.bBerryQ"];
                NSArray *sBerryQ = [returnedDict valueForKeyPath:@"ourProduct.sBerryQ"];
                NSArray *cherryQ = [returnedDict valueForKeyPath:@"ourProduct.cherryQ"];
                NSArray *vanillaQ = [returnedDict valueForKeyPath:@"ourProduct.vanillaQ"];
                NSArray *honeyQ = [returnedDict valueForKeyPath:@"ourProduct.honeyQ"];
                NSArray *plainQ = [returnedDict valueForKeyPath:@"ourProduct.plainQ"];
                // UI update must be in mainQueue
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (firstObservation && firstObservation.count != 0) {
                        self.firstObservationTextField.text = firstObservation[0];
                    }
                    if (secondObservation && secondObservation.count != 0) {
                        self.secondObservationTextField.text = secondObservation[0];
                    }
                    if (thirdObservation && thirdObservation.count != 0) {
                        self.thirdObservationTextField.text = thirdObservation[0];
                    }
                    if (lemonQ && lemonQ.count != 0) {
                        self.lemonQTextField.text = lemonQ[0];
                    }
                    if (bananaQ && bananaQ.count != 0) {
                        self.bananaTextField.text = bananaQ[0];
                    }
                    if (peachQ && peachQ.count != 0) {
                        self.peachTextField.text = peachQ[0];
                    }
                    if (bBerryQ && bBerryQ.count != 0) {
                        self.bberryTextField.text = bBerryQ[0];
                    }
                    if (sBerryQ && sBerryQ.count != 0) {
                        self.sberryTextField.text = sBerryQ[0];
                    }
                    if (cherryQ && cherryQ.count != 0) {
                        self.cherryTextField.text = cherryQ[0];
                    }
                    if (vanillaQ && vanillaQ.count != 0) {
                        self.vanilaTextField.text = vanillaQ[0];
                    }
                    if (honeyQ && honeyQ.count != 0) {
                        self.honeyTextField.text = honeyQ[0];
                    }
                    if (plainQ && plainQ.count != 0) {
                        self.plainTextField.text = plainQ[0];
                    }
                }];
            }
        }
    }] resume];
}**/


#pragma mark - ViewWillAppear

- (void)viewWillAppear:(BOOL)animated {
    // Gift image appear based on textfield
    if (self.firstObservationTextField.text.length != 0) {
        self.gift6ImageView.hidden = NO;
    } else {
        self.gift6ImageView.hidden = YES;
    }
    if (self.secondObservationTextField.text.length != 0) {
        self.gift7ImageView.hidden = NO;
    } else {
        self.gift7ImageView.hidden = YES;
    }
    if (self.thirdObservationTextField.text.length != 0) {
        self.gift8ImageView.hidden = NO;
    } else {
        self.gift8ImageView.hidden = YES;
    }
    if (self.peachTextField.text.length != 0) {
        self.gift9ImageView.hidden = NO;
    } else {
        self.gift9ImageView.hidden = YES;
    }
    if (self.plainTextField.text.length != 0) {
        self.gift10ImageView.hidden = NO;
    } else {
        self.gift10ImageView.hidden = YES;
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
    // Image appear based on tag
    if (textField.tag == 5 && textField.text.length != 0) {
        self.gift6ImageView.hidden = NO;
    } else if (textField.tag == 5 && textField.text.length == 0) {
        self.gift6ImageView.hidden = YES;
    }
    if (textField.tag == 6 && textField.text.length != 0) {
        self.gift7ImageView.hidden = NO;
    } else if (textField.tag == 6 && textField.text.length == 0) {
        self.gift7ImageView.hidden = YES;
    }
    if (textField.tag == 7 && textField.text.length != 0) {
        self.gift8ImageView.hidden = NO;
    } else if (textField.tag == 7 && textField.text.length == 0) {
        self.gift8ImageView.hidden = YES;
    }
    if (textField.tag == 8 && textField.text.length != 0) {
        self.gift9ImageView.hidden = NO;
    } else if (textField.tag == 8 && textField.text.length == 0) {
        self.gift9ImageView.hidden = YES;
    }
    if (textField.tag == 9 && textField.text.length != 0) {
        self.gift10ImageView.hidden = NO;
    } else if (textField.tag == 9 && textField.text.length == 0) {
        self.gift10ImageView.hidden = YES;
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
            textField.placeholder = @"Please?";
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
    if (allTextFieldsFinished && allPhotosUploadFinished) {
        self.submitImageButton.image = [UIImage imageNamed:@"Correct"];
        // UIAlertController action sheet
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        // UIAlertController action button
        UIAlertAction *submitActionButton = [UIAlertAction actionWithTitle:@"Confirm Submission" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // Store status
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"OurProductDataSubmitted"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // Upload text data
            [self uploadTextData];
            // Upload photo data
            [self uploadPhotoData];
            // Updata UI
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                for (UITextField *textField in self.allTextFields) {
                    [textField setUserInteractionEnabled:NO];
                }
                for (UIButton *photoButton in self.photoButtons) {
                    photoButton.enabled = NO;
                }
            }];
        }];
        // Add action to action sheet
        [actionSheet addAction:submitActionButton];
        // Present action sheet
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}

- (void) uploadTextData {
    // NSURLSession Submit/Resubmit data
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginUserName"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://ec2-54-163-207-173.compute-1.amazonaws.com:8080/api/users/ourProductTextData/%@", userName]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    // "Put" method
    // Request setup
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    // Set params
    NSString *params = [NSString stringWithFormat:@"firstObservation=%@&secondObservation=%@&thirdObservation=%@&lemonQ=%@&bananaQ=%@&peachQ=%@&bBerryQ=%@&sBerryQ=%@&cherryQ=%@&vanillaQ=%@&honeyQ=%@&plainQ=%@", self.firstObservationTextField.text, self.secondObservationTextField.text, self.thirdObservationTextField.text, self.lemonQTextField.text, self.bananaTextField.text, self.peachTextField.text, self.bberryTextField.text, self.sberryTextField.text, self.cherryTextField.text, self.vanilaTextField.text, self.honeyTextField.text, self.plainTextField.text];
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
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginUserName"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://ec2-54-163-207-173.compute-1.amazonaws.com:8080/api/users/ourProductPhotoData/%@", userName]];
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

- (void)rightSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    NSString *submitOurData = [[NSUserDefaults standardUserDefaults] valueForKey:@"OurProductDataSubmitted"];
    // Check data submission
    if ([submitOurData isEqualToString:@"1"]) {
        CollectViewController *collect = [[CollectViewController alloc] init];
        collect = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectViewController"];
        [self.navigationController showViewController:collect sender:self];
    } else {
        // UIAlertController action sheet
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"YOUR DATA WILL NOT BE SAVED IF NOT SUBMITTED." preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        // UIAlertController action button
        UIAlertAction *discardActionButton = [UIAlertAction actionWithTitle:@"Discard All" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            CollectViewController *collect = [[CollectViewController alloc] init];
            collect = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectViewController"];
            [self.navigationController showViewController:collect sender:self];
        }];
        // Add action to action sheet
        [actionSheet addAction:discardActionButton];
        // Present action sheet
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
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
