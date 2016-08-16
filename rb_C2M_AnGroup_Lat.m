function [LatData_Include,LatDataOut]=rb_C2M_AnGroup_Lat(DataIn,Ex2,Ex4,INFO)

%add the scripts for the part
addpath([INFO.dirscripts,filesep, 'Group', filesep]);
OUT=[INFO.dirout,filesep, 'Group', filesep];


Data=DataIn;
[LatData_Include]=ricbra_ETAnalysis_FinAnalysis_C2M_LG_ExTrls(Data,Ex2,Ex4);

%% save and export
%Transform into dataset and export
ricbra_ETAnalysis_FinAnalysis_C2M_LG_Trn2DS(LatData_Include,OUT);

%Create an average per participant

Cond=fields(LatData_Include);

for i=1:size(Cond,1)
    UseC=LatData_Include.(Cond{i});
    type=fields(UseC);
    for j=1:size(type)
        UseCT=UseC.(type{j});
        [TempOut]=ricbra_ETAnalysis_FinAnalysis_C2M_Group_CreateLatAvg(UseCT);
        LatDataOut.(Cond{i}).(type{j})=TempOut;
        clear TempOut UseCT
    end
end