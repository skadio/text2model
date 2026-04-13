include "globals.mzn";

% ----- Data (embedded from problem statement) -----
int: n = 5;
set of int: C = 1..n;

% Candidate order: 1=F, 2=G, 3=H, 4=I, 5=J
array[C] of int: salary = [12000, 15000, 18000,  5000, 10000];
array[C] of int: skill  = [    2,     3,     4,     1,     2];
array[C] of int: pm_exp = [    1,     2,     2,     5,     4];

int: budget = 40000;
int: max_hires = 4;
int: min_skill = 8;
int: min_pmexp = 8;

int: G = 2;
int: J = 5;

% ----- Decision variables -----
array[C] of var 0..1: hire;  % 1 if candidate is hired, else 0

% ----- Constraints -----
% Budget limit
constraint sum(i in C)(salary[i] * hire[i]) <= budget;

% Hire at most max_hires (use hint's count pattern, adapted)
var 0..n: num_hired;
constraint count(hire, 1, num_hired);
constraint num_hired <= max_hires;

% Minimum total skill
constraint sum(i in C)(skill[i] * hire[i]) >= min_skill;

% Minimum total project management experience
constraint sum(i in C)(pm_exp[i] * hire[i]) >= min_pmexp;

% At most one of G and J
constraint hire[G] + hire[J] <= 1;

% ----- Objective -----
solve minimize sum(i in C)(salary[i] * hire[i]);

% ----- Output -----
output [
  "hire(F,G,H,I,J) = ", show([hire[1], hire[2], hire[3], hire[4], hire[5]]), "\n",
  "num_hired = ", show(num_hired), "\n",
  "total_salary = ", show(sum(i in C)(salary[i] * hire[i])), "\n",
  "total_skill = ", show(sum(i in C)(skill[i] * hire[i])), "\n",
  "total_pm_exp = ", show(sum(i in C)(pm_exp[i] * hire[i])), "\n"
];