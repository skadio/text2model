% Parameters
int: mint_avail = 120;                 % Total available mint units
int: active_avail = 100;               % Total available active ingredient units
int: tar_max = 50;                     % Maximum allowed black tar production

int: demo1_mint = 10;                  % Mint used per unit of demonstration 1
int: demo1_active = 20;                % Active ingredient used per unit of demonstration 1
int: demo1_foam = 25;                  % Minty foam produced per unit of demonstration 1
int: demo1_tar = 5;                    % Black tar produced per unit of demonstration 1

int: demo2_mint = 12;                  % Mint used per unit of demonstration 2
int: demo2_active = 15;                % Active ingredient used per unit of demonstration 2
int: demo2_foam = 18;                  % Minty foam produced per unit of demonstration 2
int: demo2_tar = 3;                    % Black tar produced per unit of demonstration 2

% Upper bounds from resource limits (safe integer bounds)
int: demo1_ub = min(mint_avail div demo1_mint, active_avail div demo1_active);
int: demo2_ub = min(mint_avail div demo2_mint, active_avail div demo2_active);

% Variables
var 0..demo1_ub: demo1_count;          % Number of times to perform demonstration 1
var 0..demo2_ub: demo2_count;          % Number of times to perform demonstration 2

var 0..(demo1_foam*demo1_ub + demo2_foam*demo2_ub): total_foam; % Total minty foam produced

% Constraints

% Link total foam to the chosen number of demonstrations
constraint total_foam =
  demo1_foam * demo1_count + demo2_foam * demo2_count;

% Mint availability constraint
constraint demo1_mint * demo1_count + demo2_mint * demo2_count <= mint_avail;

% Active ingredient availability constraint
constraint demo1_active * demo1_count + demo2_active * demo2_count <= active_avail;

% Black tar production limit constraint
constraint demo1_tar * demo1_count + demo2_tar * demo2_count <= tar_max;

% Objective
solve maximize total_foam;