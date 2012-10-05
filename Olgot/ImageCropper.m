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
//        rawImage = [image scaleWithMaxSize:426.0 quality:kCGInterpolationDefault];
        rawImage = image;
        image = nil;
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, -20.0, 320.0, 426.0)];
        [scrollView setBackgroundColor:[UIColor blackColor]];
        [scrollView setDelegate:self];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setMaximumZoomScale:2.0];
        
        imageView = [[UIImageView alloc] initWithImage:rawImage];
        
        CGRect rect;
        rect.size.width = rawImage.size.width;
        rect.size.height = rawImage.size.height;
        NSLog(@"image size %f,%f",rawImage.size.width,rawImage.size.height);
        [imageView setFrame:rect];
        
        [scrollView setContentSize:[imageView frame].size];
        if (rawImage.size.width > rawImage.size.height) {
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
        [trimSquareIV setFrame:CGRectMake(0.0, -20.0, 320.0, 480)];
        [self.view addSubview:trimSquareIV];
        
        [self addFilterButtons];
        
        //add toolbar
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 406.0, 320.0, 52.0)];
        UIBarButtonItem *retakeBtn = [[UIBarButtonItem alloc] initWithTitle:@"Retake" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelCropping)];
        UIBarButtonItem *spacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(finishCropping)];
        
        NSArray *barItems = [[NSArray alloc] initWithObjects:retakeBtn, spacing, doneBtn, nil];
        [toolBar setItems:barItems];
        [self.view addSubview:toolBar];
		
	}
	
	return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    context = [CIContext contextWithOptions:nil];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}


-(void)addFilterButtons{
    filterButtons = [[NSMutableArray alloc] init];
    float btnWidth = 59.0;
    float btnHeight = 58.0;
    float yVal = 330.0;
    float hSpacing = 15.0;
    float initialX = 20.0;
    float labelYSpacing = 4.0;
    float labelHeight = 14.0;
    
    //generate buttons
    UIButton *normalBtn = [[UIButton alloc] initWithFrame:CGRectMake(initialX, yVal, btnWidth, btnHeight)];
    [normalBtn setTag:0];
    [normalBtn setBackgroundImage:[UIImage imageNamed:@"filter-normal"] forState:UIControlStateNormal];
    [normalBtn addTarget:self action:@selector(addEffect:) forControlEvents:UIControlEventTouchUpInside];
    [filterButtons addObject:normalBtn];
    
    initialX = initialX + btnWidth + hSpacing;
    UIButton *crispBtn = [[UIButton alloc] initWithFrame:CGRectMake(initialX, yVal, btnWidth, btnHeight)];
    [crispBtn setTag:1];
    [crispBtn setBackgroundImage:[UIImage imageNamed:@"filter-crisp"] forState:UIControlStateNormal];
    [crispBtn addTarget:self action:@selector(addEffect:) forControlEvents:UIControlEventTouchUpInside];
    [filterButtons addObject:crispBtn];
    
    initialX = initialX + btnWidth + hSpacing;
    UIButton *brightBtn = [[UIButton alloc] initWithFrame:CGRectMake(initialX, yVal, btnWidth, btnHeight)];
    [brightBtn setTag:2];
    [brightBtn setBackgroundImage:[UIImage imageNamed:@"filter-bright"] forState:UIControlStateNormal];
    [brightBtn addTarget:self action:@selector(addEffect:) forControlEvents:UIControlEventTouchUpInside];
    [filterButtons addObject:brightBtn];
    
    initialX = initialX + btnWidth + hSpacing;
    UIButton *vibrantBtn = [[UIButton alloc] initWithFrame:CGRectMake(initialX, yVal, btnWidth, btnHeight)];
    [vibrantBtn setTag:3];
    [vibrantBtn setBackgroundImage:[UIImage imageNamed:@"filter-vibrant"] forState:UIControlStateNormal];
    [vibrantBtn addTarget:self action:@selector(addEffect:) forControlEvents:UIControlEventTouchUpInside];
    [filterButtons addObject:vibrantBtn];
    
    //generate labels
    NSMutableArray *filterLabels = [[NSMutableArray alloc] init];
    
    initialX = 20.0;
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(initialX, yVal + btnHeight + labelYSpacing, btnWidth, labelHeight)];
    [label1 setText:@"Normal"];
    [filterLabels addObject:label1];
    
    initialX = initialX + btnWidth + hSpacing;
    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(initialX, yVal + btnHeight + labelYSpacing, btnWidth, labelHeight)];
    [label2 setText:@"Crisp"];
    [filterLabels addObject:label2];
    
    initialX = initialX + btnWidth + hSpacing;
    UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(initialX, yVal + btnHeight + labelYSpacing, btnWidth, labelHeight)];
    [label3 setText:@"Bright"];
    [filterLabels addObject:label3];
    
    initialX = initialX + btnWidth + hSpacing;
    UILabel* label4 = [[UILabel alloc] initWithFrame:CGRectMake(initialX, yVal + btnHeight + labelYSpacing, btnWidth, labelHeight)];
    [label4 setText:@"Vibrant"];
    [filterLabels addObject:label4];
    
    for (UIButton *mFilter in filterButtons) {
        [self.view addSubview:mFilter];
    }
    
    for (UILabel *mLabel in filterLabels) {
        [mLabel setFont:[UIFont systemFontOfSize:12.0]];
        [mLabel setBackgroundColor:[UIColor clearColor]];
        [mLabel setTextAlignment:UITextAlignmentCenter];
        [self.view addSubview:mLabel];
    }
    
    filterButtons = nil;
    filterLabels = nil;
}

