% Parameters
int: NumParts;
int: NumMachines;

set of int: Parts    = 1..NumParts;
set of int: Machines = 1..NumMachines;

array[Parts, Machines] of int: Time;        % hours needed for one unit of part k on machine s
array[Parts]           of int: Profit;      % profit per unit of part k
array[Machines]        of int: Capacity;    % monthly capacity (hours) of machine s

% Derived parameters
array[Parts] of int: MaxProduction =
  [ min( [ Capacity[s] div Time[k,s] | s in Machines ] )
  | k in Parts
  ];

int: GlobalMax = max(MaxProduction);        % common explicit upper bound for all decision vars

% Variables
array[Parts] of var 0..GlobalMax: Production;   % units of part k to produce

% Constraints
constraint
  forall(k in Parts)(
    Production[k] <= MaxProduction[k]          % individual upper bounds
  );

constraint
  forall(s in Machines)(
    sum(k in Parts)( Time[k,s] * Production[k] ) <= Capacity[s]   % machine-hour capacities
  );

% Objective
solve maximize
  sum(k in Parts)( Profit[k] * Production[k] );