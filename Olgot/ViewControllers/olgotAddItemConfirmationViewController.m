//
//  olgotAddItemConfirmationViewController.m
//  Olgot
//
//  Created by Raed Hamam on 5/15/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "olgotAddItemConfirmationViewController.h"
#import "olgotItem.h"

@interface olgotAddItemConfirmationViewController ()

@end

@implementation olgotAddItemConfirmationViewController
@synthesize scrollView;
@synthesize itemImage;
@synthesize venueNameBtn;
@synthesize itemPriceLabel;
@synthesize gotButton;
@synthesize wantButton;
@synthesize likeButton;
@synthesize placeBigLabel;
@synthesize placeItemCountLabel;

@synthesize itemID = _itemID, itemKey = _itemKey, item = _item, venueID = _venueID, venueItemCount = _venueItemCount;



- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImage *finishImage30 = [UIImage imageNamed:@"btn-nav-finish"];
    
    UIButton *finishBtn = [[UIButton alloc] init];
    finishBtn.frame=CGRectMake(0,0,50,30);
    [finishBtn setBackgroundImage:finishImage30 forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishUpload) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:finishBtn];
    
    [self.scrollView setHidden:YES];
    [self loadItemData];
}

-(void)loadItemData
{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    //    NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: [_item itemID], @"item", [_item itemKey], @"key", nil];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* myParams = [NSDictionary dictionaryWithObjectsAndKeys: _itemID, @"item", _itemKey, @"key", [defaults objectForKey:@"userid"], @"id", nil];
    
    //likes
    NSString* resourcePath = @"/item/";
    [objectManager loadObjectsAtResourcePath:[resourcePath stringByAppendingQueryParameters:myParams] delegate:self];
}

-(void)configureView
{
    [self.venueNameBtn setTitle:[_item venueName_En] forState:UIControlStateNormal];
    [self.itemPriceLabel setText:[NSString stringWithFormat:@"%@ %@",[_item itemPrice],[_item countryCurrencyShortName]]];
    
    if ([[_item iLike] isEqual:[NSNumber numberWithInt:1]]) {
        NSLog(@"user likes this");
        [self.likeButton setImage:[UIImage imageNamed:@"icon-item-action-like-active"] forState:UIControlStateNormal];
    }else {
        [self.likeButton setImage:[UIImage imageNamed:@"icon-item-action-like"] forState:UIControlStateNormal];
    }
    
    if ([[_item iWant] isEqual:[NSNumber numberWithInt:1]]) {
        NSLog(@"user wants this");
        [self.wantButton setImage:[UIImage imageNamed:@"icon-item-action-want-active"] forState:UIControlStateNormal];
    }else {
        [self.wantButton setImage:[UIImage imageNamed:@"icon-item-action-want"] forState:UIControlStateNormal];
    }
    
    if ([[_item iGot] isEqual:[NSNumber numberWithInt:1]]) {
        NSLog(@"user got this");
        [self.gotButton setImage:[UIImage imageNamed:@"icon-item-action-got-active"] forState:UIControlStateNormal];
    }else {
        [self.gotButton setImage:[UIImage imageNamed:@"icon-item-action-got"] forState:UIControlStateNormal];
    }
    
    [self.placeBigLabel setText:[_item venueName_En]];
    [self.placeItemCountLabel setText:[NSString stringWithFormat:@"See more items here (%@ items)",_venueItemCount]];
}

-(void)finishUpload
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setItemImage:nil];
    [self setVenueNameBtn:nil];
    [self setItemPriceLabel:nil];
    [self setGotButton:nil];
    [self setWantButton:nil];
    [self setLikeButton:nil];
    [self setPlaceBigLabel:nil];
    [self setPlaceItemCountLabel:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"resource path: %@",[request resourcePath]);
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
    if ([request isPOST]) {  
        
        if ([response isJSON]) {
            
            if([response isOK]){
                if ([[request resourcePath] isEqual:@"/likeitem/"]) {
                    NSLog(@"succesful like");
                    [_item setILike:[NSNumber numberWithInt:1]];
                }else if ([[request resourcePath] isEqual:@"/wantitem/"]) {
                    NSLog(@"succesful want");
                    [_item setIWant:[NSNumber numberWithInt:1]];
                }else if ([[request resourcePath] isEqual:@"/gotitem/"]) {
                    NSLog(@"succesful got");
                    [_item setIGot:[NSNumber numberWithInt:1]];
                }
                NSLog(@"Got a JSON response back from our POST! %@", [response bodyAsString]);
                
                [self configureView];
            }else {
                
            }
        }  
        
    }else if ([request isDELETE]) {
        if ([response isJSON]) {
            
            if([response isOK]){
                id userData = [request userData];
                
                if ([userData isEqual:@"unlike"]) {
                    NSLog(@"succesful unlike");
                    [_item setILike:[NSNumber numberWithInt:0]];
                }else if ([userData isEqual:@"unwant"]) {
                    NSLog(@"succesful unwant");
                    [_item setIWant:[NSNumber numberWithInt:0]];
                }else if ([userData isEqual:@"ungot"]) {
                    NSLog(@"succesful ungot");
                    [_item setIGot:[NSNumber numberWithInt:0]];
                }
                NSLog(@"Got a JSON response back from our DELETE! %@", [response bodyAsString]);
                
                [self configureView];
                
            }else {
                
            }
        }
    }
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"loaded item %@", objects);
    _item = [objects objectAtIndex:0];
    [self.itemImage setImageWithURL:[NSURL URLWithString:[_item itemPhotoUrl]]];
    NSLog(@"user actions: %@ %@ %@",[_item iLike],[_item iWant],[_item iGot]);
    
    [self configureView];
    [self.scrollView setHidden:NO];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"Hit error: %@", error);
}


