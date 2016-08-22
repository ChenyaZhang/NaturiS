//
//  TravelViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "TravelViewController.h"
#import "TravelIntroViewController.h"
#import "ArriveViewController.h"

@interface TravelViewController ()

@property (weak, nonatomic) IBOutlet UILabel *yourCurrentTime;
@property (weak, nonatomic) IBOutlet UILabel *yourCurrentLocation;
@property (weak, nonatomic) IBOutlet UIImageView *yourCurrentTimeButtonImage;
@property (weak, nonatomic) IBOutlet UIImageView *yourCurrentLocationButtonImage;

@end

@implementation TravelViewController {
    NSTimer *yourCurrentTimeTimer;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    BOOL yourCurrentTimeStart;
    BOOL yourCurrentLocationStart;
}


#pragma mark - View Did Load

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Start time update
    [self startCurrentTimeTimer];
    
    // Start location update
    [self startCurrentLocationUpdate];
    
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
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    _yourCurrentTime.numberOfLines = 2;
    _yourCurrentTime.textAlignment = NSTextAlignmentCenter;
    _yourCurrentTime.text = [NSString stringWithFormat:@"Your Current Time:\n %@", [formatter stringFromDate:currentTime]];
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
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
            _yourCurrentLocation.numberOfLines = 0;
            _yourCurrentLocation.textAlignment = NSTextAlignmentCenter;
            [self.yourCurrentLocation sizeToFit];
            _yourCurrentLocation.text = [NSString stringWithFormat:@"Your Current Address:\n %@\n%@\n%@\n%@",
                                         placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.postalCode];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}


#pragma mark - Gesture

- (void)currentTimeTapRecognizer:(UITapGestureRecognizer *)sender {
    if (yourCurrentTimeStart) {
        // NSURLSession Submit/Resubmit data
        if (self.yourCurrentTime.text != NULL) {
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://localhost:8080/api/users/userName/%@", self.userName]];
            NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
            // "Put" method
            [urlRequest setHTTPMethod:@"PUT"];
            [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            NSString *params = [NSString stringWithFormat:@"startTime=%@", self.yourCurrentTime.text];
            [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
            
            [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                NSLog(@"Response:%@ %@\n", response, error);
                
                if (error == nil) {
                    NSLog(@"Stop your current time timer. No error.");
                    // Stop your current time timer
                    [yourCurrentTimeTimer invalidate];
                    yourCurrentTimeTimer = nil;
                    yourCurrentTimeStart = FALSE;
                } else {
                    NSLog(@"Error: %@", [error localizedDescription]);
                }
                
            }] resume];
        }
        
    } else {
        [self startCurrentTimeTimer];
    }
}

- (void)currentLocationTapRecognizer:(UITapGestureRecognizer *)sender {

    if (yourCurrentLocationStart) {
        
        // NSURLSession Submit/Resubmit data
        if (self.yourCurrentLocation.text != NULL) {
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://localhost:8080/api/users/userName/%@", self.userName]];
            NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
            // "Put" method
            [urlRequest setHTTPMethod:@"PUT"];
            [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            NSString *params = [NSString stringWithFormat:@"startLocation=%@", self.yourCurrentLocation.text];
            [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
            
            [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                NSLog(@"Response:%@ %@\n", response, error);
                
                if (error == nil) {
                    NSLog(@"Stop your current location. No error.");
                    // Stop your current location
                    [locationManager stopUpdatingLocation];
                    locationManager = nil;
                    yourCurrentLocationStart = FALSE;
                } else {
                    NSLog(@"Error: %@", [error localizedDescription]);
                }
                
            }] resume];
            
        }
    } else {
        [self startCurrentLocationUpdate];
    }
}

- (void)rightSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    
    if (yourCurrentTimeStart == FALSE && yourCurrentLocationStart == FALSE) {
        
        if (self.yourCurrentTime.text != NULL && self.yourCurrentLocation.text != NULL) {
            
            ArriveViewController *arrive = [[ArriveViewController alloc] init];
            arrive = [self.storyboard instantiateViewControllerWithIdentifier:@"ArriveViewController"];
            
            arrive.userName = _userName;
            
            [self.navigationController showViewController:arrive sender:self];
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
