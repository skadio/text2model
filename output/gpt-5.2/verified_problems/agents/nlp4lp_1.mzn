% Parameters
int: M;                                 % Number of goods
int: N;                                 % Number of raw materials

array[1..N] of int: Available;          % Available amount of raw material i
array[1..N, 1..M] of int: Requirements; % Units of raw material i needed per unit of good j
array[1..M] of int: Prices;             % Revenue per unit of good j

% Variables
array[1..M] of var int: Produce;        % Units of each good j to produce (non-negative)
var int: TotalRevenue;                  % Total revenue to maximize

% Constraints
% Non-negativity (kept as constraints to avoid extra bounds in declarations)
constraint forall(j in 1..M) (Produce[j] >= 0);

% Raw material capacity constraints:
% For each raw material i, total usage across all goods cannot exceed availability.
constraint
  forall(i in 1..N) (
    sum(j in 1..M) (Requirements[i, j] * Produce[j]) <= Available[i]
  );

% Total revenue definition:
constraint
  TotalRevenue = sum(j in 1..M) (Prices[j] * Produce[j]);

% Objective
solve maximize TotalRevenue;