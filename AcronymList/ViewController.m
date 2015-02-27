//
//  ViewController.m
//  AcronymList
//
//  Created by Sohel Bukhari on 2/25/15.
//  Copyright (c) 2015 SB. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

#define baseURL @"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf="

@interface ViewController ()<MBProgressHUDDelegate> {

    MBProgressHUD *HUD;
    NSString * searchString;
    NSArray *resulstArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma TableViewDataSource Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rowcount = 1;
    
    if([resulstArray count] != 0){
        rowcount = [resulstArray count];
    }
    return rowcount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier = @"cell";
    NSString *cellText;
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if([resulstArray count] != 0){
            cellText = [[resulstArray objectAtIndex:indexPath.row] objectForKey:@"lf"];
    }else{
        cellText = @"Search for Acronym...";
    }
    [cell.textLabel setText:cellText];
    return cell;
}


#pragma SearchBar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    searchString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(searchText != nil || ![searchText isEqualToString:@""]) {
        //For dynamic searchString, searchString Lookup
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    self.searchDisplayController.active = NO;

    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Responding...";
    HUD.detailsLabelText = [NSString stringWithFormat:@"For %@", searchString];
    HUD.square = YES;
    [HUD show:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", baseURL, searchString];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __block id blockResponse = nil;
    __block id blockError = nil;
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [operation.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *opration, id responseObj){
        blockResponse = responseObj;
        
        if ([blockResponse count] == 0) {
            // Null Response
            
            HUD.labelText = @"No Response";
            [HUD performSelector:@selector(hide:) withObject:@"YES" afterDelay:2];
            //sorry no response alert
            
        }else{
            resulstArray = [[blockResponse objectAtIndex:0] objectForKey:@"lfs"];
            // parse results / for (id obj in resulstArray)
            
            [self.tableView reloadData];
            [HUD hide:YES];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        blockError = error;
        // handle error
        
        [HUD hide:YES];
    }];
    
    [operation start];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
}


@end
