% Parameters
int: max_ta = 1000;          % Tanks + Aircrafts limit
int: max_sd = 600;           % Ships + Drones limit

int: tank_pts = 4;
int: aircraft_pts = 3;
int: ship_pts = 5;
int: drone_pts = 2;

int: tank_max = 700;
int: aircraft_max = 400;
int: ship_max = 300;
int: drone_max = 250;

% Variables
var 0..tank_max: Tanks;
var 0..aircraft_max: Aircrafts;
var 0..ship_max: Ships;
var 0..drone_max: Drones;

var 0..(tank_pts*tank_max + aircraft_pts*aircraft_max + ship_pts*ship_max + drone_pts*drone_max): TotalSupport;

% Constraints
constraint Tanks + Aircrafts <= max_ta;
constraint Ships + Drones <= max_sd;

constraint Tanks >= Ships + 200;
constraint abs(Aircrafts - Drones) <= 50;

constraint TotalSupport = tank_pts*Tanks + aircraft_pts*Aircrafts + ship_pts*Ships + drone_pts*Drones;

% Objective
solve minimize TotalSupport;