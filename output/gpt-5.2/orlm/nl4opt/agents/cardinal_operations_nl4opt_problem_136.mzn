% Parameters
int: gifts_per_seasonal = 5;          % gifts delivered by one seasonal volunteer
int: gifts_per_fulltime = 8;          % gifts delivered by one full-time volunteer
int: points_per_seasonal = 2;         % points consumed by one seasonal volunteer
int: points_per_fulltime = 5;         % points consumed by one full-time volunteer

int: total_points_available = 200;    % maximum total points available
float: max_seasonal_fraction = 0.30;  % at most 30% of volunteers can be seasonal (embedded, but we enforce via integer inequality)
int: min_fulltime = 10;               % at least 10 full-time volunteers required

% Helpful derived bounds (safe upper bounds)
int: max_seasonal_by_points = total_points_available div points_per_seasonal;
int: max_fulltime_by_points = total_points_available div points_per_fulltime;

% Variables
var 0..max_seasonal_by_points: seasonal_volunteers;                 % number of seasonal volunteers
var min_fulltime..max_fulltime_by_points: fulltime_volunteers;     % number of full-time volunteers

var 0..(gifts_per_seasonal * max_seasonal_by_points
        + gifts_per_fulltime * max_fulltime_by_points): total_gifts; % total gifts delivered

var 0..total_points_available: total_points_used;                  % total points consumed

% Constraints

% Compute total points used from volunteer counts
constraint
  total_points_used =
    points_per_seasonal * seasonal_volunteers +
    points_per_fulltime * fulltime_volunteers;

% Respect the total points budget
constraint
  total_points_used <= total_points_available;

% Compute total gifts delivered from volunteer counts
constraint
  total_gifts =
    gifts_per_seasonal * seasonal_volunteers +
    gifts_per_fulltime * fulltime_volunteers;

% Seasonal volunteer fraction constraint: seasonal <= 30% of total volunteers
% Avoid floats by cross-multiplying: seasonal <= 0.30*(seasonal + fulltime)
constraint
  10 * seasonal_volunteers <= 3 * (seasonal_volunteers + fulltime_volunteers);

% Minimum number of full-time volunteers (also enforced by variable domain)
constraint
  fulltime_volunteers >= min_fulltime;

% Objective
solve maximize total_gifts;