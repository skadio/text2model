% Parameters
int: timeA_mw = 2;
int: timeB_mw = 1;
int: timeA_wh = 1;
int: timeB_wh = 3;

int: cost_inspect_mw = 30;
int: cost_inspect_wh = 50;
int: max_inspect_cost = 5500;

int: availA = 250;
int: availB = 150;
int: max_overtimeA = 20;

int: min_mw = 80;
int: min_wh = 50;

% Variables
var int: mw;          % number of microwave ovens
var int: wh;          % number of water heaters
var 0..max_overtimeA: overtimeA;

% Constraints
constraint mw >= 0;
constraint wh >= 0;

% inspection and sales cost limit
constraint cost_inspect_mw * mw + cost_inspect_wh * wh <= max_inspect_cost;

% minimum sales requirements
constraint mw >= min_mw;
constraint wh >= min_wh;

% fully utilize workshop B time (no overtime specified for B)
constraint timeB_mw * mw + timeB_wh * wh = availB;

% fully utilize workshop A time, allowing limited overtime
constraint timeA_mw * mw + timeA_wh * wh = availA + overtimeA;

% Objective
solve satisfy;