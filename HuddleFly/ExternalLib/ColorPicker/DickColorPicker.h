
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ColorPickerType)
{
    ColorPickerTypeNone = 0,
    ColorPickerTypeVerticle,
    ColorPickerTypeHorizontal
};


typedef NS_ENUM(NSInteger, ColorBrightNess)
{
    ColorBrightNessNone = 0,
    ColorBrightNessHue
};


/*!
 A delegate that gets notifications when the color picked changes.
 */
@protocol DickColorPickerDelegate <NSObject>
@optional
-(void)colorPicked:(UIColor *)color;
@end

IB_DESIGNABLE

@interface DickColorPicker : UIView

@property (nonatomic, weak) IBOutlet id<DickColorPickerDelegate> delegate;  //set after inited
@property (nonatomic) IBInspectable UIColor *selectedColor;  //setting this will update the UI & notify the delegate
@property (nonatomic) IBInspectable ColorPickerType colorPickerType;
@property (nonatomic) IBInspectable ColorBrightNess colorBrigter;
@end
