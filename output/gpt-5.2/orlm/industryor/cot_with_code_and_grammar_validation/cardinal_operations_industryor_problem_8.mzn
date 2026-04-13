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

% Upper bounds from resources (safe tight bounds)
int: UB_truck = min(wood_available div wood_truck, steel_available div steel_truck);
int: UB_airplane = min(wood_available div wood_airplane, steel_available div steel_airplane);
int: UB_boat = min(wood_available div wood_boat, steel_available div steel_boat);
int: UB_train = min(wood_available div wood_train, steel_available div steel_train);

% Variables
var 0..UB_truck: x_truck;
var 0..UB_airplane: x_airplane;
var 0..UB_boat: x_boat;
var 0..UB_train: x_train;

var bool: make_truck;
var bool: make_airplane;
var bool: make_boat;
var bool: make_train;

% Constraints
constraint wood_truck * x_truck + wood_airplane * x_airplane + wood_boat * x_boat + wood_train * x_train <= wood_available;
constraint steel_truck * x_truck + steel_airplane * x_airplane + steel_boat * x_boat + steel_train * x_train <= steel_available;

% Link "make" indicators to production quantities
constraint x_truck <= UB_truck * bool2int(make_truck);
constraint x_airplane <= UB_airplane * bool2int(make_airplane);
constraint x_boat <= UB_boat * bool2int(make_boat);
constraint x_train <= UB_train * bool2int(make_train);

% If producing any, then corresponding make_* must be true
constraint x_truck >= bool2int(make_truck);
constraint x_airplane >= bool2int(make_airplane);
constraint x_boat >= bool2int(make_boat);
constraint x_train >= bool2int(make_train);

% Logical constraints
constraint make_truck -> not make_train;
constraint make_boat -> make_airplane;

% Boats cannot exceed trains
constraint x_boat <= x_train;

% Objective
solve maximize profit_truck * x_truck + profit_airplane * x_airplane + profit_boat * x_boat + profit_train * x_train;