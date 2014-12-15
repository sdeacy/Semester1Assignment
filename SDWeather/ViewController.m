//
//  ViewController.m
//  SDWeather
//
//  Created by shay deacy on 13/12/2014.
//  Copyright (c) 2014 shay deacy. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "SDCityData.h"
@interface ViewController ()
@property (nonatomic, strong) SDCityData *cityData;
@property (nonatomic, strong) NSString   *searchCity;

@end

@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    _searchCity = @"London";
    [self getData];
    
}

-(void)buildUI{
    
    NSLog(@"Building ui");
    _cityLabel.text         = [_cityData cityName];
    _temperatureLabel.text  = [NSString stringWithFormat:@"%@%@",[_cityData temperatureCelsius],@"C"];
    _windLabel.text         = [NSString stringWithFormat:@"%@%@",[_cityData windSpeedMPS],@"mps"];
    _humidityLabel.text     = [NSString stringWithFormat:@"%@%@",[_cityData humidityPerCent],@"%"];
    
    NSLog(@"%@",[_cityData buildIconURL]);
    _iconImageView.image = [_cityData buildIconURL];

}

-(void)getData{
    NSString *searchCityURL = [NSString stringWithFormat:@"%@%@",@"http://api.openweathermap.org/data/2.5/weather?q=",_searchCity];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:searchCityURL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"got data...");
              NSDictionary *returnedData = (NSDictionary*)responseObject;
             NSLog(@"cod: %@",returnedData[@"cod"]);
             NSNumber *cod = returnedData[@"cod"];
             if (cod.intValue == 200) {
                 
                  _cityData = [[SDCityData alloc]init];
                 
                 [_cityData setCityName:returnedData[@"name"]];
                 
                 NSDictionary  *main = returnedData[@"main"];
                 [_cityData setHumidityPerCent:main[@"humidity"]];
                 [_cityData setTemperature:main[@"temp"]];
                 
                 NSArray *weatherArray = returnedData[@"weather"];
                 NSDictionary *weather = weatherArray[0];
                 [_cityData setConditionsDescription:weather[@"description"]];
                 [_cityData setIcon:weather[@"icon"]];
                 
                 NSDictionary  *wind = returnedData[@"wind"];
                 [_cityData setWindSpeedMPS:wind[@"speed"]];
                 NSLog(@"%@",_cityData);
                 
                 [self buildUI];
             }
             else if ([returnedData[@"cod"]  isEqual: @"404"]){
                 _searchTextField.text = @"City not found, try again";
             }
            
          
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"didnt get data...");
                   }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButton:(id)sender {
    
    _searchCity = _searchTextField.text;
    [_searchTextField resignFirstResponder];
    NSLog(@"%@",_searchCity);
    [self getData];

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}
@end
