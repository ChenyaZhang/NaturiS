//
//  GeneralFeedbackViewController.h
//  NaturiS
//
//  Created by Chenya Zhang on 8/4/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralFeedbackViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *problemSolution;
@property (strong, nonatomic) NSString *customerFeedback;
@end
