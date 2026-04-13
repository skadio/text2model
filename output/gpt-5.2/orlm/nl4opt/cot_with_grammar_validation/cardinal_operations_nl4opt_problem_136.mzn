% Parameters
int: gifts_seasonal = 5;
int: points_seasonal = 2;

int: gifts_fulltime = 8;
int: points_fulltime = 5;

int: max_points = 200;
int: min_fulltime = 10;

int: max_seasonal_pct_num = 30;  % 30%
int: max_seasonal_pct_den = 100;

% Upper bounds from points budget
int: ub_seasonal = max_points div points_seasonal;
int: ub_fulltime = max_points div points_fulltime;

% Variables
var 0..ub_seasonal: seasonal;
var 0..ub_fulltime: fulltime;

var 0..(gifts_seasonal * ub_seasonal + gifts_fulltime * ub_fulltime): total_gifts;

% Constraints
constraint points_seasonal * seasonal + points_fulltime * fulltime <= max_points;

constraint fulltime >= min_fulltime;

% seasonal / (seasonal+fulltime) <= 0.30
% max_seasonal_pct_den * seasonal <= max_seasonal_pct_num * (seasonal + fulltime)
constraint max_seasonal_pct_den * seasonal <= max_seasonal_pct_num * (seasonal + fulltime);

constraint total_gifts = gifts_seasonal * seasonal + gifts_fulltime * fulltime;

% Objective
solve maximize total_gifts;