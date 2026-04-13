% Parameters (with values embedded)
int: nFactories = 2;
set of int: F = 1..nFactories;

int: nColors = 3;
set of int: C = 1..nColors; % 1=black, 2=white, 3=brown

array[F] of int: costPerHour = [300, 600];

% production[color] per hour for each factory
array[F, C] of int: prod = array2d(F, C,
  [ 5,  6, 3,   % factory 1: black, white, brown
   10, 10, 0 ]  % factory 2: black, white, brown
);

array[C] of int: demandMin = [20, 5, 15];

% Variables
array[F] of var 0..1000: hours; % hours run per day (nonnegative, bounded for modeling)

% Constraints
constraint
  forall(c in C)(
    sum(f in F)(prod[f,c] * hours[f]) >= demandMin[c]
  );

% Objective
solve minimize sum(f in F)(costPerHour[f] * hours[f]);