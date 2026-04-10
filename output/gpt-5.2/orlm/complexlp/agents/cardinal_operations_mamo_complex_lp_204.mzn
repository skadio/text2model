% Parameters
% Number of available fertilizers
int: nF = 5;
set of int: F = 1..nF;

% Chemical content (%) for each fertilizer i: (Ni, Ph, Po)
array[F] of float: Ni = [10.0,  8.0, 12.0, 10.0, 15.0];
array[F] of float: Ph = [ 8.0, 11.0,  7.0, 10.0, 10.0];
array[F] of float: Po = [12.0, 15.0, 12.0, 10.0,  6.0];

% Price per 100 pounds for each fertilizer i ($/100 lb)
array[F] of float: costPer100lb = [21.75, 23.50, 22.00, 19.50, 18.50];

% Convert to $/lb
array[F] of float: costPerLb = [costPer100lb[i] / 100.0 | i in F];

% Target composition (%)
float: targetNi = 10.0;
float: targetPh = 8.0;
float: targetPo = 12.0;

% Allowed upper tolerance above target (%)
float: tol = 0.5;

% Bounds for accepted composition (%)
float: minNi = targetNi;
float: maxNi = targetNi + tol;
float: minPh = targetPh;
float: maxPh = targetPh + tol;
float: minPo = targetPo;
float: maxPo = targetPo + tol;

% Total mix amount (lb) used as normalization
float: totalLb = 100.0;


% Variables
% Amount (lb) of each fertilizer i used in the blend
array[F] of var 0.0..totalLb: x_lb;

% Total cost of the blend ($)
var 0.0..(totalLb * max(i in F)(costPerLb[i])): totalCost;

% Cost per pound of the blend ($/lb)
var 0.0..max(i in F)(costPerLb[i]): costPerPound;


% Constraints

% --- Total amount normalization (must mix exactly totalLb pounds) ---
constraint
  sum(i in F)(x_lb[i]) = totalLb;

% --- Define total cost of the blend from chosen amounts ---
constraint
  totalCost = sum(i in F)(costPerLb[i] * x_lb[i]);

% --- Define cost per pound consistently with totalCost and totalLb ---
constraint
  totalCost = costPerPound * totalLb;

% --- Chemical composition constraints (weighted average within allowed ranges) ---
% Nitrogen (Ni) percentage bounds
constraint
  sum(i in F)(Ni[i] * x_lb[i]) >= minNi * totalLb;
constraint
  sum(i in F)(Ni[i] * x_lb[i]) <= maxNi * totalLb;

% Phosphorus (Ph) percentage bounds
constraint
  sum(i in F)(Ph[i] * x_lb[i]) >= minPh * totalLb;
constraint
  sum(i in F)(Ph[i] * x_lb[i]) <= maxPh * totalLb;

% Potash (Po) percentage bounds
constraint
  sum(i in F)(Po[i] * x_lb[i]) >= minPo * totalLb;
constraint
  sum(i in F)(Po[i] * x_lb[i]) <= maxPo * totalLb;


% Objective
solve minimize costPerPound;