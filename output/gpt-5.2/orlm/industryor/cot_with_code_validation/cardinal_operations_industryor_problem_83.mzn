% Parameters
int: N = 5;
set of int: CAND = 1..N;

array[CAND] of int: salary = [8100, 20000, 21000, 3000, 8000];
array[CAND] of int: experience = [3, 10, 4, 3, 7];

int: max_hires = 3;
int: min_hires = 2;
int: budget = 35000;
int: min_experience = 12;

% degree flags (1 if candidate has Master's or Doctoral degree, else 0)
array[CAND] of int: has_grad_degree = [0, 1, 1, 0, 0];

int: A = 1;
int: E = 5;

% Variables
array[CAND] of var 0..1: hire;
var 0..budget: total_salary;
var 0..1000: total_experience;
var 0..N: total_hires;

% Constraints
constraint total_salary = sum(i in CAND)(salary[i] * hire[i]);
constraint total_experience = sum(i in CAND)(experience[i] * hire[i]);
constraint total_hires = sum(i in CAND)(hire[i]);

constraint total_salary <= budget;
constraint total_hires <= max_hires;
constraint total_hires >= min_hires;

constraint sum(i in CAND)(has_grad_degree[i] * hire[i]) >= 1;
constraint total_experience >= min_experience;

constraint hire[A] + hire[E] <= 1;

% Objective
solve minimize total_salary;