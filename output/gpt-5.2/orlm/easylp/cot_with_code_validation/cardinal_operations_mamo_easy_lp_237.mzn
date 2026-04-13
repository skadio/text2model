% Parameters
int: cost_wheat = 5;
int: cost_corn = 4;
int: cost_soy = 6;

int: rhs1 = 50; % 2*wheat + corn <= 50
int: rhs2 = 60; % wheat + 3*soy <= 60
int: min_cs = 30; % corn + soy >= 30

% Variables
var 0..rhs1: wheat;
var 0..rhs1: corn;
var 0..rhs2: soy;

var 0..(cost_wheat*rhs1 + cost_corn*rhs1 + cost_soy*rhs2): total_cost;

% Constraints
constraint 2*wheat + corn <= rhs1;
constraint wheat + 3*soy <= rhs2;
constraint corn + soy >= min_cs;

constraint total_cost = cost_wheat*wheat + cost_corn*corn + cost_soy*soy;

% Objective
solve minimize total_cost;