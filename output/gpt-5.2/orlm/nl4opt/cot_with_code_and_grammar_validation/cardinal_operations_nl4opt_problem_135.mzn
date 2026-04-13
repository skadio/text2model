% Parameters
int: hours_needed = 300;
int: budget = 6500;

int: hours_seasonal = 6;
int: pay_seasonal = 120;

int: hours_permanent = 10;
int: pay_permanent = 250;

int: max_seasonal = budget div pay_seasonal;
int: max_permanent = budget div pay_permanent;

% Variables
var 0..max_seasonal: seasonal;
var 0..max_permanent: permanent;

var 0..(max_seasonal + max_permanent): total_workers;

% Constraints
constraint total_workers = seasonal + permanent;

constraint hours_seasonal * seasonal + hours_permanent * permanent >= hours_needed;

constraint pay_seasonal * seasonal + pay_permanent * permanent <= budget;

% Objective
solve minimize total_workers;