% Parameters
int: oven_capacity = 70;
int: chef_capacity = 32;

float: oven_bagel = 2.0;
float: chef_bagel = 0.25;
float: profit_bagel = 20.0;

float: oven_croissant = 1.0;
float: chef_croissant = 2.0;
float: profit_croissant = 40.0;

% Variables
var 0..35: bagels;        % bounded by oven capacity: floor(70/2)=35
var 0..16: croissants;    % bounded by chef capacity: floor(32/2)=16

var float: total_profit;

% Constraints
constraint oven_bagel * bagels + oven_croissant * croissants <= oven_capacity;
constraint chef_bagel * bagels + chef_croissant * croissants <= chef_capacity;

constraint total_profit = profit_bagel * bagels + profit_croissant * croissants;

% Objective
solve maximize total_profit;