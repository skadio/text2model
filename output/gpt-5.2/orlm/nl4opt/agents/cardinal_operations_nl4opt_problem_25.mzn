% Parameters
% Minimum daily requirements (grams)
float: minZ1 = 5.0;
float: minD3 = 10.0;

% Content per pill (grams)
float: z1PerZodiac = 1.3;
float: z1PerSunny  = 1.2;
float: d3PerZodiac = 1.5;
float: d3PerSunny  = 5.0;

% Cost per pill ($)
float: costZodiac = 1.0;
float: costSunny  = 3.0;

% Variables
% Number of pills to take (nonnegative, continuous for LP formulation)
var float: nZodiac;  % pills of Zodiac
var float: nSunny;   % pills of Sunny

% Constraints
% Nonnegativity of decision variables (pills cannot be negative)
constraint nZodiac >= 0.0;
constraint nSunny  >= 0.0;

% Minimum daily requirement for medicine Z1 (grams)
constraint z1PerZodiac * nZodiac + z1PerSunny * nSunny >= minZ1;

% Minimum daily requirement for medicine D3 (grams)
constraint d3PerZodiac * nZodiac + d3PerSunny * nSunny >= minD3;

% Objective
solve minimize costZodiac * nZodiac + costSunny * nSunny;