% Parameters
int: N = 5;
set of int: CANDIDATES = 1..N;

array[CANDIDATES] of int: salary = [8100, 20000, 21000, 3000, 8000];
int: budget = 35000;

array[CANDIDATES] of int: has_grad_degree = [0, 1, 1, 0, 0]; % Master's or Doctoral
array[CANDIDATES] of int: experience = [3, 10, 4, 3, 7];

int: min_hires = 2;
int: max_hires = 3;
int: min_experience = 12;

int: candA = 1;
int: candE = 5;

% Variables
array[CANDIDATES] of var 0..1: hire;
var 0..sum(salary): total_salary = sum(i in CANDIDATES)(salary[i] * hire[i]);
var 0..sum(experience): total_experience = sum(i in CANDIDATES)(experience[i] * hire[i]);

% Constraints
constraint sum(i in CANDIDATES)(hire[i]) >= min_hires;
constraint sum(i in CANDIDATES)(hire[i]) <= max_hires;

constraint total_salary <= budget;

constraint sum(i in CANDIDATES)(has_grad_degree[i] * hire[i]) >= 1;

constraint total_experience >= min_experience;

constraint hire[candA] + hire[candE] <= 1;

% Objective
solve minimize total_salary;