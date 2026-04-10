% Parameters
int: doctor_cost = 10;
int: nurse_cost  = 20;

int: care_req = 50;          % 2*D + N >= 50
int: overwork_limit = 150;   % D + 3*N <= 150
int: doctor_more_than_nurse = 10; % D - N >= 10

int: D_lb = 0;
int: D_ub = 1000;
int: N_lb = 0;
int: N_ub = 1000;

% Variables
var D_lb..D_ub: D; % doctor hours (integer)
var N_lb..N_ub: N; % nurse hours (integer)

var 0..(doctor_cost*D_ub + nurse_cost*N_ub): total_cost;

% Constraints
constraint 2*D + N >= care_req;
constraint D + 3*N <= overwork_limit;
constraint D - N >= doctor_more_than_nurse;

constraint total_cost = doctor_cost*D + nurse_cost*N;

% Objective
solve minimize total_cost;