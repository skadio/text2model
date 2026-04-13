% Parameters
int: nRegions = 5;                                % number of regions
set of int: REGIONS = 1..nRegions;                % region index set

array[REGIONS] of int: initialStock =             % starting stock in each region
  [410, 266, 132, 6, 485];

array[REGIONS] of int: requiredStock =            % required (demand) in each region
  [274, 331, 232, 359, 74];

array[REGIONS, REGIONS] of int: transferCost =    % per-unit transfer cost i->j (0 on diagonal)
  [| 0,  24,  3,  27,  31
   | 24, 0,  11,  7,   37
   | 30, 1,  0,   38,  22
   | 36, 18, 17,  0,   35
   | 41, 35, 33,  33,  0 |];

int: totalSupply = sum(r in REGIONS)(initialStock[r]);   % total available supply
int: totalDemand = sum(r in REGIONS)(requiredStock[r]);  % total required demand
int: maxTransfer = totalSupply;                          % safe upper bound for any arc flow

% Variables
array[REGIONS, REGIONS] of var 0..maxTransfer: transfer; % units transferred from region i to j
var int: totalCost;                                      % total transportation cost

% Constraints

%--- Flow conservation / demand satisfaction per region ---
% Final stock in each region = initial + inflow - outflow, and must meet requiredStock.
constraint
  forall(r in REGIONS)(
    initialStock[r]
    + sum(i in REGIONS where i != r)(transfer[i, r])
    - sum(j in REGIONS where j != r)(transfer[r, j])
    >= requiredStock[r]
  );

%--- No self-transfer (diagonal must be zero) ---
constraint
  forall(r in REGIONS)(
    transfer[r, r] = 0
  );

%--- Total cost definition (exclude diagonal which is forced to 0) ---
constraint
  totalCost =
    sum(i in REGIONS, j in REGIONS where i != j)(
      transferCost[i, j] * transfer[i, j]
    );

%--- Global feasibility check: total supply must cover total demand ---
constraint
  totalSupply >= totalDemand;

% Objective
solve minimize totalCost;