//
//  ViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"

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
    UIViewController *login = [[LoginViewController alloc] init];
    login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController showViewController:login sender:self];
}

@end
