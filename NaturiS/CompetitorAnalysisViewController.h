//
//  CompetitorAnalysisViewController.h
//  NaturiS
//
//  Created by Chenya Zhang on 8/4/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompetitorAnalysisViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *firstObservation;
@property (strong, nonatomic) NSString *secondObservation;
@property (strong, nonatomic) NSString *thirdObservation;
@property (strong, nonatomic) NSString *brandName;
@property (strong, nonatomic) NSString *productCategory;
@property (strong, nonatomic) NSMutableDictionary *allImageSubmitted;
@property (assign) BOOL alreadySubmitted;
@end
