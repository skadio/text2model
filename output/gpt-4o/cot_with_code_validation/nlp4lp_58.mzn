% Parameters
int: M;                                 % Number of machines
int: P;                                 % Number of parts (batches) to be produced

array[1..M, 1..P] of int: TimeRequired; % Hours on machine m to produce one batch of part p
array[1..M] of int: MachineCosts;       % Cost per hour for machine m
array[1..M] of int: Availability;       % Monthly availability (in hours) for machine m
array[1..P] of int: Prices;             % Selling price per batch of part p
array[1..P] of int: MinBatches;         % Contractual minimum batches for part p

int: StandardCost;                      % Labour cost per hour (machine 1, standard hours)
int: OvertimeCost;                      % Labour cost per hour (machine 1, overtime hours)
int: OvertimeHour;                      % Standard-hour limit for machine 1
int: MinProfit;                         % Minimum desired profit

% ---------------------------------------------------------------------------
% Auxiliary constants for upper bounds (computed only from parameters)

% Largest number of batches that can be produced for each part, given
% the most restrictive NON-outsourced machine (machines 2..M).
array[1..P] of int: MaxBatches = [
    if M > 1 /\ exists(m in 2..M)(TimeRequired[m,p] > 0) then
        min([ Availability[m] div TimeRequired[m,p]
              | m in 2..M where TimeRequired[m,p] > 0 ])
    else
        1000000                 % Practically unbounded if no such machine
    endif
| p in 1..P];

% Maximum number of hours that could ever be required on each machine
array[1..M] of int: MaxHours =
   [ if m == 1 then
        sum(p in 1..P)(MaxBatches[p] * TimeRequired[m,p])
     else
        Availability[m]
     endif
   | m in 1..M];

% ---------------------------------------------------------------------------
% Variables
array[1..P] of var int: Batches;                      % Produced batches
array[1..M] of var 0..MaxHours[m]: Hours;             % Hours actually used on each machine

var 0..OvertimeHour: StdHours;                        % Standard hours on machine 1
var 0..MaxHours[1]:   OvtHours;                       % Overtime hours on machine 1

var int: Revenue;                                     % Total revenue
var int: Cost;                                        % Total production cost
var int: Profit;                                      % Profit to be maximised

% ---------------------------------------------------------------------------
% Constraints

% 1) Link hours used on each machine to chosen batch quantities
constraint
    forall(m in 1..M) (
        Hours[m] = sum(p in 1..P)( TimeRequired[m,p] * Batches[p] )
    );

% 2) Capacity limits for NON-outsourced machines (machines 2..M)
constraint
    forall(m in 2..M) (
        Hours[m] <= Availability[m]
    );

% 3) Contractual minimum batches per part
constraint
    forall(p in 1..P) (
        Batches[p] >= MinBatches[p] /\ Batches[p] <= MaxBatches[p]
    );

% 4) Split hours on outsourced machine 1 into standard and overtime
constraint StdHours + OvtHours = Hours[1];
constraint StdHours <= OvertimeHour;

% 5) Define revenue, cost, and profit
constraint
    Revenue = sum(p in 1..P)( Prices[p] * Batches[p] );

constraint
    Cost =
          % Machine operating costs (all machines)
          sum(m in 1..M)( MachineCosts[m] * Hours[m] )
        + % Labour costs on outsourced machine 1
          StandardCost * StdHours
        + OvertimeCost * OvtHours;

constraint
    Profit = Revenue - Cost;

% 6) Minimum profit requirement
constraint Profit >= MinProfit;

% ---------------------------------------------------------------------------
% Objective
solve maximize Profit;