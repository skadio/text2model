% Parameters
int: wage_senior = 3000;
int: wage_junior = 1000;
int: min_total = 100;
int: min_senior = 5;
int: max_wagebill = 150000;

% Variables
var 0..max_wagebill div wage_senior: S; % number of senior accountants
var 0..max_wagebill div wage_junior: J; % number of junior accountants

var 0..max_wagebill: wagebill;

% Constraints
constraint wagebill = wage_senior * S + wage_junior * J;

constraint S + J >= min_total;
constraint S >= min_senior;

% Senior accountants at least a third of junior accountants: S >= J/3  <=>  3*S >= J
constraint 3 * S >= J;

constraint wagebill <= max_wagebill;

% Objective
solve minimize wagebill;