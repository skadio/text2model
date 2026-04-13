% Parameters
int: profit_truck = 5;
int: profit_airplane = 10;
int: profit_boat = 8;
int: profit_train = 7;

int: wood_available = 890;
int: steel_available = 500;

int: wood_truck = 12;
int: wood_airplane = 20;
int: wood_boat = 15;
int: wood_train = 10;

int: steel_truck = 6;
int: steel_airplane = 3;
int: steel_boat = 5;
int: steel_train = 4;

int: max_truck = min(wood_available div wood_truck, steel_available div steel_truck);
int: max_airplane = min(wood_available div wood_airplane, steel_available div steel_airplane);
int: max_boat = min(wood_available div wood_boat, steel_available div steel_boat);
int: max_train = min(wood_available div wood_train, steel_available div steel_train);

% Variables
var 0..max_truck: x_truck;
var 0..max_airplane: x_airplane;
var 0..max_boat: x_boat;
var 0..max_train: x_train;

var bool: make_truck;
var bool: make_airplane;
var bool: make_boat;
var bool: make_train;

var 0..4: num_types;

var int: total_profit;

% Constraints
constraint
  wood_truck*x_truck + wood_airplane*x_airplane + wood_boat*x_boat + wood_train*x_train <= wood_available;

constraint
  steel_truck*x_truck + steel_airplane*x_airplane + steel_boat*x_boat + steel_train*x_train <= steel_available;

% Link "make_*" to production quantities
constraint x_truck > 0 <-> make_truck;
constraint x_airplane > 0 <-> make_airplane;
constraint x_boat > 0 <-> make_boat;
constraint x_train > 0 <-> make_train;

% Logical constraints
constraint not (make_truck /\ make_train);      % if trucks then not trains (equivalently: not both)
constraint make_boat -> make_airplane;          % if boats then airplanes

% Production relation
constraint x_boat <= x_train;

% Count number of types manufactured
constraint num_types = bool2int(make_truck) + bool2int(make_airplane) + bool2int(make_boat) + bool2int(make_train);

% Profit
constraint total_profit = profit_truck*x_truck + profit_airplane*x_airplane + profit_boat*x_boat + profit_train*x_train;

% Objective
solve maximize total_profit;