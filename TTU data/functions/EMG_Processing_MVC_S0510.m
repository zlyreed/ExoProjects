% Process EMG (test)

clear all
clc
close all

currentFolder = pwd;
addpath([currentFolder,'/functions'])

cd ../
currentFolder2 = pwd;

% go to subject folder
s={'05','06','07','08','09','10'};

for rr=1:length(s) %subject
    cd([currentFolder2 '/Subject_'  s{rr} '/Subject_'  s{rr} '_csv']) % go to the raw EMG data folder
    
    %Loading MVC trials
    m1=xlsread('m1.csv'); %Biceps_1
    m2=xlsread('m2.csv'); %Biceps_2
    m3=xlsread('m3.csv'); %Triceps_1
    m4=xlsread('m4.csv'); %Triceps_2
    m5=xlsread('m5.csv'); %Anterior Deltoid_1
    m6=xlsread('m6.csv'); %Anterior Deltoid_2
    m7=xlsread('m7.csv'); %Posterior Deltoid_1
    m8=xlsread('m8.csv'); %Posterior Deltoid_2
    m9=xlsread('m9.csv'); %Middle Deltoid_1
    m10=xlsread('m10.csv'); %Middle Deltoid_2
    
    
    %% obtain time and raw EMG for six muscles
    %window=0.01;
    window=0.05;
    winName=num2str(window);
    winName2=split(winName,'.'); % obtain label for window size (e.g., if window=0.05, the plot name will include "winName2{2,1}"  (i.e., "05")
    
    for mm=1:10
        rawData=eval(['m' num2str(mm)]);
        processedEMG=EMG_processMVCTrial(rawData,['m' num2str(mm)],window);
        
        save(['m' num2str(mm) '_processed6EMG_w' winName2{2,1} '.mat'],'processedEMG');
        clear rawData processedEMG
    end
    
end

