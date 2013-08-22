//
//  DHTableViewController.m
//  CDMVVM
//
//  Created by derrick on 8/22/13.
//  Copyright (c) 2013 Derrick Hathaway. All rights reserved.
//

#import "DHTableViewController.h"
#import "DHTableViewAdapter.h"
#import <CoreData/CoreData.h>
#import "DHCollectionViewModel.h"

@interface DHTableViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic) id<DHCollectionViewModel> viewModel;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation DHTableViewController

+ (instancetype)controllerWithViewModel:(id<DHCollectionViewModel>)viewModel
{
    DHTableViewController *me = [[self alloc] init];
    me.viewModel = viewModel;
    return me;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.viewModel respondsToSelector:@selector(tableViewControllerViewDidLoad:)]) {
        [self.viewModel tableViewControllerViewDidLoad:self];
    }
    
    self.fetchedResultsController = [self.viewModel fetchedResultsController];
    self.fetchedResultsController.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)pullToRefresh:(UIRefreshControl *)refresh
{
    [self.viewModel refreshWithCompletionBlock:^{
        [refresh endRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel refreshWithCompletionBlock:nil];
}


#pragma mark - UITableViewDataSource default implementations

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return sectionInfo.name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<DHTableViewAdapter> cellController = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [cellController cellForTableViewController:self atIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<DHTableViewAdapter> cellController = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cellController cellSelectedInTableViewController:self atIndexPath:indexPath];
}

#pragma mark - Fetched results controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            // TODO:
            //            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


@end
