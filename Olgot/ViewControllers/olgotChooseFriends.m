//
//  olgotChooseFriends.m
//  Olgot
//
//  Created by Raed Hamam on 5/23/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotChooseFriends.h"

@implementation olgotChooseFriends

@synthesize headerCell = _headerCell, personCell = _personCell, footerCell = _footerCell;

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
    self.collectionView.rowSpacing = 0.0f;
    
    self.collectionView.scrollView.contentInset = UIEdgeInsetsMake(10.0,0.0,0.0,0.0);
    
    self.collectionView.extremitiesStyle = SSCollectionViewExtremitiesStyleScrolling;
    
    UIImage *finishImage30 = [UIImage imageNamed:@"btn-nav-finish"];
    
    UIButton *finishBtn = [[UIButton alloc] init];
    finishBtn.frame=CGRectMake(0,0,50,30);
    [finishBtn setBackgroundImage:finishImage30 forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishSignup) forControlEvents:UIControlEventTouchUpInside];
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:finishBtn];
    
}

-(void)finishSignup
{
    [self dismissModalViewControllerAnimated:YES];
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
    if(section == 0){
        return 1;
    }else if (section == 2) {
        return 1;
    }else {
        return 5;
    }
}


- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *myHeaderTileIdentifier = @"headerTileID";
    static NSString *myPersonTileIdentifier = @"personTileID";
    static NSString *myFooterTileIdentifier = @"footerTileID";
    
    if (indexPath.section == 0) {
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myHeaderTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"signupFriendsHeaderCell" owner:self options:nil];
            cell = _headerCell;
            self.headerCell = nil;
        }
        
        return cell;
    }else if (indexPath.section == 2) {
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myFooterTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"signupFriendsFooterCell" owner:self options:nil];
            cell = _footerCell;
            self.footerCell = nil;
        }
        
        return cell;
    }else{
        SSCollectionViewItem *cell = [aCollectionView dequeueReusableItemWithIdentifier:myPersonTileIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"signupFriendsPersonCell" owner:self options:nil];
            cell = _personCell;
            self.personCell = nil;
        }
        
        return cell;
    }
	
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
    if(section == 0){
        return CGSizeMake(300.0f, 60.0f);
    }else if (section == 2) {
        return CGSizeMake(300.0f, 44.0f);
    }else {
       return CGSizeMake(300.0f, 44.0f);
    }
    
	
}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section {
	return 0.0f;
}



@end
