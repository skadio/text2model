% Parameters
int: NumMachines;
int: NumParts;

set of int: Machines = 1..NumMachines;
set of int: Parts    = 1..NumParts;

array[Machines, Parts] of int: TimeRequired;    % hours needed on machine m for one batch of part p
array[Machines]        of int: MachineCosts;    % cost per hour for machines 2..NumMachines
array[Machines]        of int: Availability;    % standard-time hours available (ignored for m = 1 in capacity)
array[Parts]           of int: Prices;          % revenue per batch of part p
array[Parts]           of int: MinBatches;      % contractual minimum batches for each part
int: StandardCost;                              % standard labour cost per hour on machine 1
int: OvertimeCost;                              % overtime labour cost per hour on machine 1
array[Machines]        of int: OvertimeHour;    % maximum overtime hours per machine

% Variables
array[Parts]    of var int: Batches;            % number of batches produced for each part
array[Machines] of var int: Hours;              % total hours used on each machine

var int: StdHours1;                             % standard-time hours on machine 1
var int: OverHours1;                            % overtime hours on machine 1

% Constraints
constraint
    forall(p in Parts)(
        Batches[p] >= MinBatches[p]             % meet minimum contract
    );

constraint
    forall(m in Machines)(
        Hours[m] = sum(p in Parts)(TimeRequired[m,p] * Batches[p])   % define machine hours
    );

constraint
    StdHours1 + OverHours1 = Hours[1] /\
    StdHours1 >= 0 /\ OverHours1 >= 0 /\
    StdHours1 <= Availability[1] /\
    OverHours1 <= OvertimeHour[1];

constraint
    forall(m in Machines where m != 1)(
        Hours[m] <= Availability[m] + OvertimeHour[m]
    );

% Objective
solve maximize
    sum(p in Parts)(Prices[p] * Batches[p]) -
    (StandardCost * StdHours1 + OvertimeCost * OverHours1 +
     sum(m in Machines where m != 1)(MachineCosts[m] * Hours[m]));