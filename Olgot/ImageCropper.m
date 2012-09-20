//
//  ImageCropper.m
//  Olgot
//
//  Created by Raed Hamam on 9/20/12.
//  Copyright (c) 2012 Not Another Fruit. All rights reserved.
//

#import "ImageCropper.h"

@implementation ImageCropper

@synthesize scrollView, imageView;
@synthesize delegate;

- (id)initWithImage:(UIImage *)image {
	self = [super init];
	
	if (self) {
		
		
        image = [image scaleWithMaxSize:600.0 quality:kCGInterpolationHigh];
        rawImage = image;
//        thumbImage = [image scaleWithMaxSize:60.0 quality:kCGInterpolationLow];
        
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 40.0, 320.0, 426.0)];
		[scrollView setBackgroundColor:[UIColor blackColor]];
		[scrollView setDelegate:self];
		[scrollView setShowsHorizontalScrollIndicator:NO];
		[scrollView setShowsVerticalScrollIndicator:NO];
		[scrollView setMaximumZoomScale:2.0];
		
		imageView = [[UIImageView alloc] initWithImage:image];
		
		CGRect rect;
		rect.size.width = image.size.width;
		rect.size.height = image.size.height;
		NSLog(@"image size %f,%f",image.size.width,image.size.height);
		[imageView setFrame:rect];
		
		[scrollView setContentSize:[imageView frame].size];
        if (image.size.width > image.size.height) {
            NSLog(@"Landscape image");
            [scrollView setContentInset:UIEdgeInsetsMake(93.0, 0.0, 0.0, 0.0)];
        }else{
            NSLog(@"portrait image");
        }
        
		[scrollView setMinimumZoomScale:[scrollView frame].size.width / [imageView frame].size.width];
		[scrollView setZoomScale:[scrollView minimumZoomScale]];
		[scrollView addSubview:imageView];
		
		[[self view] addSubview:scrollView];
        
        UIImage *trimSquare = [UIImage imageNamed:@"trim-square"];
        UIImageView *trimSquareIV = [[UIImageView alloc] initWithImage:trimSquare];
        [trimSquareIV setFrame:CGRectMake(0.0, 40.0, 320.0, 426.0)];
        [self.view addSubview:trimSquareIV];
        
        [self addFilterButtons];
		
		UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
		[navigationBar setBarStyle:UIBarStyleBlack];
		[navigationBar setTranslucent:NO];
		
		UINavigationItem *aNavigationItem = [[UINavigationItem alloc] initWithTitle:@"Make It Pretty"];
		[aNavigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCropping)]];
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishCropping)];
        [doneBtn setTintColor:[UIColor redColor]];
        
		[aNavigationItem setRightBarButtonItem:doneBtn];
		
		[navigationBar setItems:[NSArray arrayWithObject:aNavigationItem]];
		
		[[self view] addSubview:navigationBar];
        
//        [self populateFilters];
		
	}
	
	return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