-(void)addEffect:(id)effectButton
{
    UIButton *mBtn = (UIButton*)effectButton;
    
    CIImage *beginImage;
    CIFilter *filter;
    CIImage *outputImage;
    CGImageRef cgimg;
    
    switch ([mBtn tag]) {
        case 0:
            //normal
            
            [self.imageView setImage:rawImage];
            break;
            
            
        case 1:
            //crisp
            
            beginImage = [CIImage imageWithData:UIImagePNGRepresentation(rawImage)];
            
//            filter = [CIFilter filterWithName:@"CIColorControls"];
//            
//            [filter setValue:beginImage forKey:@"inputImage"];
//            [filter setValue:[NSNumber numberWithFloat:0.0f] forKey:@"inputBrightness"];    //default: 0.0, max:1.0, min:-1.0
//            [filter setValue:[NSNumber numberWithFloat:1.1f] forKey:@"inputContrast"];      //default: 1.0, max:4.0, min:0.0
//            [filter setValue:[NSNumber numberWithFloat:1.0f] forKey:@"inputSaturation"];    //default: 1.0, max:2.0, min:0.0
            
            filter = [CIFilter filterWithName:@"CIHighlightShadowAdjust"];
            [filter setValue:beginImage forKey:@"inputImage"];
            [filter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputHighlightAmount"];
            [filter setValue:[NSNumber numberWithFloat:1.5] forKey:@"inputShadowAmount"];
            
            outputImage = [filter outputImage];
            
            cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
            filteredImage = [UIImage imageWithCGImage:cgimg];
            
            CGImageRelease(cgimg);
            
            [self.imageView setImage:filteredImage];
            outputImage = nil;
            break;
            
                        
        case 2:
            //bright
            
            beginImage = [CIImage imageWithData:UIImagePNGRepresentation(rawImage)];
            
            filter = [CIFilter filterWithName:@"CIExposureAdjust"];
            
            [filter setValue:beginImage forKey:@"inputImage"];
            [filter setValue:[NSNumber numberWithFloat:1.0f] forKey:@"inputEV"];    //default: 0.0, max: 10.0, min:-10.0
            
            outputImage = [filter outputImage];
            
            cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
            filteredImage = [UIImage imageWithCGImage:cgimg];
            
            CGImageRelease(cgimg);
            
            [self.imageView setImage:filteredImage];
            outputImage = nil;
            break;

           
        case 3:
            //vibrant
            
            beginImage = [CIImage imageWithData:UIImagePNGRepresentation(rawImage)];
            
//            filter = [CIFilter filterWithName:@"CIVibrance"];
//            [filter setValue:beginImage forKey:@"inputImage"];
//            [filter setValue:[NSNumber numberWithFloat:0.5f] forKey:@"inputAmount"];    //default: 0.0, max:1.0, min:-1.0
            
            filter = [CIFilter filterWithName:@"CIColorControls"];
            [filter setValue:beginImage forKey:@"inputImage"];
            [filter setValue:[NSNumber numberWithFloat:0.0f] forKey:@"inputBrightness"];    //default: 0.0, max:1.0, min:-1.0
            [filter setValue:[NSNumber numberWithFloat:1.1f] forKey:@"inputContrast"]; 
            [filter setValue:[NSNumber numberWithFloat:1.2f] forKey:@"inputSaturation"]; 

            outputImage = [filter outputImage];
            
            cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
            filteredImage = [UIImage imageWithCGImage:cgimg];
            
            CGImageRelease(cgimg);
            
            [self.imageView setImage:filteredImage];
            outputImage = nil;
            break;
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

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

@end