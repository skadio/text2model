% Parameters
int: inj_north = 800;     % grams/hour
int: cream_north = 700;   % grams/hour
int: plastic_north = 40;  % units/hour

int: inj_west = 650;      % grams/hour
int: cream_west = 750;    % grams/hour
int: plastic_west = 35;   % units/hour

int: plastic_avail = 60000;     % units
int: inj_req = 800000;          % grams
int: cream_req = 700000;        % grams

% Upper bounds based on plastic availability
int: max_hours_north = plastic_avail div plastic_north;
int: max_hours_west  = plastic_avail div plastic_west;

% Variables
var 0..max_hours_north: h_north;
var 0..max_hours_west:  h_west;

var 0..(inj_north*max_hours_north + inj_west*max_hours_west): inj_total;
var 0..(cream_north*max_hours_north + cream_west*max_hours_west): cream_total;
var 0..plastic_avail: plastic_used;

% Constraints
constraint inj_total = inj_north*h_north + inj_west*h_west;
constraint cream_total = cream_north*h_north + cream_west*h_west;
constraint plastic_used = plastic_north*h_north + plastic_west*h_west;

constraint plastic_used <= plastic_avail;
constraint inj_total >= inj_req;
constraint cream_total >= cream_req;

% Objective
solve minimize h_north + h_west;