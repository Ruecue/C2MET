function [GroupFixationData,ClosestFixation_Group]=rb_C2M_AnSubs(INFO)

trlall=ones(20,20);
GroupFixationData=[];
ClosestFixation_Group=[];
csub=1;

%add the scripts for the part
addpath([INFO.dirscripts,filesep, 'Subject', filesep])

for sit=1:length(INFO.site)
    %infants or adults?
    disp(['------------------------------------SITE:' num2str(sit) '---------------------------------------']);
    catssite=INFO.site{1,sit};
    catsgroup=fieldnames(INFO.(catssite).dirdata)';
    
    %Input directory (Output from GSA which is stored in the GSA4Matlab folder)
    IN=[INFO.dirout, filesep, 'GSA', filesep, catssite, filesep, 'GSA4Matlab', filesep];
    %Output directory 
    OUT=[INFO.dirout, filesep, 'Subject', filesep, catssite, filesep];
    
    for gr=1:length(catsgroup)
        SUBS=[INFO.(catssite).subjname.(catsgroup{gr})];
        for sub=1:length(SUBS)
            
            subname=SUBS{sub};
            disp(['------------------------------------Subject:' num2str(sub) '------------------------------------']);
            
            [Data]=ricbra_ETAnalysis_ReadInGSAOutput(INFO,IN, SUBS, sub);
            save([OUT,subname, '_RawFixationDataGSA'],'Data');
            
            %% Specify Data Analysis Script for the specific experiment
            
            %Fixation Data
            [FixationData_Indv,GroupFixationData, INFO]= ricbra_ETAnalysis_FinAnalysis_C2M_Individual_v3(Data, GroupFixationData, INFO, sit, gr, sub, SUBS,csub);
            csub=csub+1;
            save([OUT,subname, '_FixationData'],'FixationData_Indv');
            
            %Latencies
            [ClosestFixation_Indv,ClosestFixation_Group,trlall]=ricbra_ETAnalysis_FinAnalysis_C2M_Latencies(FixationData_Indv,ClosestFixation_Group,SUBS,sub,trlall,INFO);
            save([OUT,subname, '_LatencyData'],'ClosestFixation_Indv');
            
            clear FixationData_Indv ClosestFixation_Indv Data
        end
    end
end


