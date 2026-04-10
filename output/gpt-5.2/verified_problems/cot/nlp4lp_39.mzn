% Parameters
int: K; % Number of Alloys
int: M; % Number of Metals
float: AlloyQuantity; % Quantity of alloy to produce (lb)

array[1..M] of float: Target;          % Target quantity (lb) of each metal in final alloy
array[1..K, 1..M] of float: Ratio;     % Ratio of metal m in alloy k (by weight)
array[1..K] of float: Price;           % Price per lb (or per unit) of alloy k

% Variables
array[1..K] of var float: x;           % Quantity (lb) of each input alloy to use
var float: total_cost;

% Constraints
constraint forall(k in 1..K) ( x[k] >= 0.0 );

% Total produced alloy quantity
constraint sum(k in 1..K)(x[k]) = AlloyQuantity;

% Meet exact target quantities of each metal
constraint forall(m in 1..M)(
  sum(k in 1..K)(x[k] * Ratio[k,m]) = Target[m]
);

% Define objective expression
constraint total_cost = sum(k in 1..K)(x[k] * Price[k]);

% Objective
solve minimize total_cost;