function [Data_Include,CountData,ExSubs2C,ExSubs4C]=rb_C2M_AnGroup_Count (Data, INFO)

%add the scripts for the part
addpath([INFO.dirscripts,filesep, 'Group', filesep]);
OUT=[INFO.dirout,filesep, 'Group', filesep];

%%
%ExcludeTrials %At this point, I am excluding trials if there was no
%fixation present during the anticipation phase, I am excluding
%participants, if they dont have any data for one of the conditions or in
%total less than 4 trials for the combined Usual\Unusual or 2 for each of the 4
%conditions
[Data_Include,ExSubs2C,ExSubs4C]=ricbra_ETAnalysis_FinAnalysis_C2M_Group_ExTrls(Data,INFO);

%% save and export
%Transform and save Group Output data to a dataset
ricbra_ETAnalysis_FinAnalysis_C2M_Group_Trn2DS(Data,Data_Include, INFO, OUT);

%% From here onwards you can select the data you would want to use (ie. All, 2Conditions, 4Conditions)

%Specify your Conditions:
Condition{1,1}={'Usual','Unusual'}'; %This needs to refer to the fieldnames in the Data
Condition{1,2}={'VarNames_DataOutUsual','VarNames_DataOutUnusual'}'; %Saved Variable containing the VariableNames. This needs to refer to the File storing the Variable names of the Data
Variables{1,1}={'CorAnt_NumFix','InCorAnt_NumFix'}'; %Specify the variable name we are looking for, should be the same for both conditions

Condition{2,1}={'OrdinaryMouth','ExtraOrdinaryMouth','OrdinaryEar','ExtraOrdinaryEar'}'; %This needs to refer to the fieldnames in the Data
Condition{2,2}={'VarNames_DataOutOrdinaryMouth','VarNames_DataOutExtraOrdinaryMouth','VarNames_DataOutOrdinaryEar','VarNames_DataOutExtraOrdinaryEar'}'; %VariableNames. This needs to refer to the File storing the Variable names of the Data
Variables{2,1}={'MouthAnticipation_Num','EarAnticipation_Num'}'; %Specify the variable name we are looking for

% Condition{1,1}={'All'}'; %This needs to refer to the fieldnames in the Data
% Condition{1,2}={'VarNames_DataOutAll'}'; %VariableNames. This needs to refer to the File storing the Variable names of the Data
% Variables={'NumAntFix_Mouth','NumAntFix_Ear'}'; %Specify the variable name we are looking for

%Creating Count variable for the Data
for round=1:length(Condition)
    for cond=1:length(Condition{round,1})
        Data2Use=[];
        catcond=Condition{round,1}{cond};
        Data2Use=Data_Include.(catcond);
        VariableFile=Condition{round,2}{cond};
        VarNamesAll=load([OUT, VariableFile],'Varnames');
        for var=1:length(Variables{round,1})
            catvar=Variables{round,1}{var};
            column=find((ismember(VarNamesAll.Varnames,catvar))); %the column in which the number of fixations are listed :)
            %Create Count (first colum is subject, second is the the fixation
            %count (per trials yes or no), next colum is the total number of
            %trials and last column is the ratio of those two.
            [CountData.(catcond).(catvar)]=ricbra_ETAnalysis_FinAnalysis_C2M_Group_CreateCount(Data2Use,column);
        end
    end
end

