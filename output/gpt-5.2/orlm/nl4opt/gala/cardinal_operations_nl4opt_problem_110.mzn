% Clinic vaccination optimization (all data embedded)

int: time_limit = 10000;     % minutes available
int: pill_time  = 10;        % minutes per pill vaccine
int: shot_time  = 20;        % minutes per shot vaccine
int: min_pills  = 30;        % must administer at least this many pills
int: shot_ratio = 3;         % shots >= 3 * pills

% Decision variables
var 0..time_limit div pill_time: pills;
var 0..time_limit div shot_time: shots;

% Constraints
constraint pill_time * pills + shot_time * shots <= time_limit;
constraint shots >= shot_ratio * pills;
constraint pills >= min_pills;

% Objective: maximize total patients vaccinated
var 0..(time_limit div pill_time + time_limit div shot_time): total;
constraint total = pills + shots;

solve maximize total;

output [
  "pills = ", show(pills), "\n",
  "shots = ", show(shots), "\n",
  "total = ", show(total), "\n",
  "time_used = ", show(pill_time*pills + shot_time*shots), " / ", show(time_limit), "\n"
];