% Parameters (with values embedded)
int: reqA = 240;   % pieces of raw material A
int: reqB = 80;    % kg of raw material B
int: reqC = 120;   % tons of raw material C

int: capA_A = 4;   int: capA_B = 2;   int: capA_C = 6;
int: capB_A = 7;   int: capB_B = 2;   int: capB_C = 2;

int: costA = 200;  % yuan per truck from warehouse A
int: costB = 160;  % yuan per truck from warehouse B

% Upper bounds (safe bounds derived from requirements and capacities)
int: maxXA = max(0, max( (reqA + capA_A - 1) div capA_A,
                         max( (reqB + capA_B - 1) div capA_B,
                              (reqC + capA_C - 1) div capA_C )));
int: maxXB = max(0, max( (reqA + capB_A - 1) div capB_A,
                         max( (reqB + capB_B - 1) div capB_B,
                              (reqC + capB_C - 1) div capB_C )));

% Variables
var 0..maxXA: xA;  % trucks dispatched from warehouse A
var 0..maxXB: xB;  % trucks dispatched from warehouse B

% Constraints
constraint capA_A * xA + capB_A * xB >= reqA;
constraint capA_B * xA + capB_B * xB >= reqB;
constraint capA_C * xA + capB_C * xB >= reqC;

% Objective
solve minimize costA * xA + costB * xB;