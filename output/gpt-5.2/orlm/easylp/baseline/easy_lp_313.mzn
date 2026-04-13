% Resource allocation MILP (all data embedded)

int: total_resource = 1000;
int: res_tank = 5;
int: res_air = 3;
int: res_sub = 2;

int: strength_req = 200;

int: cost_tank = 30;
int: cost_air = 20;
int: cost_sub = 10;

var 0..total_resource div res_tank: Tanks;
var 0..total_resource div res_air: Aircrafts;
var 0..total_resource div res_sub: Submarines;

constraint res_tank*Tanks + res_air*Aircrafts + res_sub*Submarines <= total_resource;

constraint 2*Tanks + 4*Aircrafts + Submarines >= strength_req;

constraint Tanks - (Aircrafts + Submarines) = 50;

var int: TotalCost = cost_tank*Tanks + cost_air*Aircrafts + cost_sub*Submarines;

solve minimize TotalCost;

output [
  "Tanks=", show(Tanks), "\n",
  "Aircrafts=", show(Aircrafts), "\n",
  "Submarines=", show(Submarines), "\n",
  "TotalCost=", show(TotalCost), "\n"
];