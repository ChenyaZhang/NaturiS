//
//  FeedbackViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackIntroViewController.h"
#import "CongratulationViewController.h"
#import "SpecificQuestionViewController.h"
#import "GeneralFeedbackViewController.h"

@interface FeedbackViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *specificQuestionButton;
@property (weak, nonatomic) IBOutlet UIImageView *generalFeedbackButton;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add tap gesture for Specific Question
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerForSpecificQuestion:)];
    [recognizer1 setNumberOfTapsRequired:1];
    [self.specificQuestionButton setUserInteractionEnabled:YES];
    [self.view bringSubviewToFront:self.specificQuestionButton];
    [self.specificQuestionButton addGestureRecognizer:recognizer1];
    
    // Add tap gesture for General Feedback
    UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerForGeneralFeedback:)];
    [recognizer2 setNumberOfTapsRequired:1];
    [self.generalFeedbackButton setUserInteractionEnabled:YES];
    [self.view bringSubviewToFront:self.generalFeedbackButton];
    [self.generalFeedbackButton addGestureRecognizer:recognizer2];
    
    // Add right swipe gesture
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeRecognizer:)];
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizerRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tapRecognizerForSpecificQuestion:(UISwipeGestureRecognizer *)sender {
    SpecificQuestionViewController *specificQuestion = [[SpecificQuestionViewController alloc] init];
    specificQuestion = [self.storyboard instantiateViewControllerWithIdentifier:@"SpecificQuestionViewController"];
    
    specificQuestion.userName = _userName;
    
    [self.navigationController showViewController:specificQuestion sender:self];
}

- (void)tapRecognizerForGeneralFeedback:(UISwipeGestureRecognizer *)sender {
    GeneralFeedbackViewController *generalFeedback = [[GeneralFeedbackViewController alloc] init];
    generalFeedback = [self.storyboard instantiateViewControllerWithIdentifier:@"GeneralFeedbackViewController"];
    
    generalFeedback.userName = _userName;
    
    [self.navigationController showViewController:generalFeedback sender:self];
}

- (void)rightSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    CongratulationViewController *congrat = [[CongratulationViewController alloc] init];
    congrat = [self.storyboard instantiateViewControllerWithIdentifier:@"CongratulationViewController"];
    
    congrat.userName = _userName;
    
    [self.navigationController showViewController:congrat sender:self];
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
