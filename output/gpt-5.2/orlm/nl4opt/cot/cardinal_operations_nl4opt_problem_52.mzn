% Parameters (with values embedded)
int: small_capacity = 50;
int: large_capacity = 80;

int: max_small = 70;
int: max_large = 50;

int: min_large = 15;
int: max_total_suitcases = 70;

% Variables
var 0..max_small: S;   % number of small suitcases
var 0..max_large: L;   % number of large suitcases

% Constraints
constraint 2 * L <= S;                      % at least twice as many small as large
constraint L >= min_large;                  % must send at least 15 large
constraint S + L <= max_total_suitcases;    % at most 70 suitcases in total

% Objective
var int: total_snacks = small_capacity * S + large_capacity * L;
solve maximize total_snacks;

output [
  "Small suitcases = ", show(S), "\n",
  "Large suitcases = ", show(L), "\n",
  "Total suitcases = ", show(S + L), "\n",
  "Total snacks = ", show(total_snacks), "\n"
];