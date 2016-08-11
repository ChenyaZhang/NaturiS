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
@end

@implementation ArriveViewController {
    NSTimer *yourArrivingTimeTimer;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    BOOL yourArrivingTimeStart;
    BOOL yourArrivingLocationStart;
}

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
    
    // Add left swipe gesture
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeRecognizer:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
}

- (void) startArrivingTimeTimer {
    yourArrivingTimeTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                            target: self
                                                          selector:@selector(updateYourArrivingTime:)
                                                          userInfo: nil repeats:YES];
    [yourArrivingTimeTimer fire];
    yourArrivingTimeStart = TRUE;
}

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
            _yourArrivingLocation.numberOfLines = 0;
            _yourArrivingLocation.textAlignment = NSTextAlignmentCenter;
            [self.yourArrivingLocation sizeToFit];
            _yourArrivingLocation.text = [NSString stringWithFormat:@"Your Arriving Address:\n %@ %@\n%@ %@",
                                         placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.postalCode];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

- (void)updateYourArrivingTime: (NSTimer *)timer {
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    _yourArrivingTime.numberOfLines = 2;
    _yourArrivingTime.textAlignment = NSTextAlignmentCenter;
    _yourArrivingTime.text = [NSString stringWithFormat:@"Your Arriving Time:\n %@", [formatter stringFromDate:currentTime]];
}

- (void)arrivingTimeTapRecognizer:(UITapGestureRecognizer *)sender {
    if (yourArrivingTimeStart) {
        [yourArrivingTimeTimer invalidate];
        yourArrivingTimeTimer = nil;
        yourArrivingTimeStart = FALSE;
    } else {
        [self startArrivingTimeTimer];
    }
}

- (void)arrivingLocationTapRecognizer:(UITapGestureRecognizer *)sender {
    if (yourArrivingLocationStart) {
        [locationManager stopUpdatingLocation];
        locationManager = nil;
        yourArrivingLocationStart = FALSE;
    } else {
        [self startArrivingLocationUpdate];
    }
}

- (void)rightSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    UIViewController *collectIntro = [[CollectIntroViewController alloc] init];
    collectIntro = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectIntroViewController"];
    [self.navigationController showViewController:collectIntro sender:self];
}

- (void)leftSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    UIViewController *travel = [[TravelViewController alloc] init];
    travel = [self.storyboard instantiateViewControllerWithIdentifier:@"TravelViewController"];
    [self.navigationController showViewController:travel sender:self];
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
