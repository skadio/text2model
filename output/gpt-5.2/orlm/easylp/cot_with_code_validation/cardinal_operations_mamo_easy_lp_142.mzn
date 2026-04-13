% Parameters
int: max_logistics = 50;
int: min_strength = 10;
int: coefX_logistics = 3;
int: coefY_logistics = 2;
int: supportX = 4;
int: supportY = 5;

% Variables
var 0..max_logistics: X;
var 0..max_logistics: Y;
var 0..(supportX*max_logistics + supportY*max_logistics): total_support;

% Constraints
constraint coefX_logistics * X + coefY_logistics * Y <= max_logistics;
constraint X + Y >= min_strength;
constraint total_support = supportX * X + supportY * Y;

% Objective
solve minimize total_support;