% Military logistics resource allocation - embedded data MiniZinc model

var 0..700: Tanks;
var 0..400: Aircrafts;
var 0..300: Ships;
var 0..250: Drones;

% Group capacity constraints
constraint Tanks + Aircrafts <= 1000;
constraint Ships + Drones <= 600;

% Difference constraints
constraint Tanks - Ships >= 200;
constraint abs(Aircrafts - Drones) <= 50;

% Support points per unit
int: sp_tank = 4;
int: sp_air = 3;
int: sp_ship = 5;
int: sp_drone = 2;

var int: TotalSupport = sp_tank * Tanks + sp_air * Aircrafts + sp_ship * Ships + sp_drone * Drones;

solve minimize TotalSupport;

output [
  "Tanks=", show(Tanks), "\n",
  "Aircrafts=", show(Aircrafts), "\n",
  "Ships=", show(Ships), "\n",
  "Drones=", show(Drones), "\n",
  "MinimumTotalSupportPoints=", show(TotalSupport), "\n"
];