% Toy store volunteer planning (all data embedded)

int: gifts_seasonal = 5;
int: points_seasonal = 2;

int: gifts_fulltime = 8;
int: points_fulltime = 5;

int: points_budget = 200;

float: max_seasonal_fraction = 0.30;
int: min_fulltime = 10;

var 0..points_budget div points_seasonal: seasonal;
var min_fulltime..points_budget div points_fulltime: fulltime;

% Points budget
constraint points_seasonal * seasonal + points_fulltime * fulltime <= points_budget;

% At most 30% of volunteers can be seasonal:
% seasonal <= 0.30 * (seasonal + fulltime)
% Equivalent linear form: 0.70*seasonal <= 0.30*fulltime  -> 7*seasonal <= 3*fulltime
constraint 7 * seasonal <= 3 * fulltime;

var int: total_gifts = gifts_seasonal * seasonal + gifts_fulltime * fulltime;

solve maximize total_gifts;

output [
  "seasonal=", show(seasonal), "\n",
  "fulltime=", show(fulltime), "\n",
  "total_points=", show(points_seasonal*seasonal + points_fulltime*fulltime), "\n",
  "total_gifts=", show(total_gifts), "\n"
];