-(void)addFilterButtons{
    filterButtons = [[NSMutableArray alloc] init];
    
    UIButton *normalBtn = [[UIButton alloc] initWithFrame:CGRectMake(30.0, 400.0, 60.0, 60.0)];
    [normalBtn setTitle:@"Normal" forState:UIControlStateNormal];
    [normalBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [normalBtn setBackgroundImage:[UIImage imageNamed:@"normal-effect"] forState:UIControlStateNormal];
    [normalBtn addTarget:self action:@selector(addEffect:) forControlEvents:UIControlEventTouchUpInside];
//    [normalBtn setBackgroundColor:[UIColor orangeColor]];
    [filterButtons addObject:normalBtn];
    
    UIButton *sepiaBtn = [[UIButton alloc] initWithFrame:CGRectMake(100.0, 400.0, 60.0, 60.0)];
    [sepiaBtn setTitle:@"Sepia" forState:UIControlStateNormal];
    [sepiaBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [sepiaBtn setBackgroundImage:[UIImage imageNamed:@"sepia-effect"] forState:UIControlStateNormal];
//    [sepiaBtn setBackgroundColor:[UIColor orangeColor]];
    [sepiaBtn addTarget:self action:@selector(addEffect:) forControlEvents:UIControlEventTouchUpInside];
    [filterButtons addObject:sepiaBtn];
    
    UIButton *vignetteBtn = [[UIButton alloc] initWithFrame:CGRectMake(170.0, 400.0, 60.0, 60.0)];
    [vignetteBtn setTitle:@"Vignette" forState:UIControlStateNormal];
    [vignetteBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [vignetteBtn setBackgroundImage:[UIImage imageNamed:@"vignette-effect"] forState:UIControlStateNormal];
//    [vignetteBtn setBackgroundColor:[UIColor orangeColor]];
    [vignetteBtn addTarget:self action:@selector(addEffect:) forControlEvents:UIControlEventTouchUpInside];
    [filterButtons addObject:vignetteBtn];
    
    UIButton *vibranceBtn = [[UIButton alloc] initWithFrame:CGRectMake(240.0, 400.0, 60.0, 60.0)];
    [vibranceBtn setTitle:@"Vibrance" forState:UIControlStateNormal];
    [vibranceBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [vibranceBtn setBackgroundImage:[UIImage imageNamed:@"vibrance-effect"] forState:UIControlStateNormal];
//    [vibranceBtn setBackgroundColor:[UIColor orangeColor]];
    [vibranceBtn addTarget:self action:@selector(addEffect:) forControlEvents:UIControlEventTouchUpInside];
    [filterButtons addObject:vibranceBtn];
    
    
    for (UIButton *mFilter in filterButtons) {
        [self.view addSubview:mFilter];
    }
}

-(void)populateFilters
{
    filtersArray = [[NSMutableArray alloc] init];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *beginImage = [CIImage imageWithData:UIImagePNGRepresentation(thumbImage)];
    
    [filtersArray addObject:[CIFilter filterWithName:@"CISepiaTone"
                                      keysAndValues: kCIInputImageKey, beginImage,
                            @"inputIntensity", [NSNumber numberWithFloat:0.8], nil]];
    
    [filtersArray addObject:[CIFilter filterWithName:@"CIVignette"
                                       keysAndValues: kCIInputImageKey, beginImage,
                             @"inputIntensity", [NSNumber numberWithFloat:1.0], @"inputRadius",[NSNumber numberWithFloat:2.0], nil]];
    
    [filtersArray addObject:[CIFilter filterWithName:@"CIColorControls"
                                       keysAndValues:
                             kCIInputImageKey, beginImage,
                             @"inputBrightness", [NSNumber numberWithFloat:0.0],
                             @"inputContrast", [NSNumber numberWithFloat:1.2],
                             @"inputSaturation", [NSNumber numberWithFloat:1.2],
                             nil]];
    
    int i = 1;
    for (CIFilter *mFilter in filtersArray) {
        CIImage *outputImage = [mFilter outputImage];
        
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage* newImage = [UIImage imageWithCGImage:cgimg];
        
        CGImageRelease(cgimg);

        [[filterButtons objectAtIndex:i] setBackgroundImage:newImage forState:UIControlStateNormal];
        i++;
    }
    
    [[filterButtons objectAtIndex:0] setBackgroundImage:rawImage forState:UIControlStateNormal];
}

-(void)addEffect:(id)effectButton
{
    UIButton *mBtn = (UIButton*)effectButton;
    
    
    if ([[[mBtn titleLabel]text]isEqual:@"Normal"]) {
        [self.imageView setImage:rawImage];
        
    }else if ([[[mBtn titleLabel]text]isEqual:@"Sepia"]){
        CIImage *beginImage = [CIImage imageWithData:UIImagePNGRepresentation(rawImage)];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        
        CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                      keysAndValues: kCIInputImageKey, beginImage,
                            @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
        CIImage *outputImage = [filter outputImage];
        
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage* newImage = [UIImage imageWithCGImage:cgimg];
        
        CGImageRelease(cgimg);
        
        [self.imageView setImage:newImage];
    }
    else if ([[[mBtn titleLabel]text]isEqual:@"Vignette"]){
        CIImage *beginImage = [CIImage imageWithData:UIImagePNGRepresentation(rawImage)];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        
        CIFilter *filter = [CIFilter filterWithName:@"CIVignette"
                                      keysAndValues: kCIInputImageKey, beginImage,
                            @"inputIntensity", [NSNumber numberWithFloat:1.0], @"inputRadius",[NSNumber numberWithFloat:2.0], nil];
        
        
        CIImage *outputImage = [filter outputImage];
        
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage* newImage = [UIImage imageWithCGImage:cgimg];
        
        CGImageRelease(cgimg);
        
        [self.imageView setImage:newImage];
    }
    else if ([[[mBtn titleLabel]text]isEqual:@"Vibrance"]){
        CIImage *beginImage = [CIImage imageWithData:UIImagePNGRepresentation(rawImage)];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        
        CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"
                                      keysAndValues:
                            kCIInputImageKey, beginImage,
                            @"inputBrightness", [NSNumber numberWithFloat:0.0],
                            @"inputContrast", [NSNumber numberWithFloat:1.2],
                            @"inputSaturation", [NSNumber numberWithFloat:1.2],
                            nil];
        CIImage *outputImage = [filter outputImage];
        
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage* newImage = [UIImage imageWithCGImage:cgimg];
        
        CGImageRelease(cgimg);
        
        [self.imageView setImage:newImage];
    }

    
}

- (void)cancelCropping {
	[delegate imageCropperDidCancel:self];
}

- (void)finishCropping {
	float zoomScale = 1.0 / [scrollView zoomScale];
	
	CGRect rect;
	rect.origin.x = [scrollView contentOffset].x * zoomScale;
	rect.origin.y = ([scrollView contentOffset].y + 53) * zoomScale ;
//	rect.size.width = [scrollView bounds].size.width * zoomScale;
//	rect.size.height = [scrollView bounds].size.height * zoomScale;
    rect.size.width = 320.0 * zoomScale;
	rect.size.height = 320.0 * zoomScale;
	
	CGImageRef cr = CGImageCreateWithImageInRect([[imageView image] CGImage], rect);
	
	UIImage *cropped = [UIImage imageWithCGImage:cr];
	
	CGImageRelease(cr);
	
	[delegate imageCropper:self didFinishCroppingWithImage:cropped];
//    UIImageWriteToSavedPhotosAlbum(cropped, nil, nil, nil);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imageView;
}

-(void)logAllFilters {
    NSArray *properties = [CIFilter filterNamesInCategory:
                           kCICategoryBuiltIn];
    NSLog(@"%@", properties);
    for (NSString *filterName in properties) {
        CIFilter *fltr = [CIFilter filterWithName:filterName];
        NSLog(@"%@", [fltr attributes]);
    }
}

@end