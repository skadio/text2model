% Parameters
% Resource usage and outputs per box type
int: metal_per_cheap = 3;
int: acid_per_cheap  = 5;
int: foam_per_cheap  = 8;
int: heat_per_cheap  = 2;

int: metal_per_expensive = 5;
int: acid_per_expensive  = 8;
int: foam_per_expensive  = 10;
int: heat_per_expensive  = 3;

% Available resources / limits
int: metal_available = 200;
int: acid_available  = 300;
int: heat_max        = 50;

% Upper bounds (safe maxima from each constraint alone)
int: max_cheap =
  min(metal_available div metal_per_cheap,
  min(acid_available div acid_per_cheap,
      heat_max div heat_per_cheap));

int: max_expensive =
  min(metal_available div metal_per_expensive,
  min(acid_available div acid_per_expensive,
      heat_max div heat_per_expensive));

% Variables
var 0..max_cheap: cheap_boxes;                 % number of cheap boxes to make
var 0..max_expensive: expensive_boxes;         % number of expensive boxes to make

% Total foam produced (bounded by maximum possible from variable bounds)
var 0..(foam_per_cheap * max_cheap + foam_per_expensive * max_expensive): total_foam;

% Constraints
% --- Resource capacity constraints (metal and acid) ---
constraint
  metal_per_cheap * cheap_boxes + metal_per_expensive * expensive_boxes
  <= metal_available;

constraint
  acid_per_cheap * cheap_boxes + acid_per_expensive * expensive_boxes
  <= acid_available;

% --- Heat limit constraint ---
constraint
  heat_per_cheap * cheap_boxes + heat_per_expensive * expensive_boxes
  <= heat_max;

% --- Define total foam produced from chosen boxes ---
constraint
  total_foam =
    foam_per_cheap * cheap_boxes + foam_per_expensive * expensive_boxes;

% Objective
solve maximize total_foam;