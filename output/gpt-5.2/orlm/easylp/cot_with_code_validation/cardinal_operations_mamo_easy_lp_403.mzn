% Parameters
int: max_tanks = 700;
int: max_aircrafts = 400;
int: max_ships = 300;
int: max_drones = 250;

int: max_tanks_aircrafts = 1000;
int: max_ships_drones = 600;

int: min_tanks_minus_ships = 200;
int: max_aircrafts_minus_drones_abs = 50;

int: sp_tank = 4;
int: sp_aircraft = 3;
int: sp_ship = 5;
int: sp_drone = 2;

% Variables
var 0..max_tanks: Tanks;
var 0..max_aircrafts: Aircrafts;
var 0..max_ships: Ships;
var 0..max_drones: Drones;

var 0..(sp_tank*max_tanks + sp_aircraft*max_aircrafts + sp_ship*max_ships + sp_drone*max_drones): TotalSupport;

% Constraints
constraint Tanks + Aircrafts <= max_tanks_aircrafts;
constraint Ships + Drones <= max_ships_drones;

constraint Tanks - Ships >= min_tanks_minus_ships;
constraint abs(Aircrafts - Drones) <= max_aircrafts_minus_drones_abs;

constraint TotalSupport = sp_tank*Tanks + sp_aircraft*Aircrafts + sp_ship*Ships + sp_drone*Drones;

% Objective
solve minimize TotalSupport;