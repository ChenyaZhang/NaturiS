//
//  ArriveViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "ArriveViewController.h"
#import "TravelViewController.h"
#import "CollectIntroViewController.h"

@interface ArriveViewController ()

@property (weak, nonatomic) IBOutlet UILabel *yourArrivingTime;
@property (weak, nonatomic) IBOutlet UILabel *yourArrivingLocation;
@property (weak, nonatomic) IBOutlet UIImageView *yourArrivingTimeButtonImage;
@property (weak, nonatomic) IBOutlet UIImageView *yourArrivingLocationButtonImage;
@property (weak, nonatomic) IBOutlet UILabel *arrivingTimeContent;
@property (weak, nonatomic) IBOutlet UILabel *arrivingLocationContent;
@end

@implementation ArriveViewController {
    NSTimer *yourArrivingTimeTimer;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    BOOL yourArrivingTimeStart;
    BOOL yourArrivingLocationStart;
}


#pragma mark - View Did Load

- (void)viewDidLoad {
    [super viewDidLoad];
    // Start time update
    [self startArrivingTimeTimer];
    // Start location update
    [self startArrivingLocationUpdate];
    // Add tap gesture for Your Arriving Time
    UITapGestureRecognizer *arrivingTimeTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrivingTimeTapRecognizer:)];
    [arrivingTimeTapRecognizer setNumberOfTapsRequired:1];
    [self.yourArrivingTimeButtonImage setUserInteractionEnabled:YES];
    [self.view bringSubviewToFront:self.yourArrivingTimeButtonImage];
    [self.yourArrivingTimeButtonImage addGestureRecognizer:arrivingTimeTapRecognizer];
    // Add tap gesture for Your Arriving Location
    UITapGestureRecognizer *arrivingLocationTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrivingLocationTapRecognizer:)];
    [arrivingLocationTapRecognizer setNumberOfTapsRequired:1];
    [self.yourArrivingLocationButtonImage setUserInteractionEnabled:YES];
    [self.view bringSubviewToFront:self.yourArrivingLocationButtonImage];
    [self.yourArrivingLocationButtonImage addGestureRecognizer:arrivingLocationTapRecognizer];
    // Add right swipe gesture
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeRecognizer:)];
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizerRight];
}


#pragma mark - Arriving Time Function

- (void) startArrivingTimeTimer {
    yourArrivingTimeTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                            target: self
                                                          selector:@selector(updateYourArrivingTime:)
                                                          userInfo: nil repeats:YES];
    [yourArrivingTimeTimer fire];
    yourArrivingTimeStart = TRUE;
}

- (void)updateYourArrivingTime: (NSTimer *)timer {
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
    self.yourArrivingTime.attributedText = currentTimeAttributedString;
    self.yourArrivingTime.numberOfLines = 0;
    self.yourArrivingTime.textAlignment = NSTextAlignmentCenter;
    self.arrivingTimeContent.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:currentTime]];
    self.arrivingTimeContent.numberOfLines = 0;
    self.arrivingTimeContent.textAlignment = NSTextAlignmentCenter;
}


#pragma mark - Arriving Location Function

- (void) startArrivingLocationUpdate {
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
    yourArrivingLocationStart = TRUE;
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
            self.yourArrivingLocation.attributedText = currentLocationAttributedString;
            self.yourArrivingLocation.numberOfLines = 0;
            self.yourArrivingLocation.textAlignment = NSTextAlignmentCenter;
            self.arrivingLocationContent.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
                                                placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.postalCode];
            self.arrivingLocationContent.numberOfLines = 0;
            self.arrivingLocationContent.textAlignment = NSTextAlignmentCenter;
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}


#pragma mark - Gesture

- (void)arrivingTimeTapRecognizer:(UITapGestureRecognizer *)sender {
    if (yourArrivingTimeStart) {
        // NSURLSession Submit/Resubmit data
        if (self.yourArrivingTime.text != NULL) {
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginUserName"];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://localhost:8080/api/users/userName/%@", userName]];
            NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
            // "Put" method
            [urlRequest setHTTPMethod:@"PUT"];
            [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            NSString *params = [NSString stringWithFormat:@"arriveTime=%@", self.arrivingTimeContent.text];
            [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
            [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSLog(@"Response:%@ %@\n", response, error);
                if (error == nil) {
                    NSLog(@"Stop your arrive time timer. No error.");
                    // Stop your current time timer
                    [yourArrivingTimeTimer invalidate];
                    yourArrivingTimeTimer = nil;
                    yourArrivingTimeStart = FALSE;
                    // Update UI in main queue
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        self.yourArrivingTimeButtonImage.image = [UIImage imageNamed:@"Correct"];
                    }];
                } else {
                    NSLog(@"Error: %@", [error localizedDescription]);
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        self.yourArrivingTimeButtonImage.image = [UIImage imageNamed:@"WrongUser"];
                    }];
                }
            }] resume];
        }
        
    } else {
        [self startArrivingTimeTimer];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.yourArrivingTimeButtonImage.image = [UIImage imageNamed:@"Button2"];
        }];
    }
}

- (void)arrivingLocationTapRecognizer:(UITapGestureRecognizer *)sender {
    if (yourArrivingLocationStart) {
        // NSURLSession Submit/Resubmit data
        if (self.yourArrivingLocation.text != NULL) {
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginUserName"];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://localhost:8080/api/users/userName/%@", userName]];
            NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
            // "Put" method
            [urlRequest setHTTPMethod:@"PUT"];
            [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            NSString *params = [NSString stringWithFormat:@"arriveLocation=%@", self.arrivingLocationContent.text];
            [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
            [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSLog(@"Response:%@ %@\n", response, error);
                if (error == nil) {
                    NSLog(@"Stop your current location. No error.");
                    // Stop your current location
                    [locationManager stopUpdatingLocation];
                    locationManager = nil;
                    yourArrivingLocationStart = FALSE;
                    // Update UI in main queue
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        self.yourArrivingLocationButtonImage.image = [UIImage imageNamed:@"Correct"];
                    }];
                } else {
                    NSLog(@"Error: %@", [error localizedDescription]);
                    // Update UI in main queue
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        self.yourArrivingLocationButtonImage.image = [UIImage imageNamed:@"WrongUser"];
                    }];
                }
            }] resume];
            
        }
    } else {
        [self startArrivingLocationUpdate];
        // Update UI in main queue
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.yourArrivingLocationButtonImage.image = [UIImage imageNamed:@"Button2"];
        }];
    }
}

- (void)rightSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    if (yourArrivingTimeStart == FALSE && yourArrivingLocationStart == FALSE) {
        if (self.yourArrivingTime.text != NULL && self.yourArrivingLocation.text != NULL) {
            CollectIntroViewController *collectIntro = [[CollectIntroViewController alloc] init];
            collectIntro = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectIntroViewController"];            
            [self.navigationController showViewController:collectIntro sender:self];
        }
        
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
