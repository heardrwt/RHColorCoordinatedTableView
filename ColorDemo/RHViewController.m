//
//  RHViewController.m
//  ColorDemo
//
//  Created by Richard Heard on 3/10/12.
//  Copyright (c) 2012 Richard Heard. All rights reserved.
//

#import "RHViewController.h"

@interface RHViewController ()

//test options
-(void)updateUnwrappedSingleRow;
-(void)updateWrappedMultipleRows;
-(void)updateReload;
-(void)updateSections;

@end

#define USE_SECTION_FOOTERS 0
#define INCLUDE_UPDATE_RELOAD_IN_CLICKS 0 //reloadData is jarring when all the others animate. So leave it out by default

@implementation RHViewController {
    RHColorCoordinatedTableView *_tableView;

    NSInteger _numberOfSections;
    NSInteger _numberOfRowsInFirstSection;
}

@synthesize tableView=_tableView;

-(void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tableView.preHeaderView.backgroundColor = [UIColor colorWithRed:1.000 green:0.610 blue:0.622 alpha:1.000];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.672 green:1.000 blue:0.775 alpha:1.000];

    self.tableView.postFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    self.tableView.postFooterView.backgroundColor = [UIColor colorWithRed:0.473 green:0.834 blue:1.000 alpha:1.000];
    
    
    self.tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
    self.tableView.tableFooterView.backgroundColor = [UIColor colorWithRed:1.000 green:0.140 blue:0.845 alpha:1.000];
    
    //start with 1 & 5
    _numberOfSections = 1;
    _numberOfRowsInFirstSection = 5;
    [self updateReload];
    
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [_tableView release];
    [super dealloc];
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _numberOfSections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return _numberOfRowsInFirstSection;
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *reuse = @"Sample Row";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse] autorelease];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"Sample Row"];

    return cell;

}

#if USE_SECTION_FOOTERS
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *sectionFooter = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
    sectionFooter.backgroundColor = [UIColor colorWithRed:1.000 green:0.925 blue:0.483 alpha:1.000];
    return sectionFooter;
}
#endif

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int random = rand() % 5;
    
    switch (random) {
        case 1: return [self updateUnwrappedSingleRow];

#if INCLUDE_UPDATE_RELOAD_IN_CLICKS
        case 2: return [self updateReload];
#endif
        case 3: return [self updateSections];
        default: return [self updateWrappedMultipleRows];
    }
    
    
}

#pragma mark - test options
-(void)updateUnwrappedSingleRow{
    NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if (rand() % 2 == 1 && _numberOfRowsInFirstSection > 1) {
        _numberOfRowsInFirstSection--;
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        _numberOfRowsInFirstSection++;
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)updateWrappedMultipleRows{
    NSInteger newCount = _numberOfRowsInFirstSection;
    while (newCount == _numberOfRowsInFirstSection) {
        newCount = (rand() % 15) + 1;
    }
    
    
       //insert or remove
    [self.tableView beginUpdates];
    
    //create some index sets
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSInteger needed = newCount < _numberOfRowsInFirstSection ? _numberOfRowsInFirstSection - newCount : newCount - _numberOfRowsInFirstSection;
    
    while (needed > 0) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:needed inSection:0]];
        needed--;
    }
    
    if (newCount > _numberOfRowsInFirstSection) {
        //add rows
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } else {
        //remove rows
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    _numberOfRowsInFirstSection = newCount;
    
    [self.tableView endUpdates];
}

-(void)updateReload{
    NSInteger newCount = _numberOfRowsInFirstSection;
    while (newCount == _numberOfRowsInFirstSection) {
        newCount = (rand() % 15) + 1;
    }

    //use reloadData
    _numberOfRowsInFirstSection = newCount;
    [self.tableView reloadData];

}

-(void)updateSections{

    //  [self.tableView beginUpdates];

    if (rand() % 2 == 1 && _numberOfSections > 2) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:(NSInteger)_numberOfSections-1];
        _numberOfSections--;
        [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        _numberOfSections++;
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    //[self.tableView endUpdates];

}


@end
