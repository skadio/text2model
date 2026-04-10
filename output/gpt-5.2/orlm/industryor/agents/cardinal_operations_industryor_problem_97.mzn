% Parameters
% Resource requirements per unit
int: steel_per_A = 6;
int: alum_per_A  = 8;
int: labor_per_A = 11;
int: profit_A    = 5000;

int: steel_per_B = 12;
int: alum_per_B  = 20;
int: labor_per_B = 24;
int: profit_B    = 11000;

% Available resources
int: steel_avail = 200;
int: alum_avail  = 300;
int: labor_avail = 300;

% Overtime cost
int: overtime_cost_per_hour = 100;

% Useful variable bounds derived from capacities (ignoring overtime for bound)
int: max_A = min( steel_avail div steel_per_A,
                  min(alum_avail div alum_per_A, labor_avail div labor_per_A) );
int: max_B = min( steel_avail div steel_per_B,
                  min(alum_avail div alum_per_B, labor_avail div labor_per_B) );

% Variables
var 0..max_A: units_A;  % number of units produced of product A
var 0..max_B: units_B;  % number of units produced of product B

% Overtime hours used (upper bound large enough for any feasible production in bounds)
var 0..(labor_per_A*max_A + labor_per_B*max_B): overtime_hours;

% Total profit after overtime cost
var int: total_profit;

% Constraints
%--- Resource capacity constraints (steel and aluminum cannot exceed availability)
constraint
  steel_per_A * units_A + steel_per_B * units_B <= steel_avail;

constraint
  alum_per_A * units_A + alum_per_B * units_B <= alum_avail;

%--- Labor and overtime linkage (overtime covers any labor above available hours)
constraint
  labor_per_A * units_A + labor_per_B * units_B <= labor_avail + overtime_hours;

%--- Total profit accounting (gross profit minus overtime cost)
constraint
  total_profit =
    profit_A * units_A + profit_B * units_B
    - overtime_cost_per_hour * overtime_hours;

% Objective
solve maximize total_profit;