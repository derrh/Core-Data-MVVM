//
//  DHCollectionViewController.m
//  CDMVVM
//
//  Created by derrick on 8/22/13.
//  Copyright (c) 2013 Derrick Hathaway. All rights reserved.
//

#import "DHCollectionViewController.h"
#import <CoreData/CoreData.h>
#import "UICollectionView+NSFetchedResultsController.h"
#import "DHCollectionViewModel.h"
#import "DHCollectionViewAdapter.h"

@interface DHCollectionViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic) id<DHCollectionViewModel> viewModel;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation DHCollectionViewController

+ (instancetype)controllerWithViewModel:(id<DHCollectionViewModel>)viewModel
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(300, 260);
    layout.minimumInteritemSpacing = 20.f;
    layout.minimumLineSpacing = 20.f;
    CGFloat inset = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 40 : 20;
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return [self controllerWithViewModel:viewModel layout:layout];
}

+ (instancetype)controllerWithViewModel:(id<DHCollectionViewModel>)viewModel layout:(UICollectionViewLayout *)layout
{
    DHCollectionViewController *me = [[DHCollectionViewController alloc] initWithCollectionViewLayout:layout];
    me.viewModel = viewModel;
    return me;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.viewModel respondsToSelector:@selector(collectionViewControllerViewDidLoad:)]) {
        [self.viewModel collectionViewControllerViewDidLoad:self];
    }
    
    self.fetchedResultsController = [self.viewModel fetchedResultsController];
    self.fetchedResultsController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.viewModel refreshWithCompletionBlock:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<DHCollectionViewAdapter> adapter = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [adapter cellForCollectionViewController:self atIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<DHCollectionViewAdapter> adapter = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [adapter cellSelectedInCollectionViewController:self atIndexPath:indexPath];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // do nothing
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    [self.collectionView DH_addChangeForSection:sectionInfo atIndex:sectionIndex forChangeType:type];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    [self.collectionView DH_addChangeForObjectAtIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView DH_commitChanges];
}

@end
