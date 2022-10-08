

#import "DickColorPicker.h"

#define kHEIGHT (self.frame.size.height)*0.7
#define kWIDTH (self.frame.size.width)

#define kCBXBEGIN (_colorPickerType == ColorPickerTypeHorizontal) ? kHEIGHT * 0.2 : kWIDTH * 0.2

#define kRECTCOLOR (_colorPickerType == ColorPickerTypeHorizontal) ? CGRectMake(0, kHEIGHT * 0.2, kWIDTH, kHEIGHT * 0.6) : CGRectMake(kWIDTH * 0.2, 0, kWIDTH * 0.6, kHEIGHT)

#define kRECTBRIGHTER (_colorPickerType == ColorPickerTypeHorizontal) ? CGRectMake(0, (kHEIGHT * 0.2)*4, kWIDTH, kHEIGHT * 0.6) : CGRectMake((kWIDTH * 0.2)*4, 0, kWIDTH * 0.6, kHEIGHT)

@interface DickColorPicker ()

@property (nonatomic) CGFloat currentSelectionY;
@property (nonatomic) CGFloat currentBrigtherY;

@end

@implementation DickColorPicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentSelectionY = 0.0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// for when coming out of a nib
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.currentSelectionY = 0.0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    //draw wings
    [[UIColor blackColor] set];
    CGFloat tempYPlace = self.currentSelectionY;
    CGFloat tempBrighterPlace = self.currentBrigtherY;
    
    if (tempYPlace < 0.0) {
        tempYPlace = 0.0;
    } else if (_colorPickerType == ColorPickerTypeHorizontal ? tempYPlace >= kWIDTH :tempYPlace >= kHEIGHT) {
        if (_colorPickerType == ColorPickerTypeHorizontal)
            tempYPlace = kWIDTH - 1.0;
        else{
            tempYPlace = kHEIGHT - 1.0;
        }
    }
    
    if(tempBrighterPlace < 0.0){
        tempBrighterPlace = 0.0;
    }else if (_colorPickerType == ColorPickerTypeHorizontal ? tempBrighterPlace >= kWIDTH :tempBrighterPlace >= kHEIGHT) {
        if (_colorPickerType == ColorPickerTypeHorizontal)
            tempBrighterPlace = kWIDTH - 1.0;
        else{
            tempBrighterPlace = kHEIGHT - 1.0;
        }
    }
    
    CGRect temphandle = CGRectMake(0.0, tempYPlace, kWIDTH, 1.0);
    CGRect brightHandle = CGRectMake(0.0, tempBrighterPlace, kWIDTH, 1.0);
    //draw central bar over it
    CGFloat cbxbegin = kCBXBEGIN;//kWIDTH * 0.2
    CGFloat cbwidth = kWIDTH * 0.6;
    CGFloat colorCounter = kHEIGHT;
    switch (_colorPickerType) {
        case ColorPickerTypeHorizontal:
            temphandle = CGRectMake(tempYPlace, kHEIGHT*.3, 1.0, kHEIGHT*.4);
            brightHandle = CGRectMake(tempBrighterPlace, kHEIGHT * .9, 1.0, kHEIGHT * .4);
            cbxbegin = kCBXBEGIN;//kHEIGHT * 0.2
            cbwidth = kHEIGHT * 0.6;
            colorCounter = kWIDTH;
            break;
        default:
            temphandle = CGRectMake(0.0, tempYPlace, kWIDTH, 1.0);
            break;
    }
    
    CGFloat hue = 0.0, tempss = 0.0;
    
    for (int y = 0; y < colorCounter; y++) {
        
            [[UIColor colorWithHue:(y/colorCounter) saturation:1.0 brightness:1.0 alpha:1.0] set];
            CGRect temp = (_colorPickerType == ColorPickerTypeHorizontal) ? CGRectMake(y, cbxbegin, 1.0, cbwidth) : CGRectMake(cbxbegin, y, cbwidth, 1.0);
            UIRectFill(temp);
        
            [_selectedColor getHue:&hue saturation:&tempss brightness:&tempss alpha:&tempss];
            [[UIColor colorWithHue:hue saturation:1.0 brightness:(y/colorCounter) alpha:1.0] set];
            CGRect temps = (_colorPickerType == ColorPickerTypeHorizontal) ? CGRectMake(y, cbxbegin+cbwidth, 1.0, cbwidth) : CGRectMake(cbxbegin*4, y, cbwidth, 1.0);
            UIRectFill(temps);
    }
    [[UIColor whiteColor] set];
    UIRectFill(temphandle);
    UIRectFill(brightHandle);
}

/*!
 Changes the selected color, updates the UI, and notifies the delegate.
 */
- (void)setSelectedColor:(UIColor *)selectedColor
{
    if (selectedColor != _selectedColor)
    {
        CGFloat hue = 0.0, temp = 0.0,bright = 0.0;
        if ([selectedColor getHue:&hue saturation:&temp brightness:&bright alpha:&temp])
        {
            self.currentSelectionY = floorf(hue * ((_colorPickerType == ColorPickerTypeHorizontal) ? kWIDTH : kHEIGHT));
            self.currentBrigtherY = floorf(bright * ((_colorPickerType == ColorPickerTypeHorizontal) ? kWIDTH : kHEIGHT));
            [self setNeedsDisplay];
        }
        _selectedColor = selectedColor;
        if([self.delegate respondsToSelector:@selector(colorPicked:)])
        {
            [self.delegate colorPicked:_selectedColor];
        }
    }
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //update color
    [self updateColorValue:touches];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //update color
    [self updateColorValue:touches];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //update color
    [self updateColorValue:touches];
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)updateColorValue:(NSSet *)touches
{
    CGPoint point = [((UITouch *)[touches anyObject]) locationInView:self];
    if(CGRectContainsPoint(kRECTCOLOR, point)){
        self.currentSelectionY = (_colorPickerType == ColorPickerTypeHorizontal)? point.x :point.y;
    }
    else if (CGRectContainsPoint(kRECTBRIGHTER, point)){
        self.currentBrigtherY = (_colorPickerType == ColorPickerTypeHorizontal)? point.x :point.y;
    }
    
    _selectedColor = [UIColor colorWithHue: self.currentSelectionY / ((_colorPickerType == ColorPickerTypeHorizontal) ? kWIDTH : kHEIGHT) saturation:1.0 brightness:(self.currentBrigtherY == 0 ? 1.0 : self.currentBrigtherY ) / ((_colorPickerType == ColorPickerTypeHorizontal) ? kWIDTH : kHEIGHT) alpha:1.0];
    
    
    //notify delegate
    if([self.delegate respondsToSelector:@selector(colorPicked:)])
    {
        [self.delegate colorPicked:self.selectedColor];
    }
    [self setNeedsDisplay];
}
@end
