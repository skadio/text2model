% Parameters
% Time requirements (minutes per appliance)
int: inspect_time_wm = 30;      % inspection time per washing machine
int: fix_time_wm     = 90;      % fixing time per washing machine
int: inspect_time_fr = 20;      % inspection time per freezer
int: fix_time_fr     = 125;     % fixing time per freezer

% Available time (minutes)
int: inspect_time_available = 5000;   % total inspection minutes available
int: fix_time_available     = 20000;  % total fixing/schedule minutes available

% Earnings ($ per appliance)
int: profit_wm = 250;          % profit per washing machine
int: profit_fr = 375;          % profit per freezer

% Derived safe upper bounds (for bounded decision variables)
int: max_wm = min(inspect_time_available div inspect_time_wm,
                  fix_time_available div fix_time_wm);
int: max_fr = min(inspect_time_available div inspect_time_fr,
                  fix_time_available div fix_time_fr);

% Variables
var 0..max_wm: n_wm;   % number of washing machines to repair
var 0..max_fr: n_fr;   % number of freezers to repair

var 0..(profit_wm * max_wm + profit_fr * max_fr): total_profit; % total earnings

% Constraints
% Inspection time capacity constraint
constraint
  inspect_time_wm * n_wm + inspect_time_fr * n_fr <= inspect_time_available;

% Fixing/schedule time capacity constraint
constraint
  fix_time_wm * n_wm + fix_time_fr * n_fr <= fix_time_available;

% Define total profit from repaired appliances
constraint
  total_profit = profit_wm * n_wm + profit_fr * n_fr;

% Objective
solve maximize total_profit;