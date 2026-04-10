% Parameters
int: K;
int: M;

float: AlloyQuantity;
array[1..M] of float: Target;
array[1..K, 1..M] of float: Ratio;
array[1..K] of float: Price;

% Variables
array[1..K] of var 0.0..AlloyQuantity: x; % amount (lb) of each available alloy to melt

% Constraints
constraint sum(k in 1..K)(x[k]) = AlloyQuantity;

constraint forall(m in 1..M) (
  sum(k in 1..K)(Ratio[k,m] * x[k]) = Target[m]
);

% Objective
solve minimize sum(k in 1..K)(Price[k] * x[k]);