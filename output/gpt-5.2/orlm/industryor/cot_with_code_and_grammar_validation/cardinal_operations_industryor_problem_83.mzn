% Parameters
int: N = 5;
set of int: CANDIDATES = 1..N;

% Candidate indices: 1=A, 2=B, 3=C, 4=D, 5=E
array[CANDIDATES] of int: salary = [8100, 20000, 21000, 3000, 8000];
array[CANDIDATES] of int: experience = [3, 10, 4, 3, 7];

set of int: grad_candidates = {2, 3}; % Master's or Doctoral

int: max_hires = 3;
int: min_hires = 2;
int: budget = 35000;
int: min_total_experience = 12;

int: candA = 1;
int: candE = 5;

% Variables
array[CANDIDATES] of var 0..1: hire;
var 0..sum(salary): total_salary;
var 0..sum(experience): total_experience;
var 0..N: total_hires;

% Constraints
constraint total_hires = sum(i in CANDIDATES)(hire[i]);
constraint total_salary = sum(i in CANDIDATES)(salary[i] * hire[i]);
constraint total_experience = sum(i in CANDIDATES)(experience[i] * hire[i]);

constraint total_hires >= min_hires;
constraint total_hires <= max_hires;

constraint total_salary <= budget;

constraint sum(i in grad_candidates)(hire[i]) >= 1;

constraint total_experience >= min_total_experience;

constraint hire[candA] + hire[candE] <= 1;

% Objective
solve minimize total_salary;