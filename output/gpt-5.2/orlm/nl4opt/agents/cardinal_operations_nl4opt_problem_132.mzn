% Parameters
int: assembly_time_desk = 40;        % minutes of assembly per desk
int: sanding_time_desk  = 20;        % minutes of sanding per desk
int: assembly_time_drawer = 30;      % minutes of assembly per drawer
int: sanding_time_drawer  = 10;      % minutes of sanding per drawer

int: assembly_available = 4000;      % total available assembly minutes
int: sanding_available  = 3500;      % total available sanding minutes

int: profit_desk   = 100;            % profit per desk ($)
int: profit_drawer = 90;             % profit per drawer ($)

% Variables
var 0..(assembly_available div assembly_time_desk): desks;       % number of desks to produce
var 0..(assembly_available div assembly_time_drawer): drawers;   % number of drawers to produce

var 0..(profit_desk*(assembly_available div assembly_time_desk)
       + profit_drawer*(assembly_available div assembly_time_drawer)): total_profit; % total profit ($)

% Constraints
% Resource capacity constraints (assembly and sanding time limits)
constraint
  assembly_time_desk * desks + assembly_time_drawer * drawers <= assembly_available;

constraint
  sanding_time_desk * desks + sanding_time_drawer * drawers <= sanding_available;

% Profit accounting constraint (define total profit from production quantities)
constraint
  total_profit = profit_desk * desks + profit_drawer * drawers;

% Objective
solve maximize total_profit;