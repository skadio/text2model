% Parameters
int: N = 5;
set of int: C = 1..N;

array[C] of int: salary = [12000, 15000, 18000, 5000, 10000]; % F,G,H,I,J
array[C] of int: skill  = [2, 3, 4, 1, 2];
array[C] of int: pm_exp = [1, 2, 2, 5, 4];

int: budget = 40000;
int: max_hires = 4;
int: min_total_skill = 8;
int: min_total_pm_exp = 8;

int: idx_G = 2;
int: idx_J = 5;

% Variables
array[C] of var 0..1: hire;
var 0..sum(c in C)(salary[c]): total_salary;
var 0..max_hires: total_hires;
var 0..sum(c in C)(skill[c]): total_skill;
var 0..sum(c in C)(pm_exp[c]): total_pm_exp;

% Constraints
constraint total_salary = sum(c in C)(salary[c] * hire[c]);
constraint total_hires  = sum(c in C)(hire[c]);
constraint total_skill  = sum(c in C)(skill[c] * hire[c]);
constraint total_pm_exp = sum(c in C)(pm_exp[c] * hire[c]);

constraint total_salary <= budget;
constraint total_hires <= max_hires;
constraint total_skill >= min_total_skill;
constraint total_pm_exp >= min_total_pm_exp;

constraint hire[idx_G] + hire[idx_J] <= 1;

% Objective
solve minimize total_salary;