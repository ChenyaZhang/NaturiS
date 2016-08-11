//
//  DemoViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "DemoViewController.h"
#import "DemoReadyViewController.h"
#import "FeedbackIntroViewController.h"

@interface DemoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *buttonImage;
@end

@implementation DemoViewController

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
    UIViewController *feedbackIntro = [[FeedbackIntroViewController alloc] init];
    feedbackIntro = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackIntroViewController"];
    [self.navigationController showViewController:feedbackIntro sender:self];
}

- (void)leftSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    UIViewController *demoReady = [[DemoReadyViewController alloc] init];
    demoReady = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoReadyViewController"];
    [self.navigationController showViewController:demoReady sender:self];
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
