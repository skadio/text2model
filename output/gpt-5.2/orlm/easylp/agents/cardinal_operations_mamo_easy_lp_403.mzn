% Parameters
% Support points required per unit
int: sp_tank     = 4;
int: sp_aircraft = 3;
int: sp_ship     = 5;
int: sp_drone    = 2;

% Maximum allowable quantity for each unit type
int: max_tanks     = 700;
int: max_aircrafts = 400;
int: max_ships     = 300;
int: max_drones    = 250;

% Group capacity limits
int: max_tank_aircraft_total = 1000;
int: max_ship_drone_total    = 600;

% Difference constraints
int: min_tanks_over_ships     = 200; % Tanks >= Ships + 200
int: max_aircraft_drone_diff  = 50;  % |Aircrafts - Drones| <= 50


% Variables
var 0..max_tanks: tanks;             % number of Tanks
var 0..max_aircrafts: aircrafts;      % number of Aircrafts
var 0..max_ships: ships;             % number of Ships
var 0..max_drones: drones;           % number of Drones

% Total support points to minimize (upper bound from max quantities)
var 0..(sp_tank*max_tanks
      + sp_aircraft*max_aircrafts
      + sp_ship*max_ships
      + sp_drone*max_drones): total_support_points;


% Constraints
% Link total_support_points to chosen unit quantities (support points accounting)
constraint
  total_support_points =
    sp_tank * tanks +
    sp_aircraft * aircrafts +
    sp_ship * ships +
    sp_drone * drones;

% Group capacity limits (logistical constraints)
constraint tanks + aircrafts <= max_tank_aircraft_total;
constraint ships + drones    <= max_ship_drone_total;

% Minimum tanks over ships
constraint tanks >= ships + min_tanks_over_ships;

% Max absolute difference between aircrafts and drones
constraint abs(aircrafts - drones) <= max_aircraft_drone_diff;


% Objective
solve minimize total_support_points;