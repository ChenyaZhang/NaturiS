//
//  ViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "ViewController.h"
#import "DemoIntroViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Hide Navigation Controller bar
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    // Add swipe gesture
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)swipeRecognizer:(UISwipeGestureRecognizer *)sender {
    UIViewController *demoIntro = [[DemoIntroViewController alloc] init];
    demoIntro = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoIntroViewController"];
    [self.navigationController showViewController:demoIntro sender:self];
}

@end
