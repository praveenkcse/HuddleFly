//
//  WeatherForecastVC.h
//  HuddleFly
//
//  Created by Jignesh on 16/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "BaseVC.h"

@interface WeatherForecastVC : BaseVC <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtWeatherLocation;
- (IBAction)onClickSubmit:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@end
