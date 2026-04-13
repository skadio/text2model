include "globals.mzn";

%----------------------------
% Input data (from .dzn)
%----------------------------
int: M;                                  % number of machines
int: P;                                  % number of parts

array[1..M, 1..P] of int: TimeRequired;   % hours per batch on machine m for part p
array[1..M] of int: MachineCosts;         % cost per hour for machine m
array[1..M] of int: Availability;         % available hours per month for machine m

array[1..P] of int: Prices;               % revenue per batch for part p
array[1..P] of int: MinBatches;           % minimum batches for part p

%----------------------------
% Decision variables
%----------------------------
% Upper bound for batches: limited by machine availability and positive time requirements
int: UB =
  if min([ TimeRequired[m,p] | m in 1..M, p in 1..P ]) <= 0 then
    1000000
  else
    max([ Availability[m] div max(1, min([ TimeRequired[m,p] | p in 1..P ])) | m in 1..M ])
  endif;

array[1..P] of var 0..UB: Batches;        % number of batches (of 100) to produce for each part

%----------------------------
% Constraints
%----------------------------
% Contract minimums
constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

% Machine capacity constraints
% For machines 1..M-2: enforce individual availability
constraint forall(m in 1..max(0, M-2)) (
  sum(p in 1..P)( TimeRequired[m,p] * Batches[p] ) <= Availability[m]
);

% Machines M-1 and M share availability (pooling), so enforce only combined availability
constraint
  if M >= 2 then
    sum(p in 1..P)( TimeRequired[M-1,p] * Batches[p] )
  + sum(p in 1..P)( TimeRequired[M,p]   * Batches[p] )
    <= Availability[M-1] + Availability[M]
  else
    % If there is only one machine, treat it normally
    sum(p in 1..P)( TimeRequired[1,p] * Batches[p] ) <= Availability[1]
  endif;

%----------------------------
% Objective: maximize profit
% Profit = revenue - operating costs
%----------------------------
var int: Revenue = sum(p in 1..P)( Prices[p] * Batches[p] );

var int: OperatingCost =
  sum(m in 1..M, p in 1..P)( MachineCosts[m] * TimeRequired[m,p] * Batches[p] );

var int: Profit = Revenue - OperatingCost;

solve maximize Profit;

%----------------------------
% Output
%----------------------------
output [
  "Batches = ", show(Batches), "\n",
  "Revenue = ", show(Revenue), "\n",
  "OperatingCost = ", show(OperatingCost), "\n",
  "Profit = ", show(Profit), "\n"
];