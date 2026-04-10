% Parameters
int: N = 5;
set of int: C = 1..N;

array[C] of string: name = ["F","G","H","I","J"];
array[C] of int: salary = [12000, 15000, 18000, 5000, 10000];
array[C] of int: skill = [2, 3, 4, 1, 2];
array[C] of int: experience = [1, 2, 2, 5, 4];

int: budget = 40000;
int: max_hires = 4;
int: min_total_skill = 8;
int: min_total_experience = 8;

int: idxG = 2;
int: idxJ = 5;

% Variables
array[C] of var 0..1: hire;
var 0..sum(salary): total_salary;

% Constraints
constraint total_salary = sum(c in C)(salary[c] * hire[c]);

constraint total_salary <= budget;

constraint sum(c in C)(hire[c]) <= max_hires;

constraint sum(c in C)(skill[c] * hire[c]) >= min_total_skill;

constraint sum(c in C)(experience[c] * hire[c]) >= min_total_experience;

constraint hire[idxG] + hire[idxJ] <= 1;

% Objective
solve minimize total_salary;