% Parameters
int: K;
int: L;
array[1..K, 1..L] of float: Benefit;
array[1..K, 1..K] of float: Communication;
array[1..L, 1..L] of float: Cost;

% Variables
array[1..K] of var 1..L: loc;

% Constraints
constraint
  forall(l in 1..L) (
    sum([bool2int(loc[k] == l) | k in 1..K]) <= 3
  );

% Objective
solve minimize
  sum(k in 1..K) (-element(Benefit, k, loc[k])) +
  sum(k in 1..K, j in 1..K) (Communication[k,j] * element(Cost, loc[k], loc[j]));