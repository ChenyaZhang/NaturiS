//
//  OurProductViewController.h
//  NaturiS
//
//  Created by Chenya Zhang on 8/4/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OurProductViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *firstObservation;
@property (strong, nonatomic) NSString *secondObservation;
@property (strong, nonatomic) NSString *thirdObservation;
@property (strong, nonatomic) NSString *lemonQ;
@property (strong, nonatomic) NSString *bananaQ;
@property (strong, nonatomic) NSString *peachQ;
@property (strong, nonatomic) NSString *bBerryQ;
@property (strong, nonatomic) NSString *sBerryQ;
@property (strong, nonatomic) NSString *cherryQ;
@property (strong, nonatomic) NSString *vanillaQ;
@property (strong, nonatomic) NSString *honeyQ;
@property (strong, nonatomic) NSString *plainQ;
@property (strong, nonatomic) NSMutableDictionary *allImageSubmitted;
@property (assign) BOOL alreadySubmitted;
@end
