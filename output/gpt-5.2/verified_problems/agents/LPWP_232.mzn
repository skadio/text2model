% Parameters
% Per-table capacities and requirements
int: ParticipantsPerCircular;      % participants accommodated by one circular table
int: ParticipantsPerRectangular;   % participants accommodated by one rectangular table
int: BoardsPerCircular;            % poster boards provided by one circular table
int: BoardsPerRectangular;         % poster boards provided by one rectangular table
int: GuestsPerCircular;            % guests catered by one circular table
int: GuestsPerRectangular;         % guests catered by one rectangular table
int: SpacePerCircular;             % space required by one circular table
int: SpacePerRectangular;          % space required by one rectangular table

% Global limits / requirements
int: TotalSpace;                   % total available space
int: MinParticipants;              % minimum total participants required
int: MinBoards;                    % minimum total poster boards required


% Variables
% Upper bounds derived from available space (guarded with max(1, ...) to avoid division by 0)
var 0..TotalSpace div max(1, SpacePerCircular): CircularTables;        % number of circular tables to set up
var 0..TotalSpace div max(1, SpacePerRectangular): RectangularTables;  % number of rectangular tables to set up


% Constraints
% Space capacity constraint: total space used by all tables cannot exceed available space
constraint
  SpacePerCircular * CircularTables + SpacePerRectangular * RectangularTables
  <= TotalSpace;

% Minimum participants requirement: ensure enough participant capacity is provided
constraint
  ParticipantsPerCircular * CircularTables + ParticipantsPerRectangular * RectangularTables
  >= MinParticipants;

% Minimum poster boards requirement: ensure enough poster boards are provided
constraint
  BoardsPerCircular * CircularTables + BoardsPerRectangular * RectangularTables
  >= MinBoards;


% Objective
% Maximize the number of guests that can be catered
solve maximize
  GuestsPerCircular * CircularTables + GuestsPerRectangular * RectangularTables;