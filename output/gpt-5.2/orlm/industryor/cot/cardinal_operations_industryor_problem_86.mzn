% Parameters (with values embedded)
int: ref_demand = 3000;
int: nonref_demand = 4000;

int: costA = 30;      % £ per km
int: costB = 40;      % £ per km

int: refCapA = 20;
int: nonrefCapA = 40;

int: totalCapB = refCapA + nonrefCapA; % same total capacity as Type A (60)
int: refCapB = totalCapB div 2;        % equal split
int: nonrefCapB = totalCapB div 2;

% Simple upper bounds: enough trucks to cover each demand with the smallest relevant capacity
int: maxA = max( (ref_demand + refCapA - 1) div refCapA,
                 (nonref_demand + nonrefCapA - 1) div nonrefCapA );
int: maxB = max( (ref_demand + refCapB - 1) div refCapB,
                 (nonref_demand + nonrefCapB - 1) div nonrefCapB );

% Variables
var 0..maxA: nA;  % number of Type A trucks
var 0..maxB: nB;  % number of Type B trucks

% Constraints
constraint nA * refCapA + nB * refCapB >= ref_demand;
constraint nA * nonrefCapA + nB * nonrefCapB >= nonref_demand;

% Objective
solve minimize costA * nA + costB * nB;