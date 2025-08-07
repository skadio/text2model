% Parameters
int: ndepts;
int: ncities;
int: ncitiesm1;
array[1..ndepts, 1..ncities] of int: benefit;
array[1..ncities, 1..ncities] of int: dist;
array[1..ndepts, 1..ndepts] of int: comm;

% Variables
array[1..ndepts] of var 1..ncities: city_of;

% Constraints
constraint
  forall(c in 1..ncities) (
    sum(d in 1..ndepts) (city_of[d] == c) <= 3
  );

% Objective
var int: total_savings =
  sum(d in 1..ndepts) benefit[d, city_of[d]] -
  sum(i in 1..ndepts-1, j in i+1..ndepts) comm[i,j] * dist[city_of[i], city_of[j]];

solve maximize total_savings;