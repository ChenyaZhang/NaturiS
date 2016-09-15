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
    // Add right swipe gesture
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeRecognizer:)];
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizerRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tapRecognizerForCompetitorAnalysis:(UISwipeGestureRecognizer *)sender {
    CompetitorAnalysisViewController *competitor = [[CompetitorAnalysisViewController alloc] init];
    competitor = [self.storyboard instantiateViewControllerWithIdentifier:@"CompetitorAnalysisViewController"];
    NSLog(@"tapRecognizerForCompetitorAnalysis competitorAnalysisPhotoSubmitted.count: %lu", (unsigned long)self.competitorAnalysisPhotoSubmitted.count);
    [self.navigationController showViewController:competitor sender:self];
}

- (void)tapRecognizerForOurProductAnalysis:(UISwipeGestureRecognizer *)sender {
    OurProductViewController *ourProduct = [[OurProductViewController alloc] init];
    ourProduct = [self.storyboard instantiateViewControllerWithIdentifier:@"OurProductViewController"];
    [self.navigationController showViewController:ourProduct sender:self];
}

- (void)rightSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    
    // Check data submission from NSUserDefault
    // ...
    
    DemoReadyViewController *demoReady = [[DemoReadyViewController alloc] init];
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
