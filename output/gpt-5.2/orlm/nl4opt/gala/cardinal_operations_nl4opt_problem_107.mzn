% Berry farm operating plan (LP formulated as an integer/linear MiniZinc model)
% Minimize cost while meeting minimum delivery requirements.

% --- Data (embedded from problem statement) ---
int: reqR = 10;   % kg raspberries required
int: reqB = 9;    % kg blueberries required
int: reqS = 15;   % kg strawberries required

int: costOld = 300;  % $/day
int: costNew = 200;  % $/day

int: oldR = 2; int: oldB = 2; int: oldS = 4;  % kg/day from old farm
int: newR = 4; int: newB = 1; int: newS = 2;  % kg/day from new farm

% --- Decision variables ---
% Days of operation at each farm (integer days).
var 0..100: dOld;
var 0..100: dNew;

% --- Constraints: meet contract (at least required kg) ---
constraint oldR * dOld + newR * dNew >= reqR;
constraint oldB * dOld + newB * dNew >= reqB;
constraint oldS * dOld + newS * dNew >= reqS;

% --- Objective: minimize total cost ---
var int: totalCost = costOld * dOld + costNew * dNew;
solve minimize totalCost;

% --- Output ---
output [
  "Days old farm = ", show(dOld), "\n",
  "Days new farm = ", show(dNew), "\n",
  "Total cost = $", show(totalCost), "\n",
  "Delivered (R,B,S) = (",
    show(oldR*dOld + newR*dNew), ", ",
    show(oldB*dOld + newB*dNew), ", ",
    show(oldS*dOld + newS*dNew), ")\n"
];