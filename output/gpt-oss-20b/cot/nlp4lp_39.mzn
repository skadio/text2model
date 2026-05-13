% Parameters
int: K;
int: M;
float: AlloyQuantity;
array[1..M] of float: Target;
array[1..K, 1..M] of float: Ratio;
array[1..K] of float: Price;

% Variables
array[1..K] of var float: x;

% Constraints
constraint sum(k in 1..K)(x[k]) = AlloyQuantity;
constraint forall(m in 1..M)(
    sum(k in 1..K)(x[k] * Ratio[k,m]) = Target[m]
);
constraint forall(k in 1..K)(x[k] >= 0);
constraint forall(k in 1..K)(x[k] <= AlloyQuantity);

% Objective
solve minimize sum(k in 1..K)(x[k] * Price);