% Parameters
int: budget = 5000;                          % Total available budget in dollars

% Unit costs per advertisement "unit" (whole-number investments)
int: cost_tv = 200;
int: cost_radio = 150;
int: cost_online = 100;
int: cost_offline = 50;

% Spending constraints (in dollars)
int: min_diff_tv_radio = 1000;               % |TV - Radio| must be at least this
int: max_online_over_offline = 300;          % Online - Offline <= this
int: min_tv_spend = 1500;                    % Minimum spending on TV

% Channel-specific spending bounds (in dollars)
int: tv_min = 0;
int: tv_max = 2500;

int: radio_min = 0;
int: radio_max = 2000;

int: online_min = 0;
int: online_max = 1200;

int: offline_min = 800;
int: offline_max = budget;                   % No explicit upper bound; bounded by budget


% Variables
var tv_min..tv_max: spend_tv;                % Spending on TV ads (whole dollars)
var radio_min..radio_max: spend_radio;       % Spending on radio ads (whole dollars)
var online_min..online_max: spend_online;    % Spending on online ads (whole dollars)
var offline_min..offline_max: spend_offline; % Spending on offline ads (whole dollars)

var 0..budget: total_spend;                  % Total spending across channels

% Whole-number investments in advertisement units (must be integers)
var 0..(tv_max div cost_tv): units_tv;                 % TV ad units
var 0..(radio_max div cost_radio): units_radio;        % Radio ad units
var 0..(online_max div cost_online): units_online;     % Online ad units
var 0..(offline_max div cost_offline): units_offline;  % Offline ad units

% Objective: minimum total cost (total spending), rounded to nearest dollar (already int)
var 0..budget: total_cost;


% Constraints

% Link spending (in dollars) to whole-number advertisement units
constraint spend_tv      = cost_tv      * units_tv;
constraint spend_radio   = cost_radio   * units_radio;
constraint spend_online  = cost_online  * units_online;
constraint spend_offline = cost_offline * units_offline;

% Total spending and total cost definitions
constraint total_spend = spend_tv + spend_radio + spend_online + spend_offline;
constraint total_cost  = total_spend;

% Budget feasibility: cannot exceed available budget
constraint total_spend <= budget;

% Strategic constraint: difference between TV and Radio spend at least min_diff_tv_radio
constraint abs(spend_tv - spend_radio) >= min_diff_tv_radio;

% Strategic constraint: Online cannot exceed Offline by more than max_online_over_offline
constraint spend_online - spend_offline <= max_online_over_offline;

% Strategic constraint: Minimum required spending on TV
constraint spend_tv >= min_tv_spend;


% Objective
solve minimize total_cost;