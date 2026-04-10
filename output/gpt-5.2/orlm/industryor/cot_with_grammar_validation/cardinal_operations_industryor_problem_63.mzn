% Parameters
int: N = 5;
set of int: C = 1..N;

array[C] of int: salary = [12000, 15000, 18000, 5000, 10000]; % F,G,H,I,J
int: budget = 40000;
int: max_hires = 4;

array[C] of int: skill = [2, 3, 4, 1, 2];
int: min_total_skill = 8;

array[C] of int: experience = [1, 2, 2, 5, 4];
int: min_total_experience = 8;

int: idx_G = 2;
int: idx_J = 5;

% Variables
array[C] of var 0..1: hire;
var 0..sum(salary): total_salary;

% Constraints
constraint total_salary = sum(i in C)(salary[i] * hire[i]);

constraint total_salary <= budget;
constraint sum(i in C)(hire[i]) <= max_hires;

constraint sum(i in C)(skill[i] * hire[i]) >= min_total_skill;
constraint sum(i in C)(experience[i] * hire[i]) >= min_total_experience;

constraint hire[idx_G] + hire[idx_J] <= 1;

% Objective
solve minimize total_salary;