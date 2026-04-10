% Parameters
int: gifts_per_seasonal = 5;          % Gifts delivered by one seasonal volunteer
int: points_per_seasonal = 2;         % Points awarded to one seasonal volunteer
int: gifts_per_fulltime = 8;          % Gifts delivered by one full-time volunteer
int: points_per_fulltime = 5;         % Points awarded to one full-time volunteer

int: points_budget = 200;             % Maximum total points available
int: min_fulltime = 10;               % Minimum number of full-time volunteers required
int: seasonal_percent_max = 30;       % Maximum percent of volunteers that can be seasonal

% Variables
var 0..points_budget div points_per_seasonal: seasonal_volunteers;  % Number of seasonal volunteers
var min_fulltime..points_budget div points_per_fulltime: fulltime_volunteers; % Number of full-time volunteers
var 0..(gifts_per_seasonal*(points_budget div points_per_seasonal)
      + gifts_per_fulltime*(points_budget div points_per_fulltime)): total_gifts; % Total gifts delivered

% Constraints
% --- Points budget constraint (cannot exceed available points) ---
constraint
  points_per_seasonal * seasonal_volunteers
+ points_per_fulltime * fulltime_volunteers
<= points_budget;

% --- Minimum full-time volunteers requirement ---
constraint
  fulltime_volunteers >= min_fulltime;

% --- Seasonal volunteers capped at seasonal_percent_max of total volunteers ---
% Use integer-safe form: 100*s <= seasonal_percent_max*(s+f)
constraint
  100 * seasonal_volunteers
<= seasonal_percent_max * (seasonal_volunteers + fulltime_volunteers);

% --- Define total gifts delivered ---
constraint
  total_gifts =
    gifts_per_seasonal * seasonal_volunteers
  + gifts_per_fulltime * fulltime_volunteers;

% Objective
solve maximize total_gifts;