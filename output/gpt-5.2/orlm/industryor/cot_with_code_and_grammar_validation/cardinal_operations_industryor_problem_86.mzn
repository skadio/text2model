% Parameters
int: req_refrig = 3000;
int: req_nonrefrig = 4000;

int: capA_refrig = 20;
int: capA_nonrefrig = 40;

int: capB_refrig = 30;
int: capB_nonrefrig = 30;

int: costA = 30;
int: costB = 40;

% Upper bounds (safe tight-ish bounds from requirements)
int: maxA = max( (req_refrig + capA_refrig - 1) div capA_refrig,
                 (req_nonrefrig + capA_nonrefrig - 1) div capA_nonrefrig );
int: maxB = max( (req_refrig + capB_refrig - 1) div capB_refrig,
                 (req_nonrefrig + capB_nonrefrig - 1) div capB_nonrefrig );

% Variables
var 0..maxA: nA;
var 0..maxB: nB;

var 0..(costA*maxA + costB*maxB): total_cost;

% Constraints
constraint capA_refrig * nA + capB_refrig * nB >= req_refrig;
constraint capA_nonrefrig * nA + capB_nonrefrig * nB >= req_nonrefrig;

constraint total_cost = costA*nA + costB*nB;

% Objective
solve minimize total_cost;