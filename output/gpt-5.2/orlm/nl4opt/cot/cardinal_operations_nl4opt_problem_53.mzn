% Parameters (with values embedded)
int: nFert = 2;
set of int: F = 1..nFert;

int: cost_C = 2;
int: cost_Y = 3;
array[F] of int: cost = [cost_C, cost_Y];

int: nNutrients = 2;
set of int: N = 1..nNutrients; % 1=nitrous oxide, 2=vitamin mix

array[F, N] of float: content = array2d(F, N, [
  1.5, 3.0,   % Fertilizer C: nitrous, vitamin
  5.0, 1.0    % Fertilizer Y: nitrous, vitamin
]);

array[N] of float: req = [5.0, 8.0];

% Variables
array[F] of var float: x; % x[1]=kg of C, x[2]=kg of Y

% Constraints
constraint forall(f in F)(x[f] >= 0.0);

constraint forall(n in N)(
  sum(f in F)(content[f,n] * x[f]) >= req[n]
);

% Objective
var float: total_cost = sum(f in F)(int2float(cost[f]) * x[f]);
solve minimize total_cost;