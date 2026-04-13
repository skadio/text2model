% Parameters
int: cap4 = 60;
int: cap3 = 40;
int: pol4 = 30;
int: pol3 = 15;
int: min_luggage = 1000;
int: max_pollution = 430;

% Variables
var 0..ceil(min_luggage div cap4) + ceil(min_luggage div cap3): x4; % number of 4-wheelers
var 0..ceil(min_luggage div cap4) + ceil(min_luggage div cap3): x3; % number of 3-wheelers

% Constraints
constraint cap4 * x4 + cap3 * x3 >= min_luggage;
constraint pol4 * x4 + pol3 * x3 <= max_pollution;

% Objective
solve minimize x4 + x3;