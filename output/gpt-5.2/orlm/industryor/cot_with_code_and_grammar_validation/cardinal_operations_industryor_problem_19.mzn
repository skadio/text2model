% Parameters
int: plastic_avail = 1200;
int: electronics_avail = 800;

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

% Upper bounds from plastic availability (safe, finite bounds)
int: ub_robot = plastic_avail div plastic_robot;
int: ub_car = plastic_avail div plastic_car;
int: ub_blocks = plastic_avail div plastic_blocks;
int: ub_doll = plastic_avail div plastic_doll;

% Variables
var 0..ub_robot: robots;
var 0..ub_car: cars;
var 0..ub_blocks: blocks;
var 0..ub_doll: dolls;

var bool: make_robots;
var bool: make_cars;
var bool: make_blocks;
var bool: make_dolls;

% Constraints
constraint plastic_robot * robots + plastic_car * cars + plastic_blocks * blocks + plastic_doll * dolls <= plastic_avail;
constraint elec_robot * robots + elec_car * cars + elec_blocks * blocks + elec_doll * dolls <= electronics_avail;

% Link production quantities to "manufacture or not" decisions
constraint robots <= ub_robot * bool2int(make_robots);
constraint cars   <= ub_car * bool2int(make_cars);
constraint blocks <= ub_blocks * bool2int(make_blocks);
constraint dolls  <= ub_doll * bool2int(make_dolls);

constraint robots >= bool2int(make_robots);
constraint cars   >= bool2int(make_cars);
constraint blocks >= bool2int(make_blocks);
constraint dolls  >= bool2int(make_dolls);

% Logical relationships
constraint make_robots -> not make_dolls;
constraint make_cars -> make_blocks;

% Dolls manufactured cannot exceed cars manufactured
constraint dolls <= cars;

% Objective
solve maximize profit_robot * robots
             + profit_car * cars
             + profit_blocks * blocks
             + profit_doll * dolls;