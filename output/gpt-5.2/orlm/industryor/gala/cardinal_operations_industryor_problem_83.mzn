include "globals.mzn";

% ----- Data (embedded) -----
int: n = 5;
set of int: CAND = 1..n;

% Candidate order: 1=A, 2=B, 3=C, 4=D, 5=E
array[CAND] of int: salary = [8100, 20000, 21000, 3000, 8000];
array[CAND] of int: experience = [3, 10, 4, 3, 7];

int: budget = 35000;

set of int: grad_cands = {2,3}; % B (Master), C (Doctor)
int: min_total_experience = 12;

% ----- Decision variables -----
array[CAND] of var 0..1: hire;

% ----- Constraints -----
% Number hired: between 2 and 3
var 0..n: num_hired;
constraint count(hire, 1, num_hired);
constraint num_hired <= 3;
constraint num_hired >= 2;

% Budget
constraint sum(i in CAND)(salary[i] * hire[i]) <= budget;

% At least one candidate with Master's or Doctoral degree (B or C)
var 0..n: num_grad_hired;
constraint count([hire[i] | i in grad_cands], 1, num_grad_hired);
constraint num_grad_hired >= 1;

% Total experience at least 12 years
constraint sum(i in CAND)(experience[i] * hire[i]) >= min_total_experience;

% At most one of A and E
constraint hire[1] + hire[5] <= 1;

% ----- Objective -----
var int: total_salary = sum(i in CAND)(salary[i] * hire[i]);
solve minimize total_salary;

% ----- Output -----
output [
  "hire (A..E) = ", show(hire), "\n",
  "num_hired = ", show(num_hired), "\n",
  "total_salary = ", show(total_salary), "\n",
  "total_experience = ", show(sum(i in CAND)(experience[i] * hire[i])), "\n"
];