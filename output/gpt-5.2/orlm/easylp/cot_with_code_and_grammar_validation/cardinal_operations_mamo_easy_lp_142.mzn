% Parameters
int: max_logistics = 50;          % 3*X + 2*Y <= 50
int: min_strength = 10;           % X + Y >= 10
int: coeffX = 3;
int: coeffY = 2;
int: supportX = 4;
int: supportY = 5;

% Variables
var 0..(max_logistics div coeffX): X;
var 0..(max_logistics div coeffY): Y;
var 0..(supportX*(max_logistics div coeffX) + supportY*(max_logistics div coeffY)): total_support;

% Constraints
constraint coeffX*X + coeffY*Y <= max_logistics;
constraint X + Y >= min_strength;
constraint total_support = supportX*X + supportY*Y;

% Objective
solve minimize total_support;