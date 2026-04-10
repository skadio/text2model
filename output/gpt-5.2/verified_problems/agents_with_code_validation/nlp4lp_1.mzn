% Parameters
int: M; % Number of different goods
int: N; % Number of different raw materials

set of int: GOODS = 1..M;
set of int: MATERIALS = 1..N;

array[MATERIALS] of int: Available; % Available amount of raw material i

% Requirements provided in the data are indexed as [1..M, 1..N] (goods x materials).
% Coerce to [MATERIALS, GOODS] (materials x goods) for consistent use in constraints.
array[GOODS, MATERIALS] of int: Requirements_in;
array[MATERIALS, GOODS] of int: Requirements =
  array2d(MATERIALS, GOODS, [ Requirements_in[j,i] | i in MATERIALS, j in GOODS ]);

array[GOODS] of int: Prices; % Revenue per unit of good j

% Helper bounds (depend only on inputs)
int: ub_production = max(Available); % safe (possibly loose) upper bound per good
int: ub_revenue = sum(j in GOODS)(Prices[j] * ub_production);

% Decision variables
array[GOODS] of var 0..ub_production: Produce;
var 0..ub_revenue: TotalRevenue;

% Constraints
constraint
  TotalRevenue = sum(j in GOODS)(Prices[j] * Produce[j]);

constraint
  forall(i in MATERIALS) (
    sum(j in GOODS)(Requirements[i, j] * Produce[j]) <= Available[i]
  );

% Objective
solve maximize TotalRevenue;