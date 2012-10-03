//
//  RHColorCoordinatedTableView.m
//  RHColorCoordinatedTableView
//
//  Created by Richard Heard on 2/10/12.
//  Copyright (c) 2012 Richard Heard. All rights reserved.
//

#import "RHColorCoordinatedTableView.h"

#define END_UPDATES_ANIMATION_DURATION 0.3f

@interface RHColorCoordinatedTableView ()
-(void)rhcctv_sharedInit;

-(void)updatePreAndPostViewFrames;

@end

@implementation RHColorCoordinatedTableView

@synthesize preHeaderView=_preHeaderView;
@synthesize postFooterView=_postFooterView;

#pragma mark - init
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    
    if (self){
        [self rhcctv_sharedInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self rhcctv_sharedInit];
    }
    return self;
}

-(void)rhcctv_sharedInit{
    //init
    _preHeaderView  = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, 0.0f)];
    _preHeaderView.backgroundColor = [UIColor clearColor];
    [self addSubview:_preHeaderView];
    
    _postFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
    _postFooterView.backgroundColor = [UIColor clearColor];
    [self addSubview:_postFooterView];
    
}

-(void)dealloc{
    [_preHeaderView release]; _preHeaderView = nil;
    [_postFooterView release]; _postFooterView = nil;
    [super dealloc];
}

#pragma mark - properties
-(void)setPreHeaderView:(UIView *)preHeaderView{
    if (_preHeaderView != preHeaderView){
        [_preHeaderView removeFromSuperview];
        [self addSubview:preHeaderView];
        
        [_preHeaderView release];
        _preHeaderView =[preHeaderView retain];
        
        [self setNeedsLayout];
    }
}

-(void)setPostFooterView:(UIView *)postFooterView{
    if (_postFooterView != postFooterView){
        [_postFooterView removeFromSuperview];
        [self addSubview:postFooterView];
        
        [_postFooterView release];
        _postFooterView =[postFooterView retain];
        
        [self setNeedsLayout];
    }
}

-(UIColor*)preHeaderColor{
    return _preHeaderView.backgroundColor;
}

-(void)setPreHeaderColor:(UIColor *)preHeaderColor{
    _preHeaderView.backgroundColor = preHeaderColor;
}

-(UIColor*)postFooterColor{
    return _postFooterView.backgroundColor;
}

-(void)setPostFooterColor:(UIColor *)postFooterColor{
    _postFooterView.backgroundColor = postFooterColor;
}


#pragma mark - self - frames

-(void)updatePreAndPostViewFrames{
    
    //position and size the pre and post views
    _preHeaderView.frame = [self frameForPreHeaderView];
    _postFooterView.frame =[self frameForPostFooterView];
    
}

-(CGRect)frameForPreHeaderView{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    return CGRectMake(0.0f, -height, width, height);
}

-(CGRect)frameForPostFooterView{
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat contentHeight = [self heightForAllSections]; //use section rects to calculate the full content height
    
    //if we have a footerView, we also need to add this to the content height
    if (self.tableFooterView){
        contentHeight += [self heightForTableFooterView];
    }
    
    return CGRectMake(0.0f, contentHeight, width, height + (contentHeight < height ? height - contentHeight : 0.0f));
}


#pragma mark - self - heights

-(CGFloat)heightForAllSections{
    CGFloat total = 0.0f;
    for (NSInteger section = 0; section < [self numberOfSections]; section++) {
        total += [self heightForSection:section];
    }
    return total;
}

-(CGFloat)heightForSection:(NSInteger)section{
    CGRect rect = [self rectForSection:section];
    return rect.size.height;
}

-(CGFloat)heightForTableFooterView{
    return self.tableFooterView.bounds.size.height;
}


#pragma mark - UITableView

-(void)reloadData{
    _reloadDataInProgress = YES;
    [super reloadData];
    [self setNeedsLayout];
    _reloadDataInProgress = NO;
}

#define PRE_SUPER_CALL()            \
BOOL didWrap = NO;                  \
if (_updatesInProgressCount == 0){  \
    didWrap = YES;                  \
    [self beginUpdates];            \
}

#define POST_SUPER_CALL()           \
if (didWrap){                       \
    [self endUpdates];              \
}

-(void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    PRE_SUPER_CALL();
    
    [super insertSections:sections withRowAnimation:animation];
    [self setNeedsLayout];
    
    POST_SUPER_CALL();
}

-(void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    PRE_SUPER_CALL();
    
    [super deleteSections:sections withRowAnimation:animation];
    [self setNeedsLayout];
    
    POST_SUPER_CALL();
}
-(void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    PRE_SUPER_CALL();
    
    [super reloadSections:sections withRowAnimation:animation];
    [self setNeedsLayout];
    
    POST_SUPER_CALL();
}


-(void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    PRE_SUPER_CALL();
    
    [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self setNeedsLayout];
    
    POST_SUPER_CALL();
}

-(void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    PRE_SUPER_CALL();
    
    [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self setNeedsLayout];
    
    POST_SUPER_CALL();
}

-(void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    PRE_SUPER_CALL();
    
    [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self setNeedsLayout];
    
    POST_SUPER_CALL();
}


-(void)beginUpdates{
    _updatesInProgressCount++;
    [super beginUpdates];
}

-(void)endUpdates{
    _updatesInProgressCount--;
    
    if (_updatesInProgressCount == 0){
        [self updatePreAndPostViewFrames]; //do it once before end updates, before we start animating
        
        _endUpdatesAnimationInProgress = YES;
        [UIView beginAnimations:@"RHColorCoordinatedTableViewEndUpdatesAnimation" context:self];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(_endUpdatesAnimationDidStop)];
        [UIView setAnimationDuration:END_UPDATES_ANIMATION_DURATION];
    }
    
    [super endUpdates];
    [self updatePreAndPostViewFrames]; //now for the second time, animated, after calling endUpdates
    
    if (_updatesInProgressCount == 0){
        [UIView commitAnimations];
    }
    
}

-(void)_endUpdatesAnimationDidStop{
    _endUpdatesAnimationInProgress = NO;
}

#pragma mark - UIScrollView
-(void)setContentSize:(CGSize)contentSize{
    [super setContentSize:contentSize];
}


#pragma mark - UIView
-(void)layoutSubviews{
    [super layoutSubviews];
    [self updatePreAndPostViewFrames];
}


@end
