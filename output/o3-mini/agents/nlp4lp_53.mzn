include "globals.mzn";

% Data (provided in .dzn file)
int: M;                              % number of machines
int: P;                              % number of parts
array[1..M, 1..P] of int: TimeRequired;  % time required on machine m for one batch of part p
array[1..M] of int: MachineCosts;          % cost per hour operating machine m (regular time)
array[1..M] of int: Availability;          % available hours on machine m per month
array[1..P] of int: Prices;                % revenue per batch for part p
array[1..P] of int: MinBatches;            % minimum batches to produce for part p
array[1..M] of float: ExtraCosts;          % extra cost per hour for machine m (overtime)
array[1..M] of int: MaxExtra;              % maximum extra (overtime) hours allowed for machine m

% Parameters for variable domains
int: UPPER = 10000; 
int: max_T = max([TimeRequired[m,p] | m in 1..M, p in 1..P]);
int: UPPER_H = UPPER * max_T;

% Decision variables:

% Number of batches to produce for each part.
array[1..P] of var int: batches;
constraint
  forall(p in 1..P) (
    batches[p] >= MinBatches[p] /\ batches[p] <= UPPER
  );

% For each machine m, total hours used in production.
array[1..M] of var 0..UPPER_H: H;
constraint
  forall(m in 1..M)(
    H[m] = sum(p in 1..P)(TimeRequired[m, p] * batches[p])
  );

% For each machine, split H[m] into Normal usage (within Availability) and Overtime (extra)
array[1..M] of var 0..max(Availability)+UPPER_H: Normal; % regular hours used, bounded by Availability
array[1..M] of var 0..UPPER_H: Over;     % overtime hours used, bounded by MaxExtra below

constraint
  forall(m in 1..M)(
    H[m] = Normal[m] + Over[m] /\
    Normal[m] <= Availability[m] /\
    Over[m] <= MaxExtra[m]
  );

% Objective: maximize profit.
% Profit = revenue from batches - cost on machines,
% where cost on machine m = (Normal[m] * MachineCosts[m]) + (Over[m] * ExtraCosts[m])
var float: Profit = sum(p in 1..P)( Prices[p] * batches[p] )
                   - sum(m in 1..M)( float(Normal[m]) * float(MachineCosts[m]) + float(Over[m]) * ExtraCosts[m] );

solve maximize Profit;

output [
  "Profit = ", show(Profit), "\n",
  "Batches per part: ", show(batches), "\n",
  "Total machine hours (H): ", show(H), "\n",
  "Regular machine usage (within availability): ", show(Normal), "\n",
  "Extra (overtime) hours used: ", show(Over), "\n"
];