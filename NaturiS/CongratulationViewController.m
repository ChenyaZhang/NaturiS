//
//  CongratulationViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "CongratulationViewController.h"
#import "FeedbackViewController.h"
#import "LeaveIntroViewController.h"

@interface CongratulationViewController ()

@end

@implementation CongratulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Add left swipe gesture
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeRecognizer:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)leftSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    LeaveIntroViewController *leaveIntro = [[LeaveIntroViewController alloc] init];
    leaveIntro = [self.storyboard instantiateViewControllerWithIdentifier:@"LeaveIntroViewController"];    
    [self.navigationController showViewController:leaveIntro sender:self];
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
