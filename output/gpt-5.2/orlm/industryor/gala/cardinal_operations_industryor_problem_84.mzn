% Production planning LP (solved as a MILP via scaling to minutes)
% Data is embedded as requested.

include "globals.mzn";

%----------------------------
% Data
%----------------------------
int: machineAvailHours = 40;
int: craftAvailHours   = 35;

int: machineCostPerHour = 10;   % £/hour
int: craftCostPerHour   = 2;    % £/hour

int: revX = 20;                % £ per batch
int: revY = 30;                % £ per batch

int: machineMinX = 13;         % minutes per batch
int: craftMinX   = 20;
int: machineMinY = 19;
int: craftMinY   = 29;

int: minX = 10;                % contract requirement (batches of X)

% Capacities in minutes
int: machineAvailMin = machineAvailHours * 60;
int: craftAvailMin   = craftAvailHours * 60;

% Convert per-hour costs to per-minute, keeping exactness:
% machine: 10/60 = 1/6 £ per minute
% craft:   2/60  = 1/30 £ per minute
%
% To avoid fractions, maximize profit * 30 (LCM of 6 and 30):
% scaledProfit = 30*revenue - 5*(machine minutes used) - 1*(craft minutes used)

% Decision variables: allow fractional batches. We scale batches by 60 to represent 1/60 batch units.
int: B = 60;  % scale factor for batches

% Upper bounds based on capacities (safe, not necessarily tight)
int: maxXB = (machineAvailMin * B) div machineMinX; % from machine constraint alone
int: maxYB = (machineAvailMin * B) div machineMinY;

var 0..maxXB: xB;   % xB = X batches * 60
var 0..maxYB: yB;   % yB = Y batches * 60

%----------------------------
% Constraints (resource limits)
%----------------------------
% Machine time: 13*X + 19*Y <= 2400 (minutes)
% Multiply by B to keep integer:
constraint machineMinX * xB + machineMinY * yB <= machineAvailMin * B;

% Craftsman time: 20*X + 29*Y <= 2100 (minutes)
constraint craftMinX * xB + craftMinY * yB <= craftAvailMin * B;

% Contract: X >= 10 batches
constraint xB >= minX * B;

%----------------------------
% Objective: maximize profit
%----------------------------
% Let machine minutes used = (13*xB + 19*yB)/B
% Let craft minutes used   = (20*xB + 29*yB)/B
% scaledProfit = 30*(revX*X + revY*Y) - 5*machMinUsed - 1*craftMinUsed
% Multiply by B to avoid division:
var int: scaledProfitB =
    (30 * revX) * xB + (30 * revY) * yB
  - 5 * (machineMinX * xB + machineMinY * yB)
  - 1 * (craftMinX   * xB + craftMinY   * yB);

solve maximize scaledProfitB;

%----------------------------
% Output
%----------------------------
output [
  "X batches = ", show(float(xB) / float(B)), "\n",
  "Y batches = ", show(float(yB) / float(B)), "\n",
  "Machine minutes used = ",
    show( (machineMinX * float(xB) + machineMinY * float(yB)) / float(B) ), " / ",
    show(machineAvailMin), "\n",
  "Craft minutes used = ",
    show( (craftMinX * float(xB) + craftMinY * float(yB)) / float(B) ), " / ",
    show(craftAvailMin), "\n",
  "ScaledProfit*B (units = 30*£*B) = ", show(scaledProfitB), "\n"
];