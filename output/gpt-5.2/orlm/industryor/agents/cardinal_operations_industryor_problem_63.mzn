% Parameters
% Candidate set (5 candidates: F..J)
set of int: CANDIDATES = 1..5;

% Candidate identifiers (for readability)
int: F = 1;
int: G = 2;
int: H = 3;
int: I = 4;
int: J = 5;

% Salary requirements (in dollars)
array[CANDIDATES] of int: salary = [12000, 15000, 18000,  5000, 10000];

% Skill levels
array[CANDIDATES] of int: skill  = [2, 3, 4, 1, 2];

% Project management experience (years)
array[CANDIDATES] of int: pm_years = [1, 2, 2, 5, 4];

% Budget limit (dollars)
int: budget = 40000;

% Maximum hires
int: max_hires = 4;

% Minimum total skill required
int: min_total_skill = 8;

% Minimum total project management experience required (years)
int: min_total_pm_years = 8;


% Variables
% hire[c] = 1 if candidate c is hired, else 0
array[CANDIDATES] of var 0..1: hire;

% Total salary paid (bounded by budget)
var 0..budget: total_salary;

% Total skill (upper bound: sum of max possible skills if all hired)
var 0..sum(skill): total_skill;

% Total project management experience (upper bound: sum if all hired)
var 0..sum(pm_years): total_pm_years;


% Constraints
% Link totals to hiring decisions (definition constraints)
constraint
  total_salary = sum(c in CANDIDATES)(salary[c] * hire[c]);

constraint
  total_skill = sum(c in CANDIDATES)(skill[c] * hire[c]);

constraint
  total_pm_years = sum(c in CANDIDATES)(pm_years[c] * hire[c]);

% Budget feasibility (do not exceed total budget)
constraint
  total_salary <= budget;

% Headcount limit (hire at most max_hires candidates)
constraint
  sum(c in CANDIDATES)(hire[c]) <= max_hires;

% Minimum team skill requirement
constraint
  total_skill >= min_total_skill;

% Minimum project management experience requirement
constraint
  total_pm_years >= min_total_pm_years;

% Mutual exclusion due to similar technical background (at most one of G and J)
constraint
  hire[G] + hire[J] <= 1;


% Objective
solve minimize total_salary;