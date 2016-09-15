//
//  NextDemoViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "NextDemoViewController.h"
#import "LeaveViewController.h"
#import "LoginViewController.h"

@interface NextDemoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nextUpcomingDemo;
@property (weak, nonatomic) IBOutlet UILabel *nextDemoContent;
@property (weak, nonatomic) IBOutlet UIImageView *buttonImage;
@end

@implementation NextDemoViewController


#pragma mark - View Did Load

- (void)viewDidLoad {
    [super viewDidLoad];    
    // From "Prepare for segue"
    // Parse NSString
    NSArray *components = [self.nextDemo componentsSeparatedByString: @","];
    NSString *time = (NSString*) [components objectAtIndex:0];
    NSString *addressLine1 = (NSString*) [components objectAtIndex:1];
    NSString *addressLine2 = (NSString*) [components objectAtIndex:2];
    NSString *addressLine3 = (NSString*) [components objectAtIndex:3];
    // Display text
    // NSAttributed String
    NSString *nextDemoString = @"Next Demo";
    NSMutableAttributedString *nextDemoAttributedString =[[NSMutableAttributedString alloc] initWithString: nextDemoString];
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    [nextDemoAttributedString addAttribute:NSFontAttributeName
                                         value:font
                                         range:NSMakeRange(0, [nextDemoString length])];
    // Put together
    self.nextUpcomingDemo.attributedText = nextDemoAttributedString;
    self.nextDemoContent.text = [NSString stringWithFormat:@"%@\n%@,\n%@,\n%@", time, addressLine1, addressLine2, addressLine3];
    // Ensure line break
    self.nextUpcomingDemo.numberOfLines = 0;
    self.nextUpcomingDemo.textAlignment = NSTextAlignmentCenter;
    self.nextDemoContent.numberOfLines = 0;
    self.nextDemoContent.textAlignment = NSTextAlignmentCenter;
    // Add tap gesture
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
    [recognizer setNumberOfTapsRequired:1];
    [self.buttonImage setUserInteractionEnabled:YES];
    [self.view bringSubviewToFront:self.buttonImage];
    [self.buttonImage addGestureRecognizer:recognizer];
}

- (void)tapRecognizer:(UISwipeGestureRecognizer *)sender {
    LoginViewController *login = [[LoginViewController alloc] init];
    login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController showViewController:login sender:self];
}


#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
