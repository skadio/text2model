% Parameters
% Resource coefficients and bounds (embedded as per instruction)
int: trainRatio1 = 3;          % for every 3 hours of training
int: equipRatio1 = 2;          % at least 2 units of equipment cost
int: minCombined1 = 15;        % combined value should be at least 15

int: trainRatio2 = 4;          % for every 4 hours of training
int: equipRatio2 = 3;          % can't be more than 3 units of equipment cost
int: maxCombined2 = 50;        % combined value should not exceed 50

int: fatigueTrain = 6;         % fatigue per training hour
int: fatigueEquip = 4;         % fatigue per equipment unit

% Safe explicit upper bounds derived from constraints (with nonnegativity):
% 4*training + 3*equipment <= 50 implies training <= floor(50/4)=12, equipment <= floor(50/3)=16
int: maxTraining = maxCombined2 div trainRatio2; % 12
int: maxEquip = maxCombined2 div equipRatio2;    % 16

% Variables
var 0..maxTraining: trainingHours;  % integer training hours
var 0..maxEquip: equipmentCost;     % integer equipment cost units

% Total fatigue score (bounded using maxTraining/maxEquip)
var 0..(fatigueTrain * maxTraining + fatigueEquip * maxEquip): totalFatigue;

% Constraints

% Minimum combined resource requirement:
% 3*training + 2*equipment >= 15
constraint
  trainRatio1 * trainingHours + equipRatio1 * equipmentCost >= minCombined1;

% Maximum combined resource cap:
% 4*training + 3*equipment <= 50
constraint
  trainRatio2 * trainingHours + equipRatio2 * equipmentCost <= maxCombined2;

% Define total fatigue from training and equipment contributions:
constraint
  totalFatigue = fatigueTrain * trainingHours + fatigueEquip * equipmentCost;

% Objective
solve minimize totalFatigue;