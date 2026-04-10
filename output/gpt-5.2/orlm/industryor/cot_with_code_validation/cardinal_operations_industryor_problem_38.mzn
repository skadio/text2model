% Parameters
int: POLL_M = 40;
int: POLL_S = 70;
int: POLL_L = 100;

int: CAP_M = 10;
int: CAP_S = 20;
int: CAP_L = 50;

int: MAX_M = 8;
int: MIN_DEMAND = 300;
int: MAX_TRIPS = 20;

% Variables
var 0..MAX_M: m;                 % motorcycle trips
var 0..MAX_TRIPS: s;             % small truck trips
var 0..MAX_TRIPS: l;             % large truck trips

var 0..2: methods_used;          % number of methods used (nonzero trip types)

var 0..(POLL_M*MAX_M + POLL_S*MAX_TRIPS + POLL_L*MAX_TRIPS): total_pollution;

% Constraints
constraint m <= MAX_M;
constraint m + s + l <= MAX_TRIPS;

constraint CAP_M*m + CAP_S*s + CAP_L*l >= MIN_DEMAND;

constraint methods_used = bool2int(m > 0) + bool2int(s > 0) + bool2int(l > 0);
constraint methods_used = 2;

constraint total_pollution = POLL_M*m + POLL_S*s + POLL_L*l;

% Objective
solve minimize total_pollution;