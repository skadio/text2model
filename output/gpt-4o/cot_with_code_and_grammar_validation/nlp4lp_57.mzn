% Parameters
int: NumMachines;
int: NumParts;

set of int: M = 1..NumMachines;
set of int: P = 1..NumParts;

array[M,P] of int: TimeRequired;        % hours needed on machine m for one batch of part p
array[M]     of int: MachineCosts;      % direct operating cost per hour for machine m
array[M]     of int: Availability;      % regular-time hours available on machine m
array[M]     of int: OvertimeHour;      % overtime hours available on machine m

array[P]     of int: Prices;            % revenue per batch of part p
array[P]     of int: MinBatches;        % contractual minimum batches of part p

int: StandardCost;                      % standard labour cost per hour (machine 1)
int: OvertimeCost;                      % overtime labour cost per hour (machine 1)

% Variables
array[P] of var int: Batches;                     % number of batches produced for part p
array[M] of var int: Hours;                       % total hours used on machine m
var 0..OvertimeHour[1]: OvertimeHours1;           % overtime hours on machine 1

% Constraints
constraint
  forall(p in P)( Batches[p] >= MinBatches[p] );

constraint
  forall(m in M)(
    Hours[m] = sum(p in P)( TimeRequired[m,p] * Batches[p] )
  );

% Regular–time capacity respected on machines 2..NumMachines
constraint
  forall(m in 2..NumMachines)(
    Hours[m] <= Availability[m]
  );

% Linking overtime for machine 1
constraint Hours[1] <= Availability[1] + OvertimeHour[1];
constraint OvertimeHours1 >= Hours[1] - Availability[1];
constraint OvertimeHours1 >= 0;

% Objective
var int: Profit =
    sum(p in P)( Prices[p] * Batches[p] )
  - (
        % Machine 1 costs: direct + labour (piece-wise via OvertimeHours1)
        MachineCosts[1] * Hours[1]
      + StandardCost * (Hours[1] - OvertimeHours1)
      + OvertimeCost * OvertimeHours1
        % Machines 2..M: only direct operating costs
      + sum(m in 2..NumMachines)( MachineCosts[m] * Hours[m] )
    );

solve maximize Profit;