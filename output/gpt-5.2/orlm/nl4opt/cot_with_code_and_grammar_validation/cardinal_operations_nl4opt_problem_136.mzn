% Parameters
int: gifts_seasonal = 5;
int: points_seasonal = 2;

int: gifts_fulltime = 8;
int: points_fulltime = 5;

int: points_budget = 200;

int: min_fulltime = 10;
int: seasonal_pct_max_num = 3;   % seasonal <= 0.30 * total  <=> 10*seasonal <= 3*total
int: seasonal_pct_max_den = 10;

% Variables
var 0..points_budget div points_seasonal: seasonal;
var min_fulltime..points_budget div points_fulltime: fulltime;
var 0..(points_budget div points_seasonal + points_budget div points_fulltime): total_volunteers;
var 0..(gifts_seasonal*(points_budget div points_seasonal) + gifts_fulltime*(points_budget div points_fulltime)): total_gifts;

% Constraints
constraint total_volunteers = seasonal + fulltime;

constraint points_seasonal * seasonal + points_fulltime * fulltime <= points_budget;

% At most 30% seasonal: seasonal <= 0.30*(seasonal+fulltime)  <=> 10*seasonal <= 3*(seasonal+fulltime)
constraint seasonal_pct_max_den * seasonal <= seasonal_pct_max_num * total_volunteers;

constraint total_gifts = gifts_seasonal * seasonal + gifts_fulltime * fulltime;

% Objective
solve maximize total_gifts;