-(void)showPopup:(NSString*)sender
{
    NSLog(@"show action popup");
    UIImageView* actionPopup;
    if ([sender isEqualToString:@"like"]) {
        if ([[_item iLike] isEqual:[NSNumber numberWithInt:1]]) {
            return;
        }
        actionPopup = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg-action-like"]];
    } else if([sender isEqualToString:@"want"]){
        if ([[_item iWant] isEqual:[NSNumber numberWithInt:1]]) {
            return;
        }
        actionPopup = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg-action-want"]];       
    } else if([sender isEqualToString:@"got"]){
        if ([[_item iGot] isEqual:[NSNumber numberWithInt:1]]) {
            return;
        }
        actionPopup = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg-action-got"]];
    }else {
        return;
    }
    
    CGRect b = self.view.bounds;
    
    actionPopup.frame = CGRectMake((b.size.width - 0) / 2, (b.size.height - 0) / 2, 0, 0);
    [self.view addSubview: actionPopup];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    actionPopup.frame = CGRectMake((b.size.width - 113) / 2, (b.size.height - 113) / 2, 113, 113);
    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationCurveEaseOut animations:^{
        actionPopup.alpha = 0.0;} completion:^(BOOL finished){[actionPopup removeFromSuperview];}];
    
}

-(void)sendItemAction:(NSString*)sender
{
    NSLog(@"%@ item with id %@", sender, [_item itemID]);
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [_item itemID], @"item",
                            [defaults objectForKey:@"userid"], @"id",
                            nil];
    
    [[RKClient sharedClient] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if ([sender isEqualToString:@"like"]) {
        if ([[_item iLike] isEqual:[NSNumber numberWithInt:1]]) {
            [[[RKClient sharedClient] delete:[@"/likeitem/" stringByAppendingQueryParameters:params] delegate:self] setUserData:@"unlike"];
        }else {
            [[RKClient sharedClient] post:@"/likeitem/" params:params delegate:self];
        }
        
    } else if([sender isEqualToString:@"want"]){
        if ([[_item iWant] isEqual:[NSNumber numberWithInt:1]]) {
            [[[RKClient sharedClient] delete:[@"/wantitem/" stringByAppendingQueryParameters:params] delegate:self]  setUserData:@"unwant"];
        }else {
            [[RKClient sharedClient] post:@"/wantitem/" params:params delegate:self];
        }
    } else if([sender isEqualToString:@"got"]){
        if ([[_item iGot] isEqual:[NSNumber numberWithInt:1]]) {
            [[[RKClient sharedClient] delete:[@"/gotitem/" stringByAppendingQueryParameters:params] delegate:self]  setUserData:@"ungot"];
        }else {
            [[RKClient sharedClient] post:@"/gotitem/" params:params delegate:self];
        }
    }else {
        return;
    }
    
}


- (IBAction)gotPressed:(id)sender {
    [self performSelector:@selector(showPopup:) withObject:@"got"];
    [self performSelector:@selector(sendItemAction:) withObject:@"got"];
}

- (IBAction)wantPressed:(id)sender {
    [self performSelector:@selector(showPopup:) withObject:@"want"];
    [self performSelector:@selector(sendItemAction:) withObject:@"want"];
}

- (IBAction)likePressed:(id)sender {
    [self performSelector:@selector(showPopup:) withObject:@"like"];
    [self performSelector:@selector(sendItemAction:) withObject:@"like"];
}

- (IBAction)venueNamePressed:(id)sender {
    
}
@end
