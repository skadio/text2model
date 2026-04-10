% Parameters
int: plastic_available = 1200;
int: electronics_available = 800;

int: profit_robot = 15;
int: profit_car = 8;
int: profit_blocks = 12;
int: profit_doll = 5;

int: plastic_robot = 30;
int: plastic_car = 10;
int: plastic_blocks = 20;
int: plastic_doll = 15;

int: elec_robot = 8;
int: elec_car = 5;
int: elec_blocks = 3;
int: elec_doll = 2;

% Variable bounds (upper bounds from plastic availability; safe integer bounds)
int: ub_robot = plastic_available div plastic_robot;
int: ub_car = plastic_available div plastic_car;
int: ub_blocks = plastic_available div plastic_blocks;
int: ub_doll = plastic_available div plastic_doll;

% Variables
var 0..ub_robot: robots;
var 0..ub_car: cars;
var 0..ub_blocks: blocks;
var 0..ub_doll: dolls;

var bool: make_robots;
var bool: make_cars;
var bool: make_blocks;
var bool: make_dolls;

var 0..(profit_robot*ub_robot + profit_car*ub_car + profit_blocks*ub_blocks + profit_doll*ub_doll): total_profit;

% Constraints
constraint
  plastic_robot * robots + plastic_car * cars + plastic_blocks * blocks + plastic_doll * dolls
  <= plastic_available;

constraint
  elec_robot * robots + elec_car * cars + elec_blocks * blocks + elec_doll * dolls
  <= electronics_available;

% Link production to "make" flags
constraint robots > 0 <-> make_robots;
constraint cars > 0 <-> make_cars;
constraint blocks > 0 <-> make_blocks;
constraint dolls > 0 <-> make_dolls;

% Logical/implication constraints
constraint make_robots -> not make_dolls;        % If robots are manufactured, no dolls
constraint make_cars -> make_blocks;             % If cars are manufactured, also blocks

% Dolls cannot exceed cars
constraint dolls <= cars;

% Define profit
constraint total_profit =
  profit_robot * robots + profit_car * cars + profit_blocks * blocks + profit_doll * dolls;

% Objective
solve maximize total_profit;