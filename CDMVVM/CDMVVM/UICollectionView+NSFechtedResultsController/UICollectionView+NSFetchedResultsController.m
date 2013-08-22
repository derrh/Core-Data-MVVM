//
//  UICollectionView+NSFetchedResultsController.m
//  DHCollectibles
//
//  Created by Derrick Hathaway on 9/22/12.
//  Copyright (c) 2012 Derrick Hathaway. All rights reserved.
//

#import "UICollectionView+NSFetchedResultsController.h"
#import <objc/runtime.h>


@interface UICollectionView (ChangesInternal)
@property (strong, nonatomic, readonly) NSMutableArray *DH_sectionChanges;
@property (strong, nonatomic, readonly) NSMutableArray *DH_objectChanges;
@end


@implementation UICollectionView (NSFetchedResultsController)

- (void)DH_addChangeForSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
  
  NSMutableDictionary *change = [NSMutableDictionary new];
  
  switch(type) {
      case NSFetchedResultsChangeInsert:
      case NSFetchedResultsChangeDelete:
          change[@(type)] = @(sectionIndex);
          break;
  }
  
  [self.DH_sectionChanges addObject:change];
}

- (void)DH_addChangeForObjectAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
  
  NSMutableDictionary *change = [NSMutableDictionary new];
  switch(type)
  {
    case NSFetchedResultsChangeInsert:
      change[@(type)] = newIndexPath;
      break;
    case NSFetchedResultsChangeDelete:
      change[@(type)] = indexPath;
      break;
    case NSFetchedResultsChangeUpdate:
      change[@(type)] = indexPath;
      break;
    case NSFetchedResultsChangeMove:
      change[@(type)] = @[indexPath, newIndexPath];
      break;
  }
  [self.DH_objectChanges addObject:change];
}

- (void)DH_commitChanges
{
  if ([self.DH_sectionChanges count] > 0)
  {
    [self performBatchUpdates:^{
      
      for (NSDictionary *change in self.DH_sectionChanges)
      {
        [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
          
          NSFetchedResultsChangeType type = [key unsignedIntegerValue];
          switch (type)
          {
            case NSFetchedResultsChangeInsert:
              [self insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
              break;
            case NSFetchedResultsChangeDelete:
              [self deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
              break;
            case NSFetchedResultsChangeUpdate:
              [self reloadSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
              break;
          }
        }];
      }
    } completion:^(BOOL finished) {
        NSLog(@"finished updating sections!");
    }];
  }
  
  if ([self.DH_objectChanges count] > 0 && [self.DH_sectionChanges count] == 0)
  {
    [self performBatchUpdates:^{
      
      for (NSDictionary *change in self.DH_objectChanges)
      {
        [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
          
          NSFetchedResultsChangeType type = [key unsignedIntegerValue];
          switch (type)
          {
            case NSFetchedResultsChangeInsert:
              [self insertItemsAtIndexPaths:@[obj]];
              break;
            case NSFetchedResultsChangeDelete:
              [self deleteItemsAtIndexPaths:@[obj]];
                  NSLog(@"deleting item %d, %d", [(NSIndexPath *)obj item], [obj section]);
              break;
            case NSFetchedResultsChangeUpdate:
              [self reloadItemsAtIndexPaths:@[obj]];
              break;
            case NSFetchedResultsChangeMove:
              [self moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
              break;
          }
        }];
      }
    } completion:^(BOOL finished) {
        NSLog(@"finished updating objects!");
    }];
  }
  
  [self.DH_sectionChanges removeAllObjects];
  [self.DH_objectChanges removeAllObjects];
}


#pragma mark - changes arrays

- (NSMutableArray *)DH_sectionChanges
{
  static char kSectionChangesKey;
  NSMutableArray *sectionChanges = objc_getAssociatedObject(self, &kSectionChangesKey);
  if (sectionChanges == nil) {
    sectionChanges = [NSMutableArray array];
    objc_setAssociatedObject(self, &kSectionChangesKey, sectionChanges, OBJC_ASSOCIATION_RETAIN);
  }
  return sectionChanges;
}

- (NSMutableArray *)DH_objectChanges
{
  static char kObjectChangesKey;
  NSMutableArray *objectChanges = objc_getAssociatedObject(self, &kObjectChangesKey);
  if (objectChanges == nil) {
    objectChanges = [NSMutableArray array];
    objc_setAssociatedObject(self, &kObjectChangesKey, objectChanges, OBJC_ASSOCIATION_RETAIN);
  }
  return objectChanges;
}


@end
