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
//      scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, -20.0, 320.0, 426.0)];
        if(self.view.frame.size.height >= 540)
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 40.0, 320.0, self.view.frame.size.height-182.0)];
        else
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
if(self.view.frame.size.height >= 540)
 [scrollView setMinimumZoomScale:0.67];
    else
{
            [scrollView setContentInset:UIEdgeInsetsMake(53.0, 0.0, 0.0, 0.0)];
            [scrollView setMinimumZoomScale:[scrollView frame].size.height / [imageView frame].size.width];
}
        }else{
            NSLog(@"portrait image");
            [scrollView setMinimumZoomScale:[scrollView frame].size.width / [imageView frame].size.width];
        }
        
        [scrollView setZoomScale:[scrollView minimumZoomScale]];
        [scrollView addSubview:imageView];
        
        [[self view] addSubview:scrollView];
        
        UIImage *trimSquare = [UIImage imageNamed:@"trim-square"];
        UIImageView *trimSquareIV = [[UIImageView alloc] initWithImage:trimSquare];
//      [trimSquareIV setFrame:CGRectMake(0.0, -20.0, 320.0, 480.0)];
        [trimSquareIV setFrame:CGRectMake(0.0, -20.0, 320.0, self.view.frame.size.height)];
        
        [self.view addSubview:trimSquareIV];
        
        [self addFilterButtons];
        
        //add toolbar
        UIToolbar *toolBar;
        if(self.view.frame.size.height >= 540)
        {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 496.0, 320.0, 52.0)];
        }
            else
            toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 406.0, 320.0, 52.0)];
        CGRect toolBarFrame = toolBar.frame;
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
    [self initializeFilters];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

-(void)initializeFilters
{
    //sharpness
    shaprenFilter = [[GPUImageSharpenFilter alloc] init];
    [shaprenFilter setSharpness:0.5];   //def:0 max:4.0 min:-4.0
    
    //brightness
    brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [brightnessFilter setBrightness:0.2];   //def:0 max:1.0 min:-1.0
    
    //saturation
    saturationFilter = [[GPUImageSaturationFilter alloc] init];
    [saturationFilter setSaturation:1.5];   //def:1.0 max:2.0 min:0.0
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
    
    if(self.view.frame.size.height >= 540)
        yVal = 330.0+60.0;
    
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
    
    switch ([mBtn tag]) {
        case 0:
            //normal
            
            [self.imageView setImage:rawImage];
            break;
            
            
        case 1:
            //crisp
            filteredImage = [shaprenFilter imageByFilteringImage:rawImage];
            [self.imageView setImage:filteredImage];
            break;
            
                        
        case 2:
            //bright
            filteredImage = [brightnessFilter imageByFilteringImage:rawImage];
            [self.imageView setImage:filteredImage];
            break;

           
        case 3:
            //vibrant
            filteredImage = [saturationFilter imageByFilteringImage:rawImage];
            [self.imageView setImage:filteredImage];
            
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