% Parameters
int: nRegions = 5;                          % number of regions
set of int: R = 1..nRegions;                % region index set

array[R, R] of int: cost =                  % cost per car moved from i to j
  [|  0, 10, 12, 17, 34
   | 10,  0, 18,  8, 46
   | 12, 18,  0,  9, 27
   | 17,  8,  9,  0, 20
   | 34, 46, 27, 20,  0 |];

array[R] of int: currentCars =              % cars currently available in each region
  [115, 385, 410, 480, 610];

array[R] of int: neededCars =               % cars needed in each region
  [200, 500, 800, 200, 300];

% Precomputed bounds for decision variables
int: maxCars = sum(r in R)(currentCars[r]); % total cars in system (upper bound)

% Variables
array[R, R] of var 0..maxCars: move;        % move[i,j] = cars moved from region i to region j
var 0..(maxCars * max(cost)): totalCost;    % total transportation cost (objective)

% Constraints

% No self-moves: do not ship cars from a region to itself
constraint
  forall(r in R)(
    move[r, r] = 0
  );

% Flow balance / demand satisfaction:
% current + inflow - outflow must equal needed in every region
constraint
  forall(r in R)(
    currentCars[r]
    + sum(i in R where i != r)(move[i, r])
    - sum(j in R where j != r)(move[r, j])
    = neededCars[r]
  );

% Total transportation cost computed from all shipments
constraint
  totalCost =
    sum(i in R, j in R where i != j)(
      cost[i, j] * move[i, j]
    );

% Objective
solve minimize totalCost;