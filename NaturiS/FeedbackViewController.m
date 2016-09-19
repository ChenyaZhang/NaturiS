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
    // Add left swipe gesture
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeRecognizer:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tapRecognizerForSpecificQuestion:(UISwipeGestureRecognizer *)sender {
    // Get data submission status from NSUserDefaults
    NSString *submit = [[NSUserDefaults standardUserDefaults] valueForKey:@"SpecificQuestionDataSubmitted"];
    if (![submit isEqualToString:@"1"]) {
        SpecificQuestionViewController *specificQuestion = [[SpecificQuestionViewController alloc] init];
        specificQuestion = [self.storyboard instantiateViewControllerWithIdentifier:@"SpecificQuestionViewController"];
        [self.navigationController showViewController:specificQuestion sender:self];
    } else {
        // UIAlertController action sheet
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"ALREADY SUBMITTED." preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        // Present action sheet
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}

- (void)tapRecognizerForGeneralFeedback:(UISwipeGestureRecognizer *)sender {
    // Get data submission status from NSUserDefaults
    NSString *submit = [[NSUserDefaults standardUserDefaults] valueForKey:@"GeneralFeedbackDataSubmitted"];
    if (![submit isEqualToString:@"1"]) {
        GeneralFeedbackViewController *generalFeedback = [[GeneralFeedbackViewController alloc] init];
        generalFeedback = [self.storyboard instantiateViewControllerWithIdentifier:@"GeneralFeedbackViewController"];
        [self.navigationController showViewController:generalFeedback sender:self];
    } else {
        // UIAlertController action sheet
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"ALREADY SUBMITTED." preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        // Present action sheet
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}

- (void)leftSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    NSString *submitSpecificData = [[NSUserDefaults standardUserDefaults] valueForKey:@"SpecificQuestionDataSubmitted"];
    NSString *submitGeneralData = [[NSUserDefaults standardUserDefaults] valueForKey:@"GeneralFeedbackDataSubmitted"];
    // Check data submission
    if ([submitSpecificData isEqualToString:@"1"] && [submitGeneralData isEqualToString:@"1"]) {
        CongratulationViewController *congrat = [[CongratulationViewController alloc] init];
        congrat = [self.storyboard instantiateViewControllerWithIdentifier:@"CongratulationViewController"];
        [self.navigationController showViewController:congrat sender:self];
    } else {
        // UIAlertController action sheet
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"COULD YOU PLEASE FINISH BOTH?" preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        // Present action sheet
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
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
