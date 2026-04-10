% Parameters
% Contract requirements (kg)
int: req_rasp = 10;
int: req_blue = 9;
int: req_straw = 15;

% Daily operating costs ($/day)
int: cost_old = 300;
int: cost_new = 200;

% Daily production at each farm (kg/day)
int: old_rasp = 2;
int: old_blue = 2;
int: old_straw = 4;

int: new_rasp = 4;
int: new_blue = 1;
int: new_straw = 2;

% Simple upper bounds for days (enough to meet each requirement alone, then take max)
int: ub_old_days = max([
  (req_rasp + old_rasp - 1) div old_rasp,
  (req_blue + old_blue - 1) div old_blue,
  (req_straw + old_straw - 1) div old_straw
]);

int: ub_new_days = max([
  (req_rasp + new_rasp - 1) div new_rasp,
  (req_blue + new_blue - 1) div new_blue,
  (req_straw + new_straw - 1) div new_straw
]);

% Variables
% Number of operating days at each farm
var 0..ub_old_days: days_old;
var 0..ub_new_days: days_new;

% Total delivered amounts (kg), derived variables for clarity/use in constraints
var 0..(old_rasp * ub_old_days + new_rasp * ub_new_days): total_rasp;
var 0..(old_blue * ub_old_days + new_blue * ub_new_days): total_blue;
var 0..(old_straw * ub_old_days + new_straw * ub_new_days): total_straw;

% Total cost ($)
var 0..(cost_old * ub_old_days + cost_new * ub_new_days): total_cost;

% Constraints
% Link totals to operating days (production balance equations)
constraint total_rasp  = old_rasp  * days_old + new_rasp  * days_new;
constraint total_blue  = old_blue  * days_old + new_blue  * days_new;
constraint total_straw = old_straw * days_old + new_straw * days_new;

% Meet (or exceed) contract requirements
constraint total_rasp  >= req_rasp;
constraint total_blue  >= req_blue;
constraint total_straw >= req_straw;

% Link total cost to operating days (cost accounting)
constraint total_cost = cost_old * days_old + cost_new * days_new;

% Objective
solve minimize total_cost;