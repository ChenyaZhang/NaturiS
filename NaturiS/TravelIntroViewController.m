//
//  TravelIntroViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "TravelIntroViewController.h"
#import "TravelViewController.h"
#import "DemoIntroViewController.h"

@interface TravelIntroViewController ()

@end

@implementation TravelIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Add right swipe gesture
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeRecognizer:)];
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizerRight];
    // Add left swipe gesture
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeRecognizer:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)rightSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    UIViewController *travel = [[TravelViewController alloc] init];
    travel = [self.storyboard instantiateViewControllerWithIdentifier:@"TravelViewController"];
    [self.navigationController showViewController:travel sender:self];
}

- (void)leftSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    UIViewController *demoIntro = [[DemoIntroViewController alloc] init];
    demoIntro = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoIntroViewController"];
    [self.navigationController showViewController:demoIntro sender:self];
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
