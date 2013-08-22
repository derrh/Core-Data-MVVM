//
//  DHTableViewAdapter.h
//  Canvas
//
//  Created by derrick on 8/15/13.
//  Copyright (c) 2013 Derrick Hathaway. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DHTableViewAdapter <NSObject>

- (UITableViewCell *)cellForTableViewController:(UITableViewController *)controller atIndexPath:(NSIndexPath *)indexPath;

- (void)cellSelectedInTableViewController:(UITableViewController *)controller atIndexPath:(NSIndexPath *)indexPath;

@end
