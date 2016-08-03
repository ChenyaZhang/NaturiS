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
    
    // Add tap gesture
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
    [recognizer setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tapRecognizer:(UISwipeGestureRecognizer *)sender {
    UIViewController *demoIntro = [[DemoIntroViewController alloc] init];
    demoIntro = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoIntroViewController"];
    [self.navigationController showViewController:demoIntro sender:self];
}

@end
