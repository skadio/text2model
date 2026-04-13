include "globals.mzn";

% Data (embedded from problem statement)
int: gifts_seasonal = 5;
int: points_seasonal = 2;

int: gifts_fulltime = 8;
int: points_fulltime = 5;

int: point_budget = 200;
int: min_fulltime = 10;

% Variables
var 0..point_budget div points_seasonal: seasonal;
var 0..point_budget div points_fulltime: fulltime;

% Constraints
constraint points_seasonal * seasonal + points_fulltime * fulltime <= point_budget;
constraint fulltime >= min_fulltime;

% At most 30% seasonal: seasonal <= 0.3*(seasonal+fulltime)
% Implemented without fractions: 10*seasonal <= 3*(seasonal+fulltime) -> 7*seasonal <= 3*fulltime
constraint 7 * seasonal <= 3 * fulltime;

% Objective: maximize total gifts
var int: total_gifts = gifts_seasonal * seasonal + gifts_fulltime * fulltime;

solve maximize total_gifts;

output [
  "seasonal = ", show(seasonal), "\n",
  "fulltime = ", show(fulltime), "\n",
  "total_points = ", show(points_seasonal * seasonal + points_fulltime * fulltime), " / ", show(point_budget), "\n",
  "total_gifts = ", show(total_gifts), "\n"
];