% Parameters
int: luggage_req = 1000;
int: pollutant_max = 430;

int: cap4 = 60;
int: pol4 = 30;

int: cap3 = 40;
int: pol3 = 15;

% Variables
var 0..ceil(luggage_req div cap4 + 1): x4; % number of 4-wheelers
var 0..ceil(luggage_req div cap3 + 1): x3; % number of 3-wheelers

var 0..(ceil(luggage_req div min(cap4,cap3)) + 10): totalVehicles;

% Constraints
constraint cap4 * x4 + cap3 * x3 >= luggage_req;
constraint pol4 * x4 + pol3 * x3 <= pollutant_max;

constraint totalVehicles = x4 + x3;

% Objective
solve minimize totalVehicles;