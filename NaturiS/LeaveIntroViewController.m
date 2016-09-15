//
//  LeaveIntroViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "LeaveIntroViewController.h"
#import "CongratulationViewController.h"
#import "LeaveViewController.h"

@interface LeaveIntroViewController ()

@end

@implementation LeaveIntroViewController

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
    LeaveViewController *leave = [[LeaveViewController alloc] init];
    leave = [self.storyboard instantiateViewControllerWithIdentifier:@"LeaveViewController"];    
    [self.navigationController showViewController:leave sender:self];
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
