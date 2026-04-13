% Parameters
% Support points required per unit
int: support_tank = 4;
int: support_aircraft = 3;
int: support_ship = 5;
int: support_drone = 2;

% Maximum allowable quantity per unit type
int: max_tanks = 700;
int: max_aircrafts = 400;
int: max_ships = 300;
int: max_drones = 250;

% Group capacity limits
int: max_tank_aircraft_total = 1000;
int: max_ship_drone_total = 600;

% Difference constraints
int: min_tanks_over_ships = 200;     % tanks >= ships + 200
int: max_aircraft_drone_diff = 50;   % |aircrafts - drones| <= 50


% Variables
var 0..max_tanks: tanks;             % number of Tanks
var 0..max_aircrafts: aircrafts;     % number of Aircrafts
var 0..max_ships: ships;             % number of Ships
var 0..max_drones: drones;           % number of Drones

% Upper bound for total support points based on maxima
var 0..(support_tank*max_tanks
      + support_aircraft*max_aircrafts
      + support_ship*max_ships
      + support_drone*max_drones): total_support;  % total support points


% Constraints
% --- Capacity constraints (group totals) ---
constraint tanks + aircrafts <= max_tank_aircraft_total;
constraint ships + drones <= max_ship_drone_total;

% --- Difference / relationship constraints ---
constraint tanks >= ships + min_tanks_over_ships;
constraint abs(aircrafts - drones) <= max_aircraft_drone_diff;

% --- Total support points definition ---
constraint total_support =
    support_tank * tanks
  + support_aircraft * aircrafts
  + support_ship * ships
  + support_drone * drones;


% Objective
solve minimize total_support;