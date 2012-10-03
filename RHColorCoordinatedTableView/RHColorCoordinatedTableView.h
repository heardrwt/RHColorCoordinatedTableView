//
//  RHColorCoordinatedTableView.h
//  RHColorCoordinatedTableView
//
//  Created by Richard Heard on 2/10/12.
//  Copyright (c) 2012 Richard Heard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHColorCoordinatedTableView : UITableView {
    UIView *_preHeaderView;
    UIView *_postFooterView;
    
    BOOL _reloadDataInProgress;
    NSInteger _updatesInProgressCount;
    BOOL _endUpdatesAnimationInProgress;
}


//convenience
@property (retain, nonatomic) UIColor *preHeaderColor;  //forwards to preHeaderView.backgroundColor
@property (retain, nonatomic) UIColor *postFooterColor; //forwards to postFooterView.backgroundColor

//container views (origin + size are both ignored. view size is synced to the size of the tableView automatically)
@property (retain, nonatomic) UIView *preHeaderView;
@property (retain, nonatomic) UIView *postFooterView;


//frames
-(CGRect)frameForPreHeaderView;
-(CGRect)frameForPostFooterView;

//heights
-(CGFloat)heightForAllSections;
-(CGFloat)heightForSection:(NSInteger)section;
-(CGFloat)heightForTableFooterView;

@end
