//
//  FeedbackViewController.h
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *specificQuestionTotalSale;
@property (strong, nonatomic) NSString *specificQuestionTotalSampling;
@property (strong, nonatomic) NSString *specificQuestionMostPopular;
@property (strong, nonatomic) NSString *specificQuestionLeastPopular;
@property (strong, nonatomic) NSString *specificQuestionReceipts;
@property (strong, nonatomic) NSMutableDictionary *specificQuestionPhotoSubmitted;
@property (assign) BOOL specificQuestionAlreadySubmitted;
@property (strong, nonatomic) NSString *generalFeedbackProblemSolution;
@property (strong, nonatomic) NSString *generalFeedbackCustomerFeedback;
@end
