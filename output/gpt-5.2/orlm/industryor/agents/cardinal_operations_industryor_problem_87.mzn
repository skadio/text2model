% Parameters
% Processing times (minutes per lot)
int: m1_min_per_lot_liquid = 50;
int: m2_min_per_lot_liquid = 30;
int: m1_min_per_lot_solid  = 24;
int: m2_min_per_lot_solid  = 33;

% Initial inventories (lots)
float: init_liquid = 30.0;
float: init_solid  = 90.0;

% Available machine time (hours -> minutes)
int: m1_avail_hours = 40;
int: m2_avail_hours = 35;
int: m1_avail_min = 60 * m1_avail_hours;
int: m2_avail_min = 60 * m2_avail_hours;

% Forecast demand (lots)
float: demand_liquid = 75.0;
float: demand_solid  = 95.0;


% Variables
% Production quantities (lots); fractional lots allowed
var float: prod_liquid; % lots of liquid produced this week
var float: prod_solid;  % lots of solid produced this week

% Ending inventories (lots)
var float: end_liquid;  % ending inventory of liquid
var float: end_solid;   % ending inventory of solid


% Constraints
% Nonnegativity constraints (production and ending inventories)
constraint prod_liquid >= 0.0;
constraint prod_solid  >= 0.0;
constraint end_liquid  >= 0.0;
constraint end_solid   >= 0.0;

% Machine capacity constraints (in minutes)
constraint
  m1_min_per_lot_liquid * prod_liquid
+ m1_min_per_lot_solid  * prod_solid
<= m1_avail_min;

constraint
  m2_min_per_lot_liquid * prod_liquid
+ m2_min_per_lot_solid  * prod_solid
<= m2_avail_min;

% Inventory balance constraints (ending inventory after meeting demand)
constraint end_liquid = init_liquid + prod_liquid - demand_liquid;
constraint end_solid  = init_solid  + prod_solid  - demand_solid;


% Objective
solve maximize (end_liquid + end_solid);