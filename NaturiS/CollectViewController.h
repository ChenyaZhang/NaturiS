//
//  CollectViewController.h
//  NaturiS
//
//  Created by Chenya Zhang on 8/2/16.
//  Copyright © 2016 Chenya Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectViewController : UIViewController {
//    @public BOOL competitorAnalysisAlreadySubmitted;
}
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *competitorAnalysisFirstObservation;
@property (strong, nonatomic) NSString *competitorAnalysisSecondObservation;
@property (strong, nonatomic) NSString *competitorAnalysisThirdObservation;
@property (strong, nonatomic) NSString *competitorAnalysisBrandName;
@property (strong, nonatomic) NSString *competitorAnalysisProductCategory;
@property (strong, nonatomic) NSMutableDictionary *competitorAnalysisPhotoSubmitted;
@property (assign) BOOL competitorAnalysisAlreadySubmitted;
@property (strong, nonatomic) NSString *ourProductFirstObservation;
@property (strong, nonatomic) NSString *ourProductSecondObservation;
@property (strong, nonatomic) NSString *ourProductThirdObservation;
@property (strong, nonatomic) NSString *ourProductLemonQ;
@property (strong, nonatomic) NSString *ourProductBananaQ;
@property (strong, nonatomic) NSString *ourProductPeachQ;
@property (strong, nonatomic) NSString *ourProductBberryQ;
@property (strong, nonatomic) NSString *ourProductSBerryQ;
@property (strong, nonatomic) NSString *ourProductCherryQ;
@property (strong, nonatomic) NSString *ourProductVanillaQ;
@property (strong, nonatomic) NSString *ourProductHoneyQ;
@property (strong, nonatomic) NSString *ourProductPlainQ;
@property (strong, nonatomic) NSMutableDictionary *ourProductPhotoSubmitted;
@property (assign) BOOL ourProductAlreadySubmitted;
@end
