//
//  DemoReadyViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "DemoReadyViewController.h"
#import "CollectViewController.h"
#import "DemoViewController.h"

@interface DemoReadyViewController ()

@end

@implementation DemoReadyViewController

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
    DemoViewController *demo = [[DemoViewController alloc] init];
    demo = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoViewController"];
    
    demo.userName = _userName;
    
    [self.navigationController showViewController:demo sender:self];
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
