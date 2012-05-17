//
//  olgotAddItemNearbyPlacesViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/15/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotAddItemNearbyPlacesViewController.h"

@interface olgotAddItemNearbyPlacesViewController ()

@end

@implementation olgotAddItemNearbyPlacesViewController

@synthesize placeNames = _placeNames;

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
    
    self.placeNames = [[NSArray alloc] 
                       initWithObjects:@"Bargo's", @"Charcoal",
                       @"Hayatt", @"Mcdonald's", @"Burger King", nil]; 
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.placeNames = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [self.placeNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"NearbyPlaceCell";
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    UIImage *cellImage = [UIImage imageNamed:@"icon-cat-cart.png"];
    cell.imageView.image = cellImage;
    NSString *placeString = [self.placeNames 
                             objectAtIndex: [indexPath row]];
    
    cell.textLabel.text = placeString;
    NSString *subtitle = [NSString stringWithString: 
                          @"some text about "];
    subtitle = [subtitle stringByAppendingString:placeString];
    cell.detailTextLabel.text = subtitle;
    return cell;
}



@end
