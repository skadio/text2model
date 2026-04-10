% Parameters
% Time (seconds) for one unit of each chemical to be effective
int: timeA = 30;
int: timeB = 45;

% Safety/ratio constraint: A <= (1/3) * B  <=>  3*A <= B
int: ratioA_mult = 3;
int: ratioB_mult = 1;

% Minimum required amounts
int: minA = 300;          % at least 300 units of A
int: minTotal = 1500;     % at least 1500 units total (A + B)

% Upper bounds (derived to keep variables bounded for a minimization model)
int: maxA = 500;
int: maxB = 2000;


% Variables
var minA..maxA: unitsA;    % units of chemical A to add
var 0..maxB: unitsB;       % units of chemical B to add

var 0..int_max: totalTime; % total effective time (objective, in seconds)


% Constraints

% --- Safety ratio constraint (dangerous chemical A) ---
% Enforce: A <= (1/3) * B  <=>  3*A <= B
constraint ratioA_mult * unitsA <= ratioB_mult * unitsB;

% --- Minimum total chemicals requirement ---
% Enforce: A + B >= minimum total units
constraint unitsA + unitsB >= minTotal;

% --- Total time calculation (linking variable) ---
% Total effective time in seconds: 30*A + 45*B
constraint totalTime = timeA * unitsA + timeB * unitsB;


% Objective
solve minimize totalTime;