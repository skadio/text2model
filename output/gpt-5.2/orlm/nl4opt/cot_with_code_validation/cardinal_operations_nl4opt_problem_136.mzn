% Parameters
int: seasonal_gifts = 5;
int: seasonal_points = 2;

int: fulltime_gifts = 8;
int: fulltime_points = 5;

int: max_points = 200;

int: min_fulltime = 10;
int: seasonal_pct_max_num = 30;
int: seasonal_pct_max_den = 100;

% Variables
var 0..max_points div seasonal_points: seasonal;
var min_fulltime..max_points div fulltime_points: fulltime;

var 0..(seasonal_gifts * (max_points div seasonal_points) + fulltime_gifts * (max_points div fulltime_points)): total_gifts;

% Constraints
constraint seasonal_points * seasonal + fulltime_points * fulltime <= max_points;

% seasonal <= 30% of total volunteers: seasonal <= 0.30*(seasonal+fulltime)
% Use integer arithmetic to avoid floats:
constraint seasonal_pct_max_den * seasonal <= seasonal_pct_max_num * (seasonal + fulltime);

constraint total_gifts = seasonal_gifts * seasonal + fulltime_gifts * fulltime;

% Objective
solve maximize total_gifts;