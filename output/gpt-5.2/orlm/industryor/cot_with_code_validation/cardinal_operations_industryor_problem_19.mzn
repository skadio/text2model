% Parameters
int: plastic_avail = 1200;
int: electronic_avail = 800;

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

% Variables
var 0..(plastic_avail div plastic_robot): robots;
var 0..(plastic_avail div plastic_car): cars;
var 0..(plastic_avail div plastic_blocks): blocks;
var 0..(plastic_avail div plastic_doll): dolls;

var bool: make_robots;
var bool: make_cars;
var bool: make_blocks;
var bool: make_dolls;

% Constraints
constraint
  plastic_robot * robots + plastic_car * cars + plastic_blocks * blocks + plastic_doll * dolls <= plastic_avail;

constraint
  elec_robot * robots + elec_car * cars + elec_blocks * blocks + elec_doll * dolls <= electronic_avail;

% Link production to "manufacture" decisions (if any produced => manufactured; if not manufactured => zero produced)
constraint robots >= make_robots;
constraint cars >= make_cars;
constraint blocks >= make_blocks;
constraint dolls >= make_dolls;

constraint robots <= (plastic_avail div plastic_robot) * make_robots;
constraint cars <= (plastic_avail div plastic_car) * make_cars;
constraint blocks <= (plastic_avail div plastic_blocks) * make_blocks;
constraint dolls <= (plastic_avail div plastic_doll) * make_dolls;

% If manufacture robots, do not manufacture dolls
constraint make_robots -> not make_dolls;

% If manufacture model cars, also manufacture building blocks
constraint make_cars -> make_blocks;

% Dolls manufactured cannot exceed model cars manufactured
constraint dolls <= cars;

% Objective
solve maximize profit_robot * robots + profit_car * cars + profit_blocks * blocks + profit_doll * dolls;