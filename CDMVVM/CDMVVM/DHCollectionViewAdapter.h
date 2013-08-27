//
//  DHCollectionViewAdapter.h
//  CDMVVM
//
//  Created by derrick on 8/22/13.
//  Copyright (c) 2013 Derrick Hathaway. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DHCollectionViewAdapter <NSObject>

- (UICollectionViewCell *)cellForCollectionViewController:(UICollectionViewController *)controller atIndexPath:(NSIndexPath *)indexPath;

- (void)cellSelectedInCollectionViewController:(UICollectionViewController *)controller atIndexPath:(NSIndexPath *)indexPath;

@end
