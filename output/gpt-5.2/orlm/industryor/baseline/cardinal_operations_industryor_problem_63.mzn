% Hiring decision model (all data embedded)

set of int: C = 1..5;
array[C] of string: name = ["F","G","H","I","J"];

array[C] of int: salary = [12000, 15000, 18000,  5000, 10000];
array[C] of int: skill  = [    2,     3,     4,     1,     2];
array[C] of int: pmexp  = [    1,     2,     2,     5,     4];

int: budget = 40000;
int: max_hires = 4;
int: min_skill = 8;
int: min_pmexp = 8;

int: idxG = 2;
int: idxJ = 5;

array[C] of var 0..1: hire;

var int: total_cost = sum(c in C)(salary[c] * hire[c]);
var int: total_skill = sum(c in C)(skill[c] * hire[c]);
var int: total_pmexp = sum(c in C)(pmexp[c] * hire[c]);
var int: total_hires = sum(c in C)(hire[c]);

constraint total_cost <= budget;
constraint total_hires <= max_hires;
constraint total_skill >= min_skill;
constraint total_pmexp >= min_pmexp;

% At most one of G and J
constraint hire[idxG] + hire[idxJ] <= 1;

solve minimize total_cost;

output [
  "Hires: ",
  concat([ if fix(hire[c]) = 1 then name[c] ++ " " else "" endif | c in C ]),
  "\nTotal hires = ", show(total_hires),
  "\nTotal cost = ", show(total_cost),
  "\nTotal skill = ", show(total_skill),
  "\nTotal PM exp = ", show(total_pmexp),
  "\nDecision (0/1) = [", concat([show(hire[c]) ++ if c < max(C) then ", " else "" endif | c in C]), "]\n"
];