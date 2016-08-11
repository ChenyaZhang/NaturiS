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

@end

@implementation LeaveViewController {
    NSTimer *yourCurrentTimeTimer;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    BOOL yourCurrentTimeStart;
    BOOL yourCurrentLocationStart;
}

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
    
    // Add left swipe gesture
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeRecognizer:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
}

- (void) startCurrentTimeTimer {
    yourCurrentTimeTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                            target: self
                                                          selector:@selector(updateYourCurrentTime:)
                                                          userInfo: nil repeats:YES];
    [yourCurrentTimeTimer fire];
    yourCurrentTimeStart = TRUE;
}

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
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
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
            _yourCurrentLocation.text = [NSString stringWithFormat:@"Your Current Address:\n %@ %@\n%@ %@",
                                         placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.postalCode];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

- (void)updateYourCurrentTime: (NSTimer *)timer {
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    _yourCurrentTime.numberOfLines = 2;
    _yourCurrentTime.textAlignment = NSTextAlignmentCenter;
    _yourCurrentTime.text = [NSString stringWithFormat:@"Your Current Time:\n %@", [formatter stringFromDate:currentTime]];
}

- (void)currentTimeTapRecognizer:(UITapGestureRecognizer *)sender {
    if (yourCurrentTimeStart) {
        [yourCurrentTimeTimer invalidate];
        yourCurrentTimeTimer = nil;
        yourCurrentTimeStart = FALSE;
    } else {
        [self startCurrentTimeTimer];
    }
}

- (void)currentLocationTapRecognizer:(UITapGestureRecognizer *)sender {
    if (yourCurrentLocationStart) {
        [locationManager stopUpdatingLocation];
        locationManager = nil;
        yourCurrentLocationStart = FALSE;
    } else {
        [self startCurrentLocationUpdate];
    }
}

- (void)rightSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    UIViewController *nextDemo = [[NextDemoViewController alloc] init];
    nextDemo = [self.storyboard instantiateViewControllerWithIdentifier:@"NextDemoViewController"];
    [self.navigationController showViewController:nextDemo sender:self];
}

- (void)leftSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    UIViewController *leaveIntro = [[LeaveIntroViewController alloc] init];
    leaveIntro = [self.storyboard instantiateViewControllerWithIdentifier:@"LeaveIntroViewController"];
    [self.navigationController showViewController:leaveIntro sender:self];
}

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
