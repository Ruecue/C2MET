%% Script for the main analysis of the Cup2Mouth ET Experiment
%Experiment is conducted with 10-month-old infants at high and low risk for
%ASD.
%Data for this experiment was collected in Nijmegen and Utrecht as part of
%EUAIMS

%%Housekeeping
clc
clear all
close all
commandwindow

%% Loading information
cd('');
INFO=rb_C2M_Info();
addpath([INFO.dirscripts,'Extra',filesep])

%A small sanity check is performed.
rb_C2M_DatSanCheck (INFO)


%% In a first step the raw ET data is converted into data that can be read into GSA
% This function saves an xxx_ETData_GSA.txt file per subject that can then
% be read into GSA.

rb_C2M_Raw2GSA(INFO)

% After having transformed the data, one has to go and read the data into
% GSA and save the data output as an .xls file before the next part of the
% script can be run.

%% Then we can perform the main analysis

%%%%%%%%%%%%%%%PART 1
% Extracting information from individual data

%This functions reads in the data and extracts a couple of measures. 
% It saves:
% - individual fixation data
% - individual closest fixation
% It outputs:
% - group fixation data (Gr_Fix, needed for Count measure)
% - group closest fixation (Gr_Lat, needed for Latency measure)

[Gr_Fix,Gr_Lat]=rb_C2M_AnSubs(INFO);


%%%%%%%%%%%%%%% PART 2
%Combining Subjects in group data

%This function takes the summary files and processes them further
% -trials get excluded 
% -participants get excluded(gives us Data2Use)
% -the function exports which subjects have to be excluded (when looking at
% 2 Conditions (Usual/Unusual) and when looking at all 4 separately) so
% that we can make sure that the same participants are rejected later on as
% well when we are analyzing latency.
% -all the data for the different conditions is exported (all and included)
% -count is calculated: Count gives us pnum, numanticipations, numtrials and numanticipations\numtrials 

%Count (Dat2Use is all Data and Count is the relative frequency per participant)
[Dat2Use,Count,ExSubs2C,ExSubs4C]=rb_C2M_AnGroup_Count(Gr_Fix,INFO);

%Plot data (creates averages and a lot of different plots)
ricbra_ETAnalysis_FinAnalysis_C2M_Group_ExpPlotData(Dat2Use,Count,INFO);


%This function takes the group latency data and processes them further
% -trials get excluded 
% -participants get excluded(based on input from Count exclusion, gives us LatData)
% -all the data for the different conditions is exported (all and included)
% -latency is given out

%Latency (LatDat2Use is all data and Lat is an average per participant
[LatDat2Use,Lat]=rb_C2M_AnGroup_Lat(Gr_Lat,ExSubs2C,ExSubs4C,INFO);

%Plot data (creates averages and a lot of different plots)
ricbra_ETAnalysis_FinAnalysis_C2M_LG_ExpPlotData(LatDat2Use,INFO);

%% The following output is needed for the actual analysis of the data conducted with SPSS
%save Count Data
save([INFO.dirout, 'CountData'],'Count')
%save Lat Data
save([INFO.dirout,'LatencyData'],'Lat');
