% Minimize filler usage while meeting ingredient and mix requirements

int: total_ingredients = 1000;

int: ing_large = 3;
int: fill_large = 2;

int: ing_small = 2;
int: fill_small = 1;

int: min_large = 100;

% Decision variables
var 0..total_ingredients div ing_large: L; % number of large pills
var 0..total_ingredients div ing_small: S; % number of small pills

% Constraints
constraint ing_large * L + ing_small * S <= total_ingredients;
constraint L >= min_large;

% At least 60% of all pills are small:
% S / (L+S) >= 0.6  ->  10*S >= 6*(L+S)  ->  4*S >= 6*L  ->  2*S >= 3*L
constraint 2 * S >= 3 * L;

% Objective: minimize total filler
var int: total_filler = fill_large * L + fill_small * S;

solve minimize total_filler;

output [
  "Large pills (L) = ", show(L), "\n",
  "Small pills (S) = ", show(S), "\n",
  "Total pills     = ", show(L + S), "\n",
  "Filler used     = ", show(total_filler), "\n",
  "Ingredients used= ", show(ing_large * L + ing_small * S), "\n"
];