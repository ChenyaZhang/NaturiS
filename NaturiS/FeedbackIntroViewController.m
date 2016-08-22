//
//  FeedbackIntroViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "FeedbackIntroViewController.h"
#import "DemoViewController.h"
#import "FeedbackViewController.h"

@interface FeedbackIntroViewController ()

@end

@implementation FeedbackIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add right swipe gesture
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeRecognizer:)];
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizerRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)rightSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    FeedbackViewController *feedback = [[FeedbackViewController alloc] init];
    feedback = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
    
    feedback.userName = _userName;
    
    [self.navigationController showViewController:feedback sender:self];
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
