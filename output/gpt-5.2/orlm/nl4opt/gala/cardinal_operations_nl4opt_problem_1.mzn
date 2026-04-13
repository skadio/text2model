% Pill production optimization (all data embedded)

% Data
int: med_total = 1000;          % total medicinal ingredient units available
int: med_large = 3;
int: fill_large = 2;
int: med_small = 2;
int: fill_small = 1;

int: min_large_pills = 100;
int: small_percent = 60;        % at least 60% of total pills must be small

% Decision variables
var 0..(med_total div med_large): L;   % number of large pills
var 0..(med_total div med_small): S;   % number of small pills

% Constraints
constraint L >= min_large_pills;
constraint med_large * L + med_small * S <= med_total;

% "At least 60% small"  <=>  S / (L+S) >= 0.6  <=>  5S >= 3(L+S)  <=>  2S >= 3L
constraint 2 * S >= 3 * L;

% Objective: minimize total filler used
var int: filler = fill_large * L + fill_small * S;

solve minimize filler;

output [
  "Large pills L = ", show(L), "\n",
  "Small pills S = ", show(S), "\n",
  "Total pills   = ", show(L + S), "\n",
  "Filler used   = ", show(filler), "\n",
  "Medicinal used= ", show(med_large * L + med_small * S), "\n"
];