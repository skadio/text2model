% Parameters
int: mint_avail = 120;                 % Total units of mint available
int: active_avail = 100;               % Total units of active ingredient available
int: tar_max = 50;                     % Maximum units of black tar allowed

% Demonstration 1 coefficients
int: mint_per_demo1 = 10;              % Mint used per demo 1
int: active_per_demo1 = 20;            % Active ingredient used per demo 1
int: foam_per_demo1 = 25;              % Minty foam produced per demo 1
int: tar_per_demo1 = 5;                % Black tar produced per demo 1

% Demonstration 2 coefficients
int: mint_per_demo2 = 12;              % Mint used per demo 2
int: active_per_demo2 = 15;            % Active ingredient used per demo 2
int: foam_per_demo2 = 18;              % Minty foam produced per demo 2
int: tar_per_demo2 = 3;                % Black tar produced per demo 2

% Upper bounds derived from resource limits (valid integer bounds)
int: max_demo1 =
  min(mint_avail div mint_per_demo1,
  min(active_avail div active_per_demo1,
      tar_max div tar_per_demo1));     % Max possible demo 1 count

int: max_demo2 =
  min(mint_avail div mint_per_demo2,
  min(active_avail div active_per_demo2,
      tar_max div tar_per_demo2));     % Max possible demo 2 count


% Variables
var 0..max_demo1: demo1;               % Number of times to perform demonstration 1
var 0..max_demo2: demo2;               % Number of times to perform demonstration 2

var 0..(foam_per_demo1*max_demo1 + foam_per_demo2*max_demo2): total_foam; % Total minty foam produced
var 0..mint_avail: mint_used;          % Total mint used
var 0..active_avail: active_used;      % Total active ingredient used
var 0..tar_max: tar_produced;          % Total black tar produced


% Constraints
% Resource accounting: compute total usage/production from chosen demo counts
constraint mint_used = mint_per_demo1 * demo1 + mint_per_demo2 * demo2;
constraint active_used = active_per_demo1 * demo1 + active_per_demo2 * demo2;
constraint tar_produced = tar_per_demo1 * demo1 + tar_per_demo2 * demo2;
constraint total_foam = foam_per_demo1 * demo1 + foam_per_demo2 * demo2;

% Resource capacity limits: cannot exceed available supplies
constraint mint_used <= mint_avail;
constraint active_used <= active_avail;

% Byproduct limit: black tar production cap
constraint tar_produced <= tar_max;


% Objective
solve maximize total_foam;