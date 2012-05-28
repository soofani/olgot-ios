//
//  olgotVenueViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/15/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotVenueViewController.h"

@interface olgotVenueViewController ()

@end

@implementation olgotVenueViewController

@synthesize venueCardTile = _venueCardTile, venueItemTile = _venueItemTile;

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
	// Do any additional setup after loading the view.
    
    // background
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [tempImageView setFrame:self.collectionView.frame]; 
    
    self.collectionView.backgroundView = tempImageView;
    self.collectionView.rowSpacing = 10.0f;
    self.collectionView.scrollView.contentInset = UIEdgeInsetsMake(10.0,0.0,0.0,0.0);
    
    self.collectionView.extremitiesStyle = SSCollectionViewExtremitiesStyleScrolling;
    
    UIImage *addImage30 = [UIImage imageNamed:@"btn-nav-add-item"];
    
    UIButton *addBtn = [[UIButton alloc] init];
    addBtn.frame=CGRectMake(0,0,35,30);
    [addBtn setBackgroundImage:addImage30 forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(showAddItemView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
}

- (void)showAddItemView
{
    [self performSegueWithIdentifier:@"ShowAddItem" sender:self];
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
	return 2;
}


- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 7;
    }
}


- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
	static NSString *myVenueItemTileIdentifier = @"VenueItemTileID";
    static NSString *myVenueCardIdentifier = @"VenueCardID";
    
    if (indexPath.section == 0) {
        SSCollectionViewItem *cell1 = [aCollectionView dequeueReusableItemWithIdentifier:myVenueCardIdentifier];
        
        if (cell1 == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"VenueCard" owner:self options:nil];
            cell1 = _venueCardTile;
            self.venueCardTile = nil;
        }
        
        // configure custom data
        
        return cell1;
    }
    else {
        SSCollectionViewItem *cell2 = [aCollectionView dequeueReusableItemWithIdentifier:myVenueItemTileIdentifier];
        
        if (cell2 == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"VenueItemTile" owner:self options:nil];
            cell2 = _venueItemTile;
            self.venueItemTile = nil;
        }
        
        UIImageView *tileImage;
        UILabel *tileLabel;
        
        tileImage = (UIImageView *)[cell2 viewWithTag:1];
        tileLabel = (UILabel *)[cell2 viewWithTag:2];
        
        [tileImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dummy%d%@",indexPath.row + 1,@".jpg"]]];
        
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
        return CGSizeMake(300.0f, 150.0f);
    }else{
        return CGSizeMake(145.0f, 186.0f);
    }
	
}

- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [self performSegueWithIdentifier:@"ShowItemView" sender:self];
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
    if (section == 0) {
        return 0.0f;
    }else{
        return 0.0f;
    }
	
}


@end
