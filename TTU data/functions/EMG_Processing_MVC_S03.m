% Process EMG (test)

clear all
clc
close all

currentFolder = pwd;
addpath([currentFolder,'/functions'])

cd ../
currentFolder2 = pwd;

% go to subject folder
s='03';
cd([currentFolder2 '/Subject_' s '/Subject_' s '_csv'])

%Loading MVC trials
m1=xlsread('m1_3.csv'); %Biceps_1
m2=xlsread('m2_4.csv'); %Biceps_2
m3=m1; %Triceps_1
m4=m2; %Triceps_2
m5=xlsread('m5.csv'); %Anterior Deltoid_1
m6=xlsread('m6.csv'); %Anterior Deltoid_2
m7=xlsread('m7.csv'); %Posterior Deltoid_1
m8=xlsread('m8.csv'); %Posterior Deltoid_2
m9=xlsread('m9.csv'); %Middle Deltoid_1
m10=xlsread('m10.csv'); %Middle Deltoid_2

 
%% obtain time and raw EMG for six muscles
%window=0.01; % window=0.01s
window=0.05;
winName=num2str(window);
winName2=split(winName,'.'); % obtain label for window size (e.g., if window=0.05, the plot name will include "winName2{2,1}"  (i.e., "05")
 

for mm=1:10
    rawData=eval(['m' num2str(mm)]);  
    processedEMG=EMG_processMVCTrial(rawData,['m' num2str(mm)],window);
    
    save(['m' num2str(mm) '_processed6EMG_w' winName2{2,1} '.mat'],'processedEMG');
    clear rawData processedEMG
end
    
