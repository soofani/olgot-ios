//
//  olgotProfileViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotProfileViewController.h"

@interface olgotProfileViewController ()

@end

@implementation olgotProfileViewController

@synthesize profileCardTile = _profileCardTile, profileItemTile = _profileItemTile;

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
	static NSString *myProfileItemTileIdentifier = @"ProfileItemTileID";
    static NSString *myProfileCardIdentifier = @"ProfileCardID";
    
    if (indexPath.section == 0) {
        SSCollectionViewItem *cell1 = [aCollectionView dequeueReusableItemWithIdentifier:myProfileCardIdentifier];
        
        if (cell1 == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"profileViewPersonCard" owner:self options:nil];
            cell1 = _profileCardTile;
            self.profileCardTile = nil;
        }
        
        // configure custom data
        
        return cell1;
    }
    else {
        SSCollectionViewItem *cell2 = [aCollectionView dequeueReusableItemWithIdentifier:myProfileItemTileIdentifier];
        
        if (cell2 == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"profileViewItemTile" owner:self options:nil];
            cell2 = _profileItemTile;
            self.profileItemTile = nil;
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
        return CGSizeMake(300.0f, 138.0f);
    }else{
        return CGSizeMake(145.0f, 186.0f);
    }
	
}

- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1){
        [self performSegueWithIdentifier:@"ShowItemView" sender:self];
    }
    
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
    if (section == 0) {
        return 0.0f;
    }else{
        return 0.0f;
    }
	
}


@end
