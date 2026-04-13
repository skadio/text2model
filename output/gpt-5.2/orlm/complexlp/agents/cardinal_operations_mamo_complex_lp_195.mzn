% Parameters
int: nRegions = 5;                         % Number of regions
set of int: Regions = 1..nRegions;         % Region index set

array[Regions, Regions] of int: cost =     % cost[i,j] = cost to move 1 car from i to j
  [|  0, 10, 12, 17, 34
   | 10,  0, 18,  8, 46
   | 12, 18,  0,  9, 27
   | 17,  8,  9,  0, 20
   | 34, 46, 27, 20,  0 |];

array[Regions] of int: available =         % available cars initially in each region
  [115, 385, 410, 480, 610];

array[Regions] of int: required =          % cars needed in each region
  [300, 400, 800, 200, 300];

int: totalAvailable = sum(r in Regions)(available[r]);   % Total cars available
int: totalRequired  = sum(r in Regions)(required[r]);    % Total cars required


% Variables
array[Regions, Regions] of var 0..totalAvailable: move;  % move[i,j] = cars moved from i to j
var 0..(max(cost) * totalAvailable * nRegions): totalCost; % total transportation cost


% Constraints
% No self-moves
constraint forall(r in Regions)(move[r,r] = 0);

% Define total cost from flows
constraint totalCost = sum(i in Regions, j in Regions)(cost[i,j] * move[i,j]);

% Supply constraints: total cars shipped out of each region cannot exceed its available cars
constraint
  forall(i in Regions)(
    sum(j in Regions)(move[i,j]) <= available[i]
  );

% Demand constraints: total cars received by each region must meet its required need
constraint
  forall(j in Regions)(
    sum(i in Regions)(move[i,j]) >= required[j]
  );

% Global feasibility check (redundant but helpful)
constraint totalAvailable >= totalRequired;


% Objective
solve minimize totalCost;