//
//  ViewController.m
//  imageDemo
//
//  Created by amol on 14/04/15.
//  Copyright (c) 2015 amolchavan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController{
    UIImage *img;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        _imgView.image = [UIImage imageNamed:@"image"];

    _txtTop.delegate = self;
    _txtBottom.delegate = self;
    [self imageShow:_txtTop];
    [self imageShow:_txtBottom];

    [_txtTop addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    
    [_txtBottom addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
{
    
    UIFont *font = [UIFont boldSystemFontOfSize:20];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect) withFont:font];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self imageShow:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}


-(void)textFieldDidChange:(UITextField*)txt{
    [self imageShow:txt];
}

#pragma mark

-(void)imageShow:(UITextField*)text{
    UIImageView *imageView = _imgView;
//    imageView.image = [UIImage imageNamed:@"image"];
    UIImage *img1 = imageView.image;
    CGPoint atPoint ;
    if (text == _txtTop) {
        atPoint = CGPointMake(100, 10);
    }else if (text == _txtBottom){
        atPoint = CGPointMake(100, 150);
    }
    img = [self drawText:text.text
                          inImage:img1
                          atPoint:atPoint];
    _imgView.image = img;
    NSData *imageData = UIImagePNGRepresentation(img);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"cached"]];
    
    NSLog((@"pre writing to file"));
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
    }
    else
    {
        NSLog((@"the cachedImagedPath is %@",imagePath));
    }
    imageData = UIImageJPEGRepresentation(img, 1.0);
    NSString *encodedString = [imageData base64Encoding];
    NSLog(@"%@",encodedString);
}
@end
