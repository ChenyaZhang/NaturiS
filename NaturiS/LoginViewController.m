//
//  LoginViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/4/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "DemoIntroViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add tap gesture
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
    [recognizer setNumberOfTapsRequired:1];
    [self.loginButton setUserInteractionEnabled:YES];
    [self.view bringSubviewToFront:self.loginButton];
    [self.loginButton addGestureRecognizer:recognizer];
    
    // Add left swipe gesture
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeRecognizer:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)rightSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    UIViewController *demoIntro = [[DemoIntroViewController alloc] init];
    demoIntro = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoIntroViewController"];
    [self.navigationController showViewController:demoIntro sender:self];
}

- (void)leftSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    UIViewController *view = [[DemoIntroViewController alloc] init];
    view = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController showViewController:view sender:self];
}

- (void)tapRecognizer:(UISwipeGestureRecognizer *)sender {
    UIViewController *demoIntro = [[DemoIntroViewController alloc] init];
    demoIntro = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoIntroViewController"];
    [self.navigationController showViewController:demoIntro sender:self];
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
