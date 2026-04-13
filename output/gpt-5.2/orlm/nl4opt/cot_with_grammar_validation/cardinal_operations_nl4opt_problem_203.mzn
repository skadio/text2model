% Parameters
int: labrador_newspapers = 7;
int: labrador_treats = 5;

int: golden_newspapers = 10;
int: golden_treats = 6;

int: total_treats = 1500;
int: min_golden = 50;
float: max_labrador_fraction = 0.6;

% Variables
var 0..(total_treats div labrador_treats): L; % number of labradors
var min_golden..(total_treats div golden_treats): G; % number of golden retrievers

% Constraints
constraint labrador_treats * L + golden_treats * G <= total_treats;

% At most 60% of the dogs can be labradors: L <= 0.6*(L+G)
% Use integer form to avoid floats: 5*L <= 3*G
constraint 5 * L <= 3 * G;

% Objective
solve maximize labrador_newspapers * L + golden_newspapers * G;