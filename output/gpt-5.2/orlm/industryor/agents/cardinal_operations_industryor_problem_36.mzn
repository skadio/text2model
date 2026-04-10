% Parameters
%--------------------------------------------------------------------
% Models
%--------------------------------------------------------------------
set of int: MODELS = 1..2;
int: A = 1;
int: B = 2;

%--------------------------------------------------------------------
% Processes
%--------------------------------------------------------------------
set of int: PROCS = 1..2;
int: P1 = 1; % Process I
int: P2 = 2; % Process II

%--------------------------------------------------------------------
% Processing times (hours per unit) by process and model
% time_per_unit[p,m]
%--------------------------------------------------------------------
array[PROCS, MODELS] of int: time_per_unit =
  array2d(PROCS, MODELS,
    [ 4, 6,   % Process I: A, B
      3, 2    % Process II: A, B
    ]);

% Weekly capacity (hours) by process (regular time)
array[PROCS] of int: capacity = [150, 70];

% Profit per unit by model ($/unit)
array[MODELS] of int: profit = [300, 450];

% Goal/requirement parameters
int: min_profit = 10000;
array[MODELS] of int: min_production = [10, 15]; % A, B

% For p3: target/full utilization
int: target_proc1_hours = 150; % exactly 150 hours for Process I

% Upper bounds for production (derived from capacities; safe/tight bounds)
int: max_units_A = min(capacity[P1] div time_per_unit[P1, A],
                       capacity[P2] div time_per_unit[P2, A]);
int: max_units_B = min(capacity[P1] div time_per_unit[P1, B],
                       capacity[P2] div time_per_unit[P2, B]);

% Variables
%--------------------------------------------------------------------
% Weekly production quantities (units)
% Use explicit bounds derived above.
%--------------------------------------------------------------------
array[MODELS] of var 0..max(max_units_A, max_units_B): x;

% Total hours used per process (computed from x)
array[PROCS] of var 0..10000: used_hours;

% Overtime hours per process (allows exceeding regular capacity)
array[PROCS] of var 0..10000: overtime;

% Total weekly profit
var 0..10000000: total_profit;

% Deviation variables for goals/targets (kept to reflect p1/p3 structure)
var 0..min_profit: profit_shortfall;
var 0..10000: proc1_under;
var 0..10000: proc1_over;

% Constraints
%--------------------------------------------------------------------
% Production bounds (tightening via derived maxima)
%--------------------------------------------------------------------
constraint x[A] <= max_units_A;
constraint x[B] <= max_units_B;

%--------------------------------------------------------------------
% Process hours calculation from production plan
%--------------------------------------------------------------------
constraint forall(p in PROCS) (
  used_hours[p] = sum(m in MODELS)(time_per_unit[p, m] * x[m])
);

%--------------------------------------------------------------------
% Capacity constraints with overtime allowed
% (regular capacity may be exceeded by overtime)
%--------------------------------------------------------------------
constraint forall(p in PROCS) (
  used_hours[p] <= capacity[p] + overtime[p]
);

%--------------------------------------------------------------------
% Profit computation and minimum profit goal/requirement
%--------------------------------------------------------------------
constraint total_profit = sum(m in MODELS)(profit[m] * x[m]);

% Allowable shortfall variable (0 if profit requirement is met)
constraint total_profit + profit_shortfall >= min_profit;

%--------------------------------------------------------------------
% Contractual minimum weekly production quantities
%--------------------------------------------------------------------
constraint forall(m in MODELS) (
  x[m] >= min_production[m]
);

%--------------------------------------------------------------------
% p3: Process I should be exactly 150 hours (modeled with deviations)
%--------------------------------------------------------------------
constraint used_hours[P1] + proc1_under - proc1_over = target_proc1_hours;

%--------------------------------------------------------------------
% p3: Process II should be fully utilized (at least its regular capacity),
%     with overtime already allowed via used_hours <= capacity + overtime.
%--------------------------------------------------------------------
constraint used_hours[P2] >= capacity[P2];

% Objective
solve maximize total_profit;