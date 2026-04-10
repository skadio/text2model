% Employee recruitment - embedded data

set of int: CAND = 1..5;
int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;

array[CAND] of int: salary = [8100, 20000, 21000, 3000, 8000];
array[CAND] of int: experience = [3, 10, 4, 3, 7];

% Degree indicators
array[CAND] of bool: is_master_or_phd = [false, true, true, false, false];

int: max_hires = 3;
int: min_hires = 2;
int: budget = 35000;
int: min_total_experience = 12;

array[CAND] of var 0..1: hire;

var int: total_cost = sum(c in CAND)(salary[c] * hire[c]);
var int: total_hires = sum(c in CAND)(hire[c]);
var int: total_exp = sum(c in CAND)(experience[c] * hire[c]);

constraint total_hires <= max_hires;
constraint total_hires >= min_hires;

constraint total_cost <= budget;

% At least one candidate with Master's or Doctoral degree
constraint sum(c in CAND where is_master_or_phd[c])(hire[c]) >= 1;

% Total experience requirement
constraint total_exp >= min_total_experience;

% At most one of A and E
constraint hire[A] + hire[E] <= 1;

solve minimize total_cost;

output [
  "Total cost = ", show(total_cost), "\n",
  "Total hires = ", show(total_hires), "\n",
  "Total experience = ", show(total_exp), "\n",
  "Hire decisions:\n",
  "A: ", show(hire[A]), "\n",
  "B: ", show(hire[B]), "\n",
  "C: ", show(hire[C]), "\n",
  "D: ", show(hire[D]), "\n",
  "E: ", show(hire[E]), "\n"
];