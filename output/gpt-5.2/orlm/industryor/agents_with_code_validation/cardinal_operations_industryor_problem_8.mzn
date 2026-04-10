% Parameters
% Profit per unit
int: profit_truck = 5;
int: profit_airplane = 10;
int: profit_boat = 8;
int: profit_train = 7;

% Resource availability
int: wood_available = 890;
int: steel_available = 500;

% Resource usage per unit
int: wood_truck = 12;
int: wood_airplane = 20;
int: wood_boat = 15;
int: wood_train = 10;

int: steel_truck = 6;
int: steel_airplane = 3;
int: steel_boat = 5;
int: steel_train = 4;

% Simple upper bounds from resource limits (tight, integer)
int: max_truck = min(wood_available div wood_truck, steel_available div steel_truck);
int: max_airplane = min(wood_available div wood_airplane, steel_available div steel_airplane);
int: max_boat = min(wood_available div wood_boat, steel_available div steel_boat);
int: max_train = min(wood_available div wood_train, steel_available div steel_train);

% Variables
% Production quantities (nonnegative integers)
var 0..max_truck: n_truck;
var 0..max_airplane: n_airplane;
var 0..max_boat: n_boat;
var 0..max_train: n_train;

% Binary "manufacture this type" indicators
var bool: make_truck;
var bool: make_airplane;
var bool: make_boat;
var bool: make_train;

% Constraints

% Link production quantities to "make" indicators:
% if make_* = false then quantity = 0; if true then quantity >= 1
constraint
  n_truck <= max_truck * bool2int(make_truck) /\
  n_airplane <= max_airplane * bool2int(make_airplane) /\
  n_boat <= max_boat * bool2int(make_boat) /\
  n_train <= max_train * bool2int(make_train);

constraint
  n_truck >= bool2int(make_truck) /\
  n_airplane >= bool2int(make_airplane) /\
  n_boat >= bool2int(make_boat) /\
  n_train >= bool2int(make_train);

% Resource capacity constraints (wood and steel)
constraint
  wood_truck * n_truck +
  wood_airplane * n_airplane +
  wood_boat * n_boat +
  wood_train * n_train
  <= wood_available;

constraint
  steel_truck * n_truck +
  steel_airplane * n_airplane +
  steel_boat * n_boat +
  steel_train * n_train
  <= steel_available;

% Logical production rules between toy types
% If trucks are manufactured, trains are not manufactured
constraint make_truck -> not make_train;

% If boats are manufactured, airplanes are also manufactured
constraint make_boat -> make_airplane;

% Quantity relationship: number of boats cannot exceed number of trains
constraint n_boat <= n_train;

% Objective
solve maximize
  profit_truck * n_truck +
  profit_airplane * n_airplane +
  profit_boat * n_boat +
  profit_train * n_train;