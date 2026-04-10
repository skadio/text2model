% Parameters
int: hours_needed = 300;
int: budget = 6500;

int: hours_seasonal = 6;
int: pay_seasonal = 120;

int: hours_permanent = 10;
int: pay_permanent = 250;

% Variables
var 0..ceil(hours_needed div hours_seasonal + 1): seasonal;
var 0..ceil(hours_needed div hours_permanent + 1): permanent;

var 0..1000: total_workers;

% Constraints
constraint hours_seasonal * seasonal + hours_permanent * permanent >= hours_needed;
constraint pay_seasonal * seasonal + pay_permanent * permanent <= budget;

constraint total_workers = seasonal + permanent;

% Objective
solve minimize total_workers;