//
//  LeaveViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "LeaveViewController.h"
#import "LeaveIntroViewController.h"
#import "NextDemoViewController.h"

@interface LeaveViewController ()

@property (weak, nonatomic) IBOutlet UILabel *yourCurrentTime;
@property (weak, nonatomic) IBOutlet UILabel *yourCurrentLocation;
@property (weak, nonatomic) IBOutlet UIImageView *yourCurrentTimeButtonImage;
@property (weak, nonatomic) IBOutlet UIImageView *yourCurrentLocationButtonImage;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeContent;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationContent;

@end

@implementation LeaveViewController {
    NSTimer *yourCurrentTimeTimer;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    BOOL yourCurrentTimeStart;
    BOOL yourCurrentLocationStart;
    NSString *nextDemo;
}


#pragma mark - View Did Load

- (void)viewDidLoad {
    [super viewDidLoad];
    // Start time update
    [self startCurrentTimeTimer];
    // Start location update
    [self startCurrentLocationUpdate];
    // Get Next Demo Info
    [self getNextDemoInfo];
    // Add tap gesture for Your Current Time
    UITapGestureRecognizer *currentTimeTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(currentTimeTapRecognizer:)];
    [currentTimeTapRecognizer setNumberOfTapsRequired:1];
    [self.yourCurrentTimeButtonImage setUserInteractionEnabled:YES];
    [self.view bringSubviewToFront:self.yourCurrentTimeButtonImage];
    [self.yourCurrentTimeButtonImage addGestureRecognizer:currentTimeTapRecognizer];
    // Add tap gesture for Your Current Location
    UITapGestureRecognizer *currentLocationTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(currentLocationTapRecognizer:)];
    [currentLocationTapRecognizer setNumberOfTapsRequired:1];
    [self.yourCurrentLocationButtonImage setUserInteractionEnabled:YES];
    [self.view bringSubviewToFront:self.yourCurrentLocationButtonImage];
    [self.yourCurrentLocationButtonImage addGestureRecognizer:currentLocationTapRecognizer];
    // Add right swipe gesture
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeRecognizer:)];
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizerRight];
}


#pragma mark - Current Time Function

- (void) startCurrentTimeTimer {
    yourCurrentTimeTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                            target: self
                                                          selector:@selector(updateYourCurrentTime:)
                                                          userInfo: nil repeats:YES];
    [yourCurrentTimeTimer fire];
    yourCurrentTimeStart = TRUE;
}

- (void)updateYourCurrentTime: (NSTimer *)timer {
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM-dd hh:mm a"];
    // Display text
    // NSAttributed String
    NSString *currentTimeString = @"Current Time";
    NSMutableAttributedString *currentTimeAttributedString =[[NSMutableAttributedString alloc] initWithString: currentTimeString];
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    [currentTimeAttributedString addAttribute:NSFontAttributeName
                                        value:font
                                        range:NSMakeRange(0, [currentTimeString length])];
    self.yourCurrentTime.attributedText = currentTimeAttributedString;
    self.yourCurrentTime.numberOfLines = 0;
    self.yourCurrentTime.textAlignment = NSTextAlignmentCenter;
    self.currentTimeContent.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:currentTime]];
    self.currentTimeContent.numberOfLines = 0;
    self.currentTimeContent.textAlignment = NSTextAlignmentCenter;
}


#pragma mark - Current Location Function

- (void) startCurrentLocationUpdate {
    // Initialize location manager
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // Location authorization
    [locationManager requestWhenInUseAuthorization];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    yourCurrentLocationStart = TRUE;
    // Initialize geocoder
    geocoder = [[CLGeocoder alloc] init];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"Failed to Get Your Location" preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
        NSLog(@"currentLocation.coordinate.longitude: %@", [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
        NSLog(@"currentLocation.coordinate.latitude: %@", [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
    }
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            // Display text
            // NSAttributed String
            NSString *currentLocationString = @"Current Location";
            NSMutableAttributedString *currentLocationAttributedString =[[NSMutableAttributedString alloc] initWithString: currentLocationString];
            UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            [currentLocationAttributedString addAttribute:NSFontAttributeName
                                                    value:font
                                                    range:NSMakeRange(0, [currentLocationString length])];
            
            self.yourCurrentLocation.attributedText = currentLocationAttributedString;
            self.yourCurrentLocation.numberOfLines = 0;
            self.yourCurrentLocation.textAlignment = NSTextAlignmentCenter;
            self.currentLocationContent.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
                                                placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.postalCode];
            self.currentLocationContent.numberOfLines = 0;
            self.currentLocationContent.textAlignment = NSTextAlignmentCenter;
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}


#pragma mark - Get Next Demo

- (void)getNextDemoInfo {
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginUserName"];
    NSString *dataURL = [NSString stringWithFormat: @"http://localhost:8080/api/users/userName/%@", userName];
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
                NSLog(@"No user info found!");
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
                nextDemo = [returnedDict valueForKey:@"nextDemo"];
            }
        }
    }] resume];
}


