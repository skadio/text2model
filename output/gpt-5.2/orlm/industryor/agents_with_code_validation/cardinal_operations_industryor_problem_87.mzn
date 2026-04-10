% Fertilizer production planning (LP with fractional lots)

%--------------------------
% Parameters
%--------------------------
int: m1_time_liquid = 50;   % minutes per lot on Machine 1
int: m2_time_liquid = 30;   % minutes per lot on Machine 2
int: m1_time_solid  = 24;   % minutes per lot on Machine 1
int: m2_time_solid  = 33;   % minutes per lot on Machine 2

float: init_liquid = 30.0;  % initial inventory (lots)
float: init_solid  = 90.0;

float: m1_avail_minutes = 40.0 * 60.0; % 40 hours -> minutes
float: m2_avail_minutes = 35.0 * 60.0; % 35 hours -> minutes

float: demand_liquid = 75.0;
float: demand_solid  = 95.0;

%--------------------------
% Decision variables
%--------------------------
var 0.0..infinity: prod_liquid;
var 0.0..infinity: prod_solid;

var 0.0..infinity: ship_liquid;
var 0.0..infinity: ship_solid;

var 0.0..infinity: end_liquid;
var 0.0..infinity: end_solid;

%--------------------------
% Constraints
%--------------------------
% Machine capacity (minutes)
constraint
  m1_time_liquid * prod_liquid + m1_time_solid * prod_solid <= m1_avail_minutes;

constraint
  m2_time_liquid * prod_liquid + m2_time_solid * prod_solid <= m2_avail_minutes;

% Inventory balance
constraint end_liquid = init_liquid + prod_liquid - ship_liquid;
constraint end_solid  = init_solid  + prod_solid  - ship_solid;

% Demand upper bounds (shipments cannot exceed demand)
constraint ship_liquid <= demand_liquid;
constraint ship_solid  <= demand_solid;

% Also cannot ship more than available (implied by end_* >= 0, but kept explicit)
constraint ship_liquid <= init_liquid + prod_liquid;
constraint ship_solid  <= init_solid  + prod_solid;

%--------------------------
% Objective: maximize total ending inventory
%--------------------------
solve maximize end_liquid + end_solid;