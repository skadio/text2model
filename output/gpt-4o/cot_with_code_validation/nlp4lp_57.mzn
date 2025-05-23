% Parameters
int: NumMachines;
int: NumParts;

set of int: Machines = 1..NumMachines;
set of int: Parts    = 1..NumParts;

array[Machines, Parts] of int: TimeRequired;      % hours needed on machine m for a batch of part p
array[Machines]          of int: MachineCosts;    % basic operating cost per hour of machine m
array[Machines]          of int: Availability;    % regular-time hours available on machine m
array[Machines]          of int: OvertimeHour;    % overtime hours available on machine m
array[Parts]             of int: Prices;          % selling price per batch of part p
array[Parts]             of int: MinBatches;      % contract minimum batches of part p

int: StandardCost;                                % labour cost per regular hour on machine 1
int: OvertimeCost;                                % labour cost per overtime hour on machine 1

int: big = 1000000;                               % sufficiently large constant

array[Parts] of int: MaxBatches =                 % crude upper bound for each part
  [ min( [ if m == 1 then big
           else (Availability[m] + OvertimeHour[m]) div
                max(1, TimeRequired[m,p])
         endif
         | m in Machines ] )
  | p in Parts ];

% Variables
array[Parts]   of var 0..big: batches;            % number of batches for each part
array[Machines] of var 0..big: normal_hours;      % regular-time hours on machine m
array[Machines] of var 0..big: overtime_hours;    % overtime hours on machine m

% Constraints
constraint
  forall(p in Parts)(
    MinBatches[p] <= batches[p] /\ batches[p] <= MaxBatches[p]
  );

constraint
  forall(m in Machines)(
    normal_hours[m] + overtime_hours[m] =
      sum(p in Parts)( TimeRequired[m,p] * batches[p] )
  );

constraint
  forall(m in Machines where m != 1)(
        normal_hours[m]  <= Availability[m]
    /\  overtime_hours[m] <= OvertimeHour[m]
  );

% Objective
var int: revenue     = sum(p in Parts)( Prices[p] * batches[p] );

var int: cost_other  =
  sum(m in Machines where m != 1)(
        MachineCosts[m] * (normal_hours[m] + overtime_hours[m])
  );

var int: cost_first  =
      MachineCosts[1] * (normal_hours[1] + overtime_hours[1])
    + StandardCost    *  normal_hours[1]
    + OvertimeCost    *  overtime_hours[1];

var int: total_cost = cost_other + cost_first;

var int: profit = revenue - total_cost;

solve maximize profit;