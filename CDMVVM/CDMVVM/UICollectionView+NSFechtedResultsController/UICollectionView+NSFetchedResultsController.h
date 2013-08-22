//
//  UICollectionView+NSFetchedResultsController.h
//  DHCollectibles
//
//  Created by Derrick Hathaway on 9/22/12.
//  Copyright (c) 2012 Derrick Hathaway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface UICollectionView (NSFetchedResultsController)
- (void)DH_addChangeForSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
- (void)DH_addChangeForObjectAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)DH_commitChanges;
@end
