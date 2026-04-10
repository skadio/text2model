% Parameters (with values embedded)
float: req_Z1 = 5.0;
float: req_D3 = 10.0;

float: Z1_in_Zodiac = 1.3;
float: Z1_in_Sunny  = 1.2;

float: D3_in_Zodiac = 1.5;
float: D3_in_Sunny  = 5.0;

float: cost_Zodiac = 1.0;
float: cost_Sunny  = 3.0;

% Variables
var 0.0..1000.0: x_Zodiac; % number of Zodiac pills (can be fractional in LP)
var 0.0..1000.0: x_Sunny;  % number of Sunny pills (can be fractional in LP)

% Constraints
constraint Z1_in_Zodiac * x_Zodiac + Z1_in_Sunny * x_Sunny >= req_Z1;
constraint D3_in_Zodiac * x_Zodiac + D3_in_Sunny * x_Sunny >= req_D3;

% Objective
solve minimize cost_Zodiac * x_Zodiac + cost_Sunny * x_Sunny;