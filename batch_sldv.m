% Copyright Natasha Jeppu, natasha.jeppu@gmail.com
% http://www.mathworks.com/matlabcentral/profile/authors/5987424-natasha-jeppu
%
% BATCH PROGRAM to run SLDV in test or prover mode.
%

bdclose all
clear all
clc
model_name='test_proof'; % Define Model name
filemdl = [model_name '.mdl']; % We are using mdl as a file extension (just a choice)
% Start fresh here
SETUP = 1;  % setup the proof or test from start
PROOF = 0;  % 0 - Test, 1 - Prove Property
 
% Open the model
open_system(filemdl)
if PROOF == 1
    assum = find_system(model_name,'customAVTBlockType','Test Condition');  % Find test condition blocks
    if length(assum) > 0
        for i = 1:length(assum)
            set_param(char(assum(i,:)),'customAVTBlockType','Assumption')  % Replace them with Assumption blocks
        end
    end
elseif PROOF == 0
    assum = find_system(model_name,'customAVTBlockType','Assumption'); % Find Assumption blocks
    if length(assum) > 0
        for i = 1:length(assum)
            set_param(char(assum(i,:)),'customAVTBlockType','Test Condition') % Replace them with Test Condition blocks
        end
    end
end
set_param(model_name, 'SimulationCommand', 'update');  % update the model
model_obj = get_param(bdroot,'Object');
model_obj.refreshModelBlocks   % Refresh the model
save_system(filemdl)
close_system(filemdl)
bdclose all  % start fresh
% Some options for SLDV in case required
% Mode - [ 'DesignErrorDetection' | {'TestGeneration'} | 'PropertyProving']
% MaxProcessTime {300}
% ModelCoverageObjectives - ['None' | 'Decision' | {'ConditionDecision'} | 'MCDC']
 
if PROOF == 1    % If Property proving
    disp('Running Prover ...');
    open_system(filemdl)
    opts = sldvoptions(model_name);   % get the options
    opts.Mode = 'PropertyProving';  % Set mode to property proving
    sldvrun(model_name)   % Analyze the model
elseif PROOF == 0  % if test case generation
    disp('Running Test Case Generation ...');
    SETUP = 0;   % block any parameter changes
    open_system(filemdl);  % open system
    set_param(model_name, 'SimulationCommand', 'update');  % update it
    model_obj = get_param(bdroot,'Object');
    model_obj.refreshModelBlocks   % Refresh model
    opts = sldvoptions(model_name);   % get the options
    opts.Mode = 'TestGeneration';  % Set mode to property proving
    save_system(filemdl)
    sldvrun(model_name);   % Generate test cases
end
 


