//
//  olgotLovelyViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/11/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotLovelyViewController.h"
#import "UIImageView+AFNetworking.h"
#import "olgotItem.h"
#import "olgotItemViewController.h"

@interface olgotLovelyViewController ()

@end

@implementation olgotLovelyViewController


@synthesize itemTile = _itemTile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadItems {
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: @"0", @"lat", @"0", @"long", nil];
    NSString* resourcePath = [@"/hotitems/" appendQueryParams:myParams];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
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
    
    [self loadItems];
    
    
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

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded items: %@", objects);
    if([objectLoader.response isOK]){
        _items = objects;
        [self.collectionView reloadData];
    }
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"Hit error: %@", error);
}

#pragma mark - SSCollectionViewDataSource

- (NSUInteger)numberOfSectionsInCollectionView:(SSCollectionView *)aCollectionView {
	return 1;
}


- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
	return [_items count];
}


- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
	static NSString *myItemTileIdentifier = @"LovelyItemTileID";
	
    SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myItemTileIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"LovelyItemTile" owner:self options:nil];
        cell = _itemTile;
        self.itemTile = nil;
    }
    
    UIImageView *itemImage;
    UILabel *itemLabel;
    
    itemImage = (UIImageView *)[cell viewWithTag:1];
    [itemImage setImageWithURL:[NSURL URLWithString:[[_items objectAtIndex:indexPath.row] itemPhotoUrl]]];
    
    itemLabel = (UILabel *)[cell viewWithTag:2]; //description
    [itemLabel setText:[[_items objectAtIndex:indexPath.row] itemDescription]];
    
    itemLabel = (UILabel *)[cell viewWithTag:3]; //venue
    [itemLabel setText:[[_items objectAtIndex:indexPath.row] venueName_En]];
    
    itemLabel = (UILabel *)[cell viewWithTag:4]; //price
    [itemLabel setText:[NSString stringWithFormat:@"%d %@",
                        [[[_items objectAtIndex:indexPath.row] itemPrice] integerValue],
                        [[_items objectAtIndex:indexPath.row] countryCurrencyShortName]                  
                        ]];

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
