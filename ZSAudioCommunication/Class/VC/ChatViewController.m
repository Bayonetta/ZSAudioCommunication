//
//  ChatViewController.m
//  test
//
//  Created by 赵帅 on 14-3-28.
//  Copyright (c) 2014年 com.bayonetta. All rights reserved.
//

#import "ChatViewController.h"
#import "PlayViewController.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *fileArray;

@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *path = NSTemporaryDirectory();
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:path];
    NSString *fileName = nil;
    
    while ((fileName = [dirEnum nextObject]) != nil) {
        if ([[fileName pathExtension] isEqualToString:@"wav"]) {
            [fileArray addObject:fileName];
        }
    }
    
    self.fileArray = [fileArray copy];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayViewController *vc = [[PlayViewController alloc]initWithFilePath:[self.fileArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fileArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.fileArray objectAtIndex:indexPath.row];
    return cell;
}




@end
