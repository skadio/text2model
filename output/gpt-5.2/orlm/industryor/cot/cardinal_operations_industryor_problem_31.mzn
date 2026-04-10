% Parameters (with values embedded)
int: W = 4; % workshops
int: C = 3; % components

set of int: Workshops = 1..W;
set of int: Components = 1..C;

% Workshop indices: 1=A, 2=B, 3=C, 4=D
array[Workshops] of int: capacity_hours = [100, 150, 80, 200];

% production_rate[w,c] in units/hour
array[Workshops, Components] of int: production_rate =
 [| 10, 15,  5  % A
  | 15, 10,  5  % B
  | 20,  5, 10  % C
  | 10, 15, 20  % D
  |];

% Variables
array[Workshops, Components] of var 0.0..200.0: x; % hours allocated (bounded by max capacity)
var 0.0..1000000.0: P; % number of completed products (continuous LP)

% Constraints
constraint
  forall(w in Workshops) (
    sum(c in Components)(x[w,c]) <= capacity_hours[w]
  );

% Total production of each component must be at least P (1 unit of each component per product)
constraint
  forall(c in Components) (
    sum(w in Workshops)(production_rate[w,c] * x[w,c]) >= P
  );

% Objective
solve maximize P;