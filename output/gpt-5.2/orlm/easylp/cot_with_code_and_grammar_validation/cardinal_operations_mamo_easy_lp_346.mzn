% Parameters
int: risk1 = 5;
int: risk2 = 7;
int: risk3 = 6;
int: risk4 = 8;

int: c1_x1 = 3;
int: c1_x2 = 4;
int: rhs1 = 5000;

int: c2_x1 = 2;
int: c2_x3 = 5;
int: rhs2 = 6000;

int: diff_x2_x4_min = 1000;

int: rhs4 = 2000;

% No explicit portfolio bounds were provided; assume non-negative integer investments (dollars)
int: UB = 6000;

% Variables
var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

var 0..(risk1*UB + risk2*UB + risk3*UB + risk4*UB): total_risk;

% Constraints
constraint c1_x1 * x1 + c1_x2 * x2 <= rhs1;
constraint c2_x1 * x1 + c2_x3 * x3 <= rhs2;
constraint x2 - x4 >= diff_x2_x4_min;
constraint x1 - 3 * x3 <= rhs4;

constraint total_risk = risk1 * x1 + risk2 * x2 + risk3 * x3 + risk4 * x4;

% Objective
solve minimize total_risk;