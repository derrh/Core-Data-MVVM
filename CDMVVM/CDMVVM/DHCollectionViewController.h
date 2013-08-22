//
//  DHCollectionViewController.h
//  CDMVVM
//
//  Created by derrick on 8/22/13.
//  Copyright (c) 2013 Derrick Hathaway. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DHCollectionViewModel;
@interface DHCollectionViewController : UICollectionViewController
+ (instancetype)controllerWithViewModel:(id<DHCollectionViewModel>)viewModel;
@end
