% Parameters (with values embedded)
int: antibiotics_available = 35000;

int: abx_first = 30;
int: gel_first = 20;

int: abx_second = 65;
int: gel_second = 60;

int: min_second = 40;

% Variables
var 0..antibiotics_available div abx_first: x_first;   % number of first-dose vaccines
var 0..antibiotics_available div abx_second: x_second; % number of second-dose vaccines

% Constraints
constraint abx_first * x_first + abx_second * x_second <= antibiotics_available;
constraint x_first >= x_second + 1;        % more first-dose than second-dose
constraint x_second >= min_second;

% Objective
solve minimize gel_first * x_first + gel_second * x_second;