//
//  olgotExploreViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotExploreViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "olgotBoardViewController.h"

@interface olgotExploreViewController ()

@end

@implementation olgotExploreViewController

@synthesize boardBigTile = _boardBigTile, boardNormalTile = _boardNormalTile;

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
	
    // background
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [tempImageView setFrame:self.collectionView.frame]; 
    
    self.collectionView.backgroundView = tempImageView;
    self.collectionView.rowSpacing = 10.0f;
    self.collectionView.scrollView.contentInset = UIEdgeInsetsMake(10.0,0.0,0.0,0.0);
    
    self.collectionView.extremitiesStyle = SSCollectionViewExtremitiesStyleScrolling;
    
    //title logo
    UIImage *titleImage = [UIImage imageNamed:@"logo-140x74"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    [self.navigationController.navigationBar.topItem setTitleView:titleImageView];
  
    Boolean firstRun = YES;
    
    if(firstRun){
//        [self performSegueWithIdentifier:@"ShowSignupFlow" sender:self];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - SSCollectionViewDataSource

- (NSUInteger)numberOfSectionsInCollectionView:(SSCollectionView *)aCollectionView {
	return 3;
}


- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
    if (section == 0) {
        return 1;
    }else if(section == 1) {
        return 4;
    }else{
        return 12;
    }
}


- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
	static NSString *myNormalTileIdentifier = @"NormalBoardTile";
    static NSString *myBigTileIdentifier = @"BigBoardTile";
    
    if (indexPath.section == 0) {
        SSCollectionViewItem *cell1 = [aCollectionView dequeueReusableItemWithIdentifier:myBigTileIdentifier];
        
        if (cell1 == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"BoardBigTile" owner:self options:nil];
            cell1 = _boardBigTile;
            self.boardBigTile = nil;
        }
        
        UIImageView *tileImage;
        UILabel *tileLabel;
        
        tileImage = (UIImageView *)[cell1 viewWithTag:1];
        tileLabel = (UILabel *)[cell1 viewWithTag:2];
        
        // configure custom data
        
        return cell1;
    }
    else {
        SSCollectionViewItem *cell2 = [aCollectionView dequeueReusableItemWithIdentifier:myNormalTileIdentifier];
        
        if (cell2 == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"BoardNormalTile" owner:self options:nil];
            cell2 = _boardNormalTile;
            self.boardNormalTile = nil;
        }
        
        UIImageView *tileImage;
        UILabel *tileLabel;
        
        tileImage = (UIImageView *)[cell2 viewWithTag:1];
        tileLabel = (UILabel *)[cell2 viewWithTag:2];
        
        // configure custom data
        
        return cell2;
    }
 
}


- (UIView *)collectionView:(SSCollectionView *)aCollectionView viewForHeaderInSection:(NSUInteger)section {
	SSLabel *header = [[SSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 0.0f)];
	header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //	header.text = [NSString stringWithFormat:@"Section %i", section + 1];
	header.textEdgeInsets = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f);
	header.shadowColor = [UIColor whiteColor];
	header.shadowOffset = CGSizeMake(0.0f, 1.0f);
	header.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
	return header;
}


#pragma mark - SSCollectionViewDelegate

- (CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section {
    if (section == 0) {
        return CGSizeMake(300.0f, 130.0f);
    }else{
        return CGSizeMake(145.0f, 130.0f);
    }
	
}

- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"ShowBoardView" sender:self];
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
    if (section == 0) {
        return 0.0f;
    }else{
        return 0.0f;
    }
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowBoardView"]) {
//        olgotBoardViewController *boardViewController = [segue destinationViewController];
        
        
    }
}


@end

