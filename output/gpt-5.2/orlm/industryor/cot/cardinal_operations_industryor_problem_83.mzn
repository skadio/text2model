% Parameters (with values embedded)
int: N = 5;
set of int: CAND = 1..N;

set of int: A = {1};
set of int: B = {2};
set of int: C = {3};
set of int: D = {4};
set of int: E = {5};

array[CAND] of int: salary = [8100, 20000, 21000, 3000, 8000];
array[CAND] of int: experience = [3, 10, 4, 3, 7];

int: max_hires = 3;
int: min_hires = 2;
int: budget = 35000;
int: min_total_experience = 12;

set of int: grad_plus = B union C; % Master's or Doctoral
set of int: skill_equiv = A union E; % A and E, at most one

% Variables
array[CAND] of var 0..1: hire;
var 0..sum(salary): total_salary;
var 0..sum(experience): total_experience;
var 0..N: total_hires;

% Constraints
constraint total_hires = sum(i in CAND)(hire[i]);
constraint total_salary = sum(i in CAND)(salary[i] * hire[i]);
constraint total_experience = sum(i in CAND)(experience[i] * hire[i]);

constraint total_hires <= max_hires;
constraint total_hires >= min_hires;

constraint total_salary <= budget;

constraint sum(i in grad_plus)(hire[i]) >= 1;

constraint total_experience >= min_total_experience;

constraint sum(i in skill_equiv)(hire[i]) <= 1;

% Objective
solve minimize total_salary;