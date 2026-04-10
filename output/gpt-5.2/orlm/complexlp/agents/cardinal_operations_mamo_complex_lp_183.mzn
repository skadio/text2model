% Parameters
int: nRegions = 5;                          % Number of regions (fixed to 5)
set of int: R = 1..nRegions;                % Region index set

array[R] of int: current = [120, 330, 400, 400, 600];   % Cars currently present at each region
array[R] of int: needed  = [150, 200, 600, 200, 400];   % Cars needed at each region

% Cost matrix (0 on diagonal; large M for disallowed directions that are not listed)
int: M = 1000000;                           % Big-M cost to effectively forbid unspecified moves
array[R, R] of int: cost =
  [|   0,  M, 13, 11, 28
   |   M,  0, 18,  8, 46
   |  13, 18,  0,  9, 27
   |  11,  8,  9,  0, 20
   |  28, 46, 27, 20,  0 |];

array[R] of int: supply = [max(0, current[i] - needed[i]) | i in R];  % Excess cars available to ship
array[R] of int: demand = [max(0, needed[i] - current[i]) | i in R];  % Cars required to receive

int: totalSupply = sum(i in R)(supply[i]);    % Total excess cars
int: totalDemand = sum(i in R)(demand[i]);    % Total required cars


% Variables
array[R, R] of var 0..totalSupply: x;         % x[i,j] = number of cars moved from region i to region j
var 0..(totalSupply * 1000000): totalCost;    % Total relocation cost (bounded conservatively)


% Constraints

%----------------------------
% Flow balance / feasibility
%----------------------------

% No self-shipment (keep diagonal at 0)
constraint
  forall(i in R) (
    x[i,i] = 0
  );

% Shipments out of a region cannot exceed its available excess (supply)
constraint
  forall(i in R) (
    sum(j in R)(x[i,j]) <= supply[i]
  );

% Shipments into a region must satisfy its shortage (demand)
constraint
  forall(j in R) (
    sum(i in R)(x[i,j]) = demand[j]
  );

% Ensure overall consistency between shipped amount and total demand
constraint
  sum(i in R, j in R)(x[i,j]) = totalDemand;

%----------------------------
% Cost calculation
%----------------------------

% Define total relocation cost from the flow and cost matrix
constraint
  totalCost = sum(i in R, j in R)(cost[i,j] * x[i,j]);


% Objective
solve minimize totalCost;