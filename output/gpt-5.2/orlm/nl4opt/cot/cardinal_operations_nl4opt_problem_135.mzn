% Parameters (with values embedded)
int: hours_required = 300;
int: budget = 6500;

int: hours_seasonal = 6;
int: cost_seasonal = 120;

int: hours_permanent = 10;
int: cost_permanent = 250;

% Variables
var 0..ceil(int2float(budget) / int2float(cost_seasonal)): seasonal;
var 0..ceil(int2float(budget) / int2float(cost_permanent)): permanent;
var 0..(ceil(int2float(budget) / int2float(cost_seasonal)) + ceil(int2float(budget) / int2float(cost_permanent))): total_workers;

% Constraints
constraint total_workers = seasonal + permanent;

constraint hours_seasonal * seasonal + hours_permanent * permanent >= hours_required;
constraint cost_seasonal * seasonal + cost_permanent * permanent <= budget;

% Objective
solve minimize total_workers;