function rb_C2M_Raw2GSA(INFO)

%add the scripts for this part part
addpath([INFO.dirscripts,filesep, 'GSA', filesep])

disp('------------------------------------Transforming ET Data to GSA format------------------------------------')
for sit=1:length(INFO.site)
    disp(['------------------------------------SITE:' num2str(sit) '---------------------------------------']);
    %infants or adults?
    catssite=INFO.site{1,sit};
    catsgroup=fieldnames(INFO.(catssite).dirdata)';
    
    %Output directory
    OUT=[INFO.dirout, filesep, 'GSA', filesep, catssite, filesep];
    
    for gr=1:length(catsgroup)
        SUBS=[INFO.(catssite).subjname.(catsgroup{gr})];
        for sub=1:length(SUBS)
            subname=SUBS{sub};
            
            disp(['------------------------------------Subject:' num2str(sub) '------------------------------------']);
            clearvars ETfilename ETData_raw ETMarker_raw DS
            
            %% Load the data into Matlab
            ETfilename=[INFO.(catssite).dirdata.(catsgroup{gr}), filesep, INFO.(catssite).subsfolder.(catsgroup{gr}){sub}, filesep, INFO.(catssite).subsdata.(catsgroup{gr}){sub}];
            [ETData_raw, ETMarker_raw] = ricbra_ETAnalysis_importfileGSA(ETfilename);
            
            %% Change the DataStructure so it is readable for GSA
            [DS]=ricbra_ETAnalysis_Transform2GSAFormat(INFO,ETData_raw, ETMarker_raw, sit, gr, sub);
            export(DS,'file',[OUT,subname, 'ETData_GSA.txt'],'delimiter','\t')
        end
    end
end