//
//  DemoIntroViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "DemoIntroViewController.h"
#import "TravelIntroViewController.h"
#import "LoginViewController.h"

@interface DemoIntroViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *buttonImage;
@end

@implementation DemoIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add tap gesture
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
    [recognizer setNumberOfTapsRequired:1];
    [self.buttonImage setUserInteractionEnabled:YES];
    [self.view bringSubviewToFront:self.buttonImage];
    [self.buttonImage addGestureRecognizer:recognizer];
    // Add left swipe gesture
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeRecognizer:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tapRecognizer:(UISwipeGestureRecognizer *)sender {
    UIViewController *travelIntro = [[TravelIntroViewController alloc] init];
    travelIntro = [self.storyboard instantiateViewControllerWithIdentifier:@"TravelIntroViewController"];
    [self.navigationController showViewController:travelIntro sender:self];
}

- (void)leftSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    UIViewController *login = [[LoginViewController alloc] init];
    login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController showViewController:login sender:self];
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
