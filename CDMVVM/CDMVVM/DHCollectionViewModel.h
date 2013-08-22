//
//  DHCollectionViewModel.h
//  CDMVVM
//
//  Created by derrick on 8/22/13.
//  Copyright (c) 2013 Derrick Hathaway. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHTableViewController, DHCollectionViewController;
@protocol DHCollectionViewModel <NSObject>
- (NSFetchedResultsController *)fetchedResultsController;
- (void)refreshWithCompletionBlock:(void (^)())block;

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
@optional

- (void)tableViewControllerViewDidLoad:(DHTableViewController *)controller;
- (void)collectionViewControllerViewDidLoad:(DHCollectionViewController *)controller;
#endif

@end
