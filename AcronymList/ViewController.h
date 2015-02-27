//
//  ViewController.h
//  AcronymList
//
//  Created by Sohel Bukhari on 2/25/15.
//  Copyright (c) 2015 SB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

