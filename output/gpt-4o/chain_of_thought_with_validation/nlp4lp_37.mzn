% Parameters
int: K;
int: M;

array[1..K] of int: Price;
array[1..M] of int: Demand;
array[1..K, 1..M] of int: Nutrition;

float: BIG = 1.0e6;

% Variables
array[1..K] of var 0.0..BIG: Quantity;

% Constraints
constraint
  forall(m in 1..M)(
    sum(k in 1..K)( int2float(Nutrition[k, m]) * Quantity[k] ) >= int2float(Demand[m])
  );

% Objective
solve minimize
  sum(k in 1..K)( int2float(Price[k]) * Quantity[k] );