% Diet problem: minimize sugar intake while meeting nutrient requirements

% Data
int: anti_b = 3;      % anti-oxidants per pack of blueberries
int: min_b  = 5;      % minerals per pack of blueberries
int: sugar_b = 5;     % sugar grams per pack of blueberries

int: anti_s = 1;      % anti-oxidants per pack of strawberries
int: min_s  = 7;      % minerals per pack of strawberries
int: sugar_s = 7;     % sugar grams per pack of strawberries

int: req_anti = 90;
int: req_min  = 100;

% Decision variables: number of packs (nonnegative integers)
var 0..1000: b; % blueberries
var 0..1000: s; % strawberries

% Constraints
constraint anti_b * b + anti_s * s >= req_anti;
constraint min_b  * b + min_s  * s >= req_min;

% At least 3 times as many strawberry packs as blueberry packs
constraint s >= 3 * b;

% Objective: minimize total sugar intake
var int: total_sugar = sugar_b * b + sugar_s * s;
solve minimize total_sugar;

output [
  "blueberries_packs = ", show(b), "\n",
  "strawberries_packs = ", show(s), "\n",
  "total_sugar = ", show(total_sugar), " grams\n"
];