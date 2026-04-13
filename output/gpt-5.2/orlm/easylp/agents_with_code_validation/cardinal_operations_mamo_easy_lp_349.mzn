% Parameters
% Unit costs for resources in each department
int: costX = 30; % General Medicine (X)
int: costY = 20; % Surgery (Y)
int: costZ = 40; % Pediatrics (Z)
int: costW = 50; % Geriatrics (W)

% Constraint thresholds
int: minXY = 100;    % X + Y >= 100
int: maxZW = 200;    % Z + W <= 200
int: minXZ = 150;    % X + Z >= 150
int: maxDiffYW = 50; % |Y - W| <= 50

% Simple upper bounds to keep the model bounded (derived from given constraints)
int: ubX = 350;
int: ubY = 450;
int: ubZ = 200;
int: ubW = 200;

% Variables
var 0..ubX: x; % resources in General Medicine
var 0..ubY: y; % resources in Surgery
var 0..ubZ: z; % resources in Pediatrics
var 0..ubW: w; % resources in Geriatrics

% Total cost (bounded integer)
var 0..(costX*ubX + costY*ubY + costZ*ubZ + costW*ubW): total_cost;

% Constraints
% Total cost definition (integer linear expression)
constraint
  total_cost = costX * x + costY * y + costZ * z + costW * w;

% Minimum combined resources for General Medicine and Surgery
constraint
  x + y >= minXY;

% Maximum combined resources for Pediatrics and Geriatrics
constraint
  z + w <= maxZW;

% Minimum combined resources for General Medicine and Pediatrics
constraint
  x + z >= minXZ;

% Limit the absolute difference between Surgery and Geriatrics allocations
constraint
  abs(y - w) <= maxDiffYW;

% Objective
solve minimize total_cost;