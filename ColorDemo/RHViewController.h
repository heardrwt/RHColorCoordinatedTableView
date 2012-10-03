//
//  RHViewController.h
//  ColorDemo
//
//  Created by Richard Heard on 3/10/12.
//  Copyright (c) 2012 Richard Heard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHColorCoordinatedTableView.h"

@interface RHViewController : UITableViewController

@property (retain, nonatomic) IBOutlet RHColorCoordinatedTableView *tableView;

@end
