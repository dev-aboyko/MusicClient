//
//  MusicTableViewController.m
//  MusicClient
//
//  Created by Alexey Boyko on 21.05.15.
//  Copyright (c) 2015 Alexey Boyko. All rights reserved.
//

#import "MusicTableViewController.h"
#import "MusicTableViewCell.h"
#import "APIClient.h"
#import "AudioPlayer.h"

@interface MusicTableViewController ()<UITableViewDataSource, UITableViewDelegate, APIClientDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) APIClient* apiClient;

@end

@implementation MusicTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _apiClient = [[APIClient alloc] initWithDelegate:self];
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API client delegate

- (void)onReceiveNewMelodies
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _apiClient.melodiesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Song cell" forIndexPath:indexPath];
    NSDictionary* melody = [_apiClient melodyForIndex:indexPath.row];
    [cell setMelody:melody];;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* melody = [_apiClient melodyForIndex:indexPath.row];
    NSString* audioURL = [melody objectForKey:@"demoUrl"];
    [[AudioPlayer sharedInstance] playURL:audioURL];
}

@end
