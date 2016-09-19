//
//  CollectViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectIntroViewController.h"
#import "DemoReadyViewController.h"
#import "CompetitorAnalysisViewController.h"
#import "OurProductViewController.h"

@interface CollectViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *competitorAnalysisButton;
@property (weak, nonatomic) IBOutlet UIImageView *ourProductAnalysisButton;
@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Add tap gesture for Competitor Analysis
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerForCompetitorAnalysis:)];
    [recognizer1 setNumberOfTapsRequired:1];
    [self.competitorAnalysisButton setUserInteractionEnabled:YES];
    [self.view bringSubviewToFront:self.competitorAnalysisButton];
    [self.competitorAnalysisButton addGestureRecognizer:recognizer1];
    // Add tap gesture for Our Product Analysis
    UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerForOurProductAnalysis:)];
    [recognizer2 setNumberOfTapsRequired:1];
    [self.ourProductAnalysisButton setUserInteractionEnabled:YES];
    [self.view bringSubviewToFront:self.ourProductAnalysisButton];
    [self.ourProductAnalysisButton addGestureRecognizer:recognizer2];
    // Add left swipe gesture
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeRecognizer:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Store status
//[[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"CompetitorProductDataSubmitted"];
//[[NSUserDefaults standardUserDefaults] synchronize];

- (void)tapRecognizerForCompetitorAnalysis:(UISwipeGestureRecognizer *)sender {
    // Get data submission status from NSUserDefaults
    NSString *submit = [[NSUserDefaults standardUserDefaults] valueForKey:@"CompetitorProductDataSubmitted"];
    if (![submit isEqualToString:@"1"]) {
        CompetitorAnalysisViewController *competitor = [[CompetitorAnalysisViewController alloc] init];
        competitor = [self.storyboard instantiateViewControllerWithIdentifier:@"CompetitorAnalysisViewController"];
        NSLog(@"tapRecognizerForCompetitorAnalysis competitorAnalysisPhotoSubmitted.count: %lu", (unsigned long)self.competitorAnalysisPhotoSubmitted.count);
        [self.navigationController showViewController:competitor sender:self];
    } else {
        // UIAlertController action sheet
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"ALREADY SUBMITTED." preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        // Present action sheet
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}

- (void)tapRecognizerForOurProductAnalysis:(UISwipeGestureRecognizer *)sender {
    // Get data submission status from NSUserDefaults
    NSString *submit = [[NSUserDefaults standardUserDefaults] valueForKey:@"OurProductDataSubmitted"];
    if (![submit isEqualToString:@"1"]) {
        OurProductViewController *ourProduct = [[OurProductViewController alloc] init];
        ourProduct = [self.storyboard instantiateViewControllerWithIdentifier:@"OurProductViewController"];
        [self.navigationController showViewController:ourProduct sender:self];
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
    NSString *submitCompetitorData = [[NSUserDefaults standardUserDefaults] valueForKey:@"CompetitorProductDataSubmitted"];
    NSString *submitOurProductData = [[NSUserDefaults standardUserDefaults] valueForKey:@"OurProductDataSubmitted"];
    // Check data submission
    if ([submitCompetitorData isEqualToString:@"1"] && [submitOurProductData isEqualToString:@"1"]) {
        DemoReadyViewController *demoReady = [[DemoReadyViewController alloc] init];
        demoReady = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoReadyViewController"];
        [self.navigationController showViewController:demoReady sender:self];
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
