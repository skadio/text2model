% Parameters
int: profit_robot = 15;
int: profit_car = 8;
int: profit_blocks = 12;
int: profit_doll = 5;

int: plastic_available = 1200;
int: plastic_per_robot = 30;
int: plastic_per_car = 10;
int: plastic_per_blocks = 20;
int: plastic_per_doll = 15;

int: electronics_available = 800;
int: electronics_per_robot = 8;
int: electronics_per_car = 5;
int: electronics_per_blocks = 3;
int: electronics_per_doll = 2;

% Upper bounds derived from resource limits (safe integer bounds)
int: ub_robot = min(plastic_available div plastic_per_robot,
                   electronics_available div electronics_per_robot);
int: ub_car = min(plastic_available div plastic_per_car,
                 electronics_available div electronics_per_car);
int: ub_blocks = min(plastic_available div plastic_per_blocks,
                    electronics_available div electronics_per_blocks);
int: ub_doll = min(plastic_available div plastic_per_doll,
                  electronics_available div electronics_per_doll);

% Variables
var 0..ub_robot: n_robot;     % number of robots manufactured
var 0..ub_car: n_car;         % number of model cars manufactured
var 0..ub_blocks: n_blocks;   % number of building blocks sets manufactured
var 0..ub_doll: n_doll;       % number of dolls manufactured

var bool: make_robot;         % whether robots are manufactured
var bool: make_car;           % whether model cars are manufactured
var bool: make_blocks;        % whether building blocks are manufactured
var bool: make_doll;          % whether dolls are manufactured

% Constraints

%--- Resource capacity constraints (plastic and electronics) ---
constraint
  % Total plastic used by all toys cannot exceed available plastic
  plastic_per_robot * n_robot
+ plastic_per_car * n_car
+ plastic_per_blocks * n_blocks
+ plastic_per_doll * n_doll
<= plastic_available;

constraint
  % Total electronics used by all toys cannot exceed available electronics
  electronics_per_robot * n_robot
+ electronics_per_car * n_car
+ electronics_per_blocks * n_blocks
+ electronics_per_doll * n_doll
<= electronics_available;

%--- Link production quantities with "make_" indicator booleans ---
constraint
  % If make_robot is false then n_robot must be 0; if true then n_robot can be > 0
  n_robot <= ub_robot * bool2int(make_robot);

constraint
  % If make_car is false then n_car must be 0; if true then n_car can be > 0
  n_car <= ub_car * bool2int(make_car);

constraint
  % If make_blocks is false then n_blocks must be 0; if true then n_blocks can be > 0
  n_blocks <= ub_blocks * bool2int(make_blocks);

constraint
  % If make_doll is false then n_doll must be 0; if true then n_doll can be > 0
  n_doll <= ub_doll * bool2int(make_doll);

%--- Logical business rules between toy types ---
constraint
  % If robots are manufactured, dolls are not manufactured
  make_robot -> not make_doll;

constraint
  % If model cars are manufactured, building blocks are also manufactured
  make_car -> make_blocks;

%--- Relational production constraint ---
constraint
  % Number of dolls manufactured cannot exceed number of model cars manufactured
  n_doll <= n_car;

% Objective
solve maximize
  profit_robot * n_robot
+ profit_car * n_car
+ profit_blocks * n_blocks
+ profit_doll * n_doll;