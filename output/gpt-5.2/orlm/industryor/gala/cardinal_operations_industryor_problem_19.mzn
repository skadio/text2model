include "globals.mzn";

% Data (embedded from problem statement)
int: plastic_avail = 1200;
int: elec_avail    = 800;

int: p_robot = 15;
int: p_car   = 8;
int: p_block = 12;
int: p_doll  = 5;

int: plast_robot = 30;
int: plast_car   = 10;
int: plast_block = 20;
int: plast_doll  = 15;

int: elec_robot = 8;
int: elec_car   = 5;
int: elec_block = 3;
int: elec_doll  = 2;

% Decision variables: quantities to manufacture (nonnegative integers)
var 0..(plastic_avail div plast_robot): robot;
var 0..(plastic_avail div plast_car):   car;
var 0..(plastic_avail div plast_block): block;
var 0..(plastic_avail div plast_doll):  doll;

% Binary indicators: whether we manufacture each type (1 if quantity > 0)
var 0..1: make_robot;
var 0..1: make_car;
var 0..1: make_block;
var 0..1: make_doll;

% Link indicators to quantities (exact equivalence)
constraint robot > 0 <-> make_robot = 1;
constraint car   > 0 <-> make_car   = 1;
constraint block > 0 <-> make_block = 1;
constraint doll  > 0 <-> make_doll  = 1;

% Resource constraints
constraint plast_robot * robot + plast_car * car + plast_block * block + plast_doll * doll <= plastic_avail;
constraint elec_robot  * robot + elec_car  * car + elec_block  * block + elec_doll  * doll <= elec_avail;

% Logical/business rules
% If robots are manufactured, dolls are not manufactured
constraint make_robot + make_doll <= 1;

% If model cars are manufactured, building blocks are also manufactured
constraint make_car <= make_block;

% Dolls manufactured cannot exceed model cars manufactured
constraint doll <= car;

% Objective: maximize total profit
var int: profit = p_robot*robot + p_car*car + p_block*block + p_doll*doll;
solve maximize profit;

output [
  "Profit = ", show(profit), "\n",
  "Quantities:\n",
  "  robots = ", show(robot), "\n",
  "  cars   = ", show(car), "\n",
  "  blocks = ", show(block), "\n",
  "  dolls  = ", show(doll), "\n",
  "Manufactured types:\n",
  "  make_robot = ", show(make_robot), "\n",
  "  make_car   = ", show(make_car), "\n",
  "  make_block = ", show(make_block), "\n",
  "  make_doll  = ", show(make_doll), "\n"
];