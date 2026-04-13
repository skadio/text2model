% Parameters
int: oven_capacity = 70;
int: chef_capacity = 32;

int: profit_bagels = 20;
int: profit_croissants = 40;

int: oven_bagels = 2;
int: oven_croissants = 1;

int: chef_bagels_num = 1;   % 0.25 = 1/4
int: chef_bagels_den = 4;
int: chef_croissants = 2;

% Variables
var 0..(oven_capacity div oven_bagels): bagels;
var 0..oven_capacity: croissants;

% Constraints
constraint oven_bagels * bagels + oven_croissants * croissants <= oven_capacity;

% Multiply chef-time constraint by 4 to avoid fractions:
% (1/4)*bagels + 2*croissants <= 32  <=>  bagels + 8*croissants <= 128
constraint bagels + (chef_bagels_den * chef_croissants) * croissants <= chef_bagels_den * chef_capacity;

% Objective
solve maximize profit_bagels * bagels + profit_croissants * croissants;