#pragma mark - Gesture

- (void)currentTimeTapRecognizer:(UITapGestureRecognizer *)sender {
    if (yourCurrentTimeStart) {
        // NSURLSession Submit/Resubmit data
        if (self.yourCurrentTime.text != NULL) {
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginUserName"];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://localhost:8080/api/users/userName/%@", userName]];
            NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
            // "Put" method
            [urlRequest setHTTPMethod:@"PUT"];
            [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            NSString *params = [NSString stringWithFormat:@"leaveTime=%@", self.currentTimeContent.text];
            [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
            [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSLog(@"Response:%@ %@\n", response, error);
                if (error == nil) {
                    NSLog(@"Stop your current time timer. No error.");
                    // Stop your current time timer
                    [yourCurrentTimeTimer invalidate];
                    yourCurrentTimeTimer = nil;
                    yourCurrentTimeStart = FALSE;
                    // Update UI in main queue
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        self.yourCurrentTimeButtonImage.image = [UIImage imageNamed:@"Correct"];
                    }];
                } else {
                    NSLog(@"Error: %@", [error localizedDescription]);
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        self.yourCurrentTimeButtonImage.image = [UIImage imageNamed:@"WrongUser"];
                    }];
                }
                
            }] resume];
        }
        
    } else {
        [self startCurrentTimeTimer];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.yourCurrentTimeButtonImage.image = [UIImage imageNamed:@"Button2"];
        }];
    }
}

- (void)currentLocationTapRecognizer:(UITapGestureRecognizer *)sender {
    
    if (yourCurrentLocationStart) {
        // NSURLSession Submit/Resubmit data
        if (self.yourCurrentLocation.text != NULL) {
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginUserName"];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://localhost:8080/api/users/userName/%@", userName]];
            NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
            // "Put" method
            [urlRequest setHTTPMethod:@"PUT"];
            [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            NSString *params = [NSString stringWithFormat:@"leaveLocation=%@", self.currentLocationContent.text];
            [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
            [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSLog(@"Response:%@ %@\n", response, error);
                if (error == nil) {
                    NSLog(@"Stop your current location. No error.");
                    // Stop your current location
                    [locationManager stopUpdatingLocation];
                    locationManager = nil;
                    yourCurrentLocationStart = FALSE;
                    // Update UI in main queue
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        self.yourCurrentLocationButtonImage.image = [UIImage imageNamed:@"Correct"];
                    }];
                } else {
                    NSLog(@"Error: %@", [error localizedDescription]);
                    // Update UI in main queue
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        self.yourCurrentLocationButtonImage.image = [UIImage imageNamed:@"WrongUser"];
                    }];
                }
                
            }] resume];
            
        }
    } else {
        [self startCurrentLocationUpdate];
        // Update UI in main queue
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.yourCurrentLocationButtonImage.image = [UIImage imageNamed:@"Button2"];
        }];
    }
}

- (void)rightSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    if (yourCurrentTimeStart == FALSE && yourCurrentLocationStart == FALSE) {
        if (self.yourCurrentTime.text != NULL && self.yourCurrentLocation.text != NULL) {
            NextDemoViewController *nextDemoVC = [[NextDemoViewController alloc] init];
            nextDemoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NextDemoViewController"];
            nextDemoVC.nextDemo = nextDemo;
            [self.navigationController showViewController:nextDemoVC sender:self];
        }
        
    }
}


#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
