//
//  NextDemoViewController.m
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import "NextDemoViewController.h"
#import "LeaveViewController.h"

@interface NextDemoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nextUpcomingDemo;
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
    // Add line break
    self.nextUpcomingDemo.text = [NSString stringWithFormat:@"Your Next Demo:\n\n%@\n%@,\n%@,\n%@", time, addressLine1, addressLine2, addressLine3];
    // Ensure line break
    self.nextUpcomingDemo.numberOfLines = 0;
    self.nextUpcomingDemo.textAlignment = NSTextAlignmentCenter;
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
