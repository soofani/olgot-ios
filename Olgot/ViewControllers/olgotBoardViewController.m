//
//  olgotBoardViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotBoardViewController.h"

@implementation olgotBoardViewController

@synthesize itemCell = _itemCell;

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
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [tempImageView setFrame:self.collectionView.frame]; 
    
    self.collectionView.backgroundView = tempImageView;
    self.collectionView.rowSpacing = 10.0f;
    
     self.collectionView.scrollView.contentInset = UIEdgeInsetsMake(10.0,0.0,0.0,0.0);
    
    self.collectionView.extremitiesStyle = SSCollectionViewExtremitiesStyleScrolling;
    
    UIImage *mapImage30 = [UIImage imageNamed:@"btn-nav-map"];
    
    UIButton *mapBtn = [[UIButton alloc] init];
    mapBtn.frame=CGRectMake(0,0,35,30);
    [mapBtn setBackgroundImage:mapImage30 forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(showMapView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:mapBtn];
    
}

- (void)showMapView
{
    [self performSegueWithIdentifier:@"ShowMapView" sender:self];
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
	return 1;
}


- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
	return 20;
}


- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
	static NSString *myItemTileIdentifier = @"BoardItemTileID";
	
    SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myItemTileIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"BoardItemTile" owner:self options:nil];
        cell = _itemCell;
        self.itemCell = nil;
    }
    
    UIImageView *itemImage;
    UILabel *itemLabel;
    UILabel *itemPlace;
    UILabel *itemPrice;
    
    itemImage = (UIImageView *)[cell viewWithTag:1];
    itemLabel = (UILabel *)[cell viewWithTag:2];
    itemPlace = (UILabel *)[cell viewWithTag:3];
    itemPrice = (UILabel *)[cell viewWithTag:4];    
    
    // configure custom data
    //    [itemLabel setText:[NSString stringWithFormat:@"Item %d", indexPath.row]];
    
    return cell;
}


- (UIView *)collectionView:(SSCollectionView *)aCollectionView viewForHeaderInSection:(NSUInteger)section {
	SSLabel *header = [[SSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 40.0f)];
	header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //	header.text = [NSString stringWithFormat:@"Section %i", section + 1];
	header.textEdgeInsets = UIEdgeInsetsMake(0.0f, 19.0f, 0.0f, 19.0f);
	header.shadowColor = [UIColor whiteColor];
	header.shadowOffset = CGSizeMake(0.0f, 1.0f);
	header.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
	return header;
}


#pragma mark - SSCollectionViewDelegate

- (CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section {
	return CGSizeMake(145.0f, 186.0f);
}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"ShowItemView" sender:self];
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
	return 0.0f;
}


@end
