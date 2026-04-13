% Parameters (with values embedded)
int: gifts_seasonal = 5;
int: points_seasonal = 2;
int: gifts_fulltime = 8;
int: points_fulltime = 5;

int: max_points = 200;
int: min_fulltime = 10;

% Variables
var 0..1000: seasonal;
var 0..1000: fulltime;
var 0..100000: total_gifts;

% Constraints
constraint points_seasonal * seasonal + points_fulltime * fulltime <= max_points;
constraint fulltime >= min_fulltime;

% Maximum 30% seasonal: seasonal / (seasonal + fulltime) <= 0.30
% Equivalent linear form: 10*seasonal <= 3*(seasonal + fulltime)  -> 7*seasonal <= 3*fulltime
constraint 7 * seasonal <= 3 * fulltime;

constraint total_gifts = gifts_seasonal * seasonal + gifts_fulltime * fulltime;

% Objective
solve maximize total_gifts;