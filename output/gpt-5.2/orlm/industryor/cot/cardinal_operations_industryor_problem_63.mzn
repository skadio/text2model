% Parameters (with values embedded)
int: N = 5;
set of int: CAND = 1..N;

array[CAND] of string: name = ["F","G","H","I","J"];

array[CAND] of int: salary = [12000, 15000, 18000, 5000, 10000];
int: budget = 40000;
int: max_hires = 4;

array[CAND] of int: skill = [2, 3, 4, 1, 2];
int: min_total_skill = 8;

array[CAND] of int: experience = [1, 2, 2, 5, 4];
int: min_total_experience = 8;

int: idxG = 2;
int: idxJ = 5;

% Variables
array[CAND] of var 0..1: hire;
var 0..sum(salary): total_salary;

% Constraints
constraint total_salary = sum(i in CAND)(salary[i] * hire[i]);

constraint total_salary <= budget;
constraint sum(i in CAND)(hire[i]) <= max_hires;

constraint sum(i in CAND)(skill[i] * hire[i]) >= min_total_skill;
constraint sum(i in CAND)(experience[i] * hire[i]) >= min_total_experience;

constraint hire[idxG] + hire[idxJ] <= 1;

% Objective
solve minimize total_salary;