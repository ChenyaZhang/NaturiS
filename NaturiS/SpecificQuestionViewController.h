//
//  SpecificQuestionViewController.h
//  NaturiS
//
//  Created by Chenya Zhang on 8/4/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecificQuestionViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *totalSale;
@property (strong, nonatomic) NSString *totalSampling;
@property (strong, nonatomic) NSString *mostPopular;
@property (strong, nonatomic) NSString *leastPopular;
@property (strong, nonatomic) NSString *receipts;
@property (strong, nonatomic) NSMutableDictionary *allImageSubmitted;
@property (assign) BOOL alreadySubmitted;
@end
