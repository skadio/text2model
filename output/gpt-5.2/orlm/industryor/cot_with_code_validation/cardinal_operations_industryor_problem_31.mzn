% Linear production planning (LP) for maximizing completed products

int: W = 4;
int: C = 3;

set of int: WORKSHOPS = 1..W;
set of int: COMPONENTS = 1..C;

array[WORKSHOPS] of float: cap_hours = [100.0, 150.0, 80.0, 200.0];

% rate[w,c] = units/hour of component c in workshop w
array[WORKSHOPS, COMPONENTS] of float: rate =
  [| 10.0, 15.0,  5.0
   | 15.0, 10.0,  5.0
   | 20.0,  5.0, 10.0
   | 10.0, 15.0, 20.0 |];

% Upper bounds chosen to avoid expensive/slow bound expressions
float: TOT_H = sum(w in WORKSHOPS)(cap_hours[w]);
float: MAX_RATE = 20.0;
float: UB_UNITS = TOT_H * MAX_RATE;

% Decision variables: hours allocated
array[WORKSHOPS, COMPONENTS] of var 0.0..200.0: x;

% Produced units of each component
array[COMPONENTS] of var 0.0..UB_UNITS: prod;

% Completed products (each needs 1 unit of each component)
var 0.0..UB_UNITS: P;

% Capacity constraints
constraint forall(w in WORKSHOPS)(
  sum(c in COMPONENTS)(x[w,c]) <= cap_hours[w]
);

% Production definitions
constraint forall(c in COMPONENTS)(
  prod[c] = sum(w in WORKSHOPS)(rate[w,c] * x[w,c])
);

% A product requires one unit of each component
constraint forall(c in COMPONENTS)(
  P <= prod[c]
);

solve maximize P;