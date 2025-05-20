% Parameters
int: M;
int: P;

set of int: Machines = 1..M;
set of int: Parts    = 1..P;

array[Machines, Parts] of int: TimeRequired;   % hours per batch
array[Machines]          of int: MachineCosts; % €/hour (machines 2..M)
array[Machines]          of int: Availability; % monthly hours (machines 2..M, 1 = standard-hour limit)
array[Parts]             of int: Prices;       % € per batch sold
array[Parts]             of int: MinBatches;   % contractual minimum batches

int: StandardCost;   % €/h for first machine up to Availability[1]
int: OvertimeCost;   % €/h for first machine beyond Availability[1]
int: OvertimeHour;   % maximum overtime hours on first machine
int: MinProfit;      % required minimum profit


% Decision variables
int: MaxBatch = 10_000;                      % coarse upper bound for production
array[Parts]   of var 0..MaxBatch: Batches;  % batches produced per part

array[Machines] of var int: TimeUsed;        % hours used on every machine
var 0..OvertimeHour: Overtime;               % overtime hours on the first machine
var int: Profit;                             % total profit to maximise


% Constraints
% Machine loads
constraint
  forall(m in Machines)(
    TimeUsed[m] = sum(p in Parts)(TimeRequired[m,p] * Batches[p])
  );

% Contractual minimum production
constraint
  forall(p in Parts)(Batches[p] >= MinBatches[p]);

% Capacity limits for machines 2..M
constraint
  forall(m in Machines where m != 1)(
    TimeUsed[m] <= Availability[m]
  );

% Standard/overtime relations on machine 1
constraint
    TimeUsed[1] - Overtime <= Availability[1] /\
    Overtime >= TimeUsed[1] - Availability[1] /\
    Overtime <= TimeUsed[1]                /\
    Overtime <= OvertimeHour;

% Profit computation
constraint
  Profit =
      % revenue
      sum(p in Parts)(Prices[p] * Batches[p])
      -
      % cost on first machine
      ( StandardCost * (TimeUsed[1] - Overtime)
        + OvertimeCost * Overtime )
      -
      % costs on machines 2..M
      sum(m in Machines where m != 1)(
        sum(p in Parts)(
          TimeRequired[m,p] * Batches[p] * MachineCosts[m]
        )
      );

% Required minimum profit
constraint Profit >= MinProfit;


% Objective
solve maximize Profit;