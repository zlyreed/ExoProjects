# Testing Data from the vendor: 

## Experiment
Block-laying task on the wobbling platform -- lifting a 35-lb cinder block (8 x 8 x 16 inches) from the production table (at the left side; at the tronchanterion height) to a simulated wall (at the right side) 
- Two simulated wall heights:
	- at the shoulder height
	- at the elbow height

- Four device conditions:
	- No Exo
	- Lev (Levitate)
	- SX (Suit-X)
	- Ekso (Eksobionic)

- In the Bureau of Labor Statistics (BLS) system, "falls" and "slips, trips, and falls" are considered separate categories based on the cause of the injury (From Chat Generative Pretrained Transformer (ChatGPT), https://chat.openai.com/).

    - "Falls" refers to injuries that occur as a result of a worker falling **from one level to another**, such as from a ladder or a roof.
    - "Slips, trips, and falls" refers to a broader category that encompasses all types of injuries that result from a worker slipping, tripping, or falling, including those that occur as a result of slipping on a wet surface, tripping over an object, or **falling from the same level**, such as on a flat surface.
    - So, the distinction between "falls" and "slips, trips, and falls" is based on the specific cause of the injury, with "falls" being a subcategory of "slips, trips, and falls".
    - According to the Bureau of Labor Statistics (BLS), in 2020, the rate of nonfatal injuries resulting from falls in **the private construction industry** in the United States was 3.1 cases per 100 equivalent full-time workers.
    - According to the Bureau of Labor Statistics (BLS), in 2020, the average rate of nonfatal injuries resulting from falls in all private industry in the United States was 0.6 cases per 100 equivalent full-time workers.


## Data Acquisition
The Bertec force plates, kinematics (MOCAP), and EMG were synchronized in Cortex 9, while K-Invent force plates started recording at the moment the subject stepped onto the K-invent force plate. The Mocap and the K-invent force plate were synchronized manually.
- The motion capture system was sampled at 60 Hz.
- The selected range (cutting frames in the Mocap): from the neutral position to task performance and again back to neutral position

### EMG data
Two types of sensors at different sampling frequencies:
- Delsys Avanti: 1259 Hz (bigger sensor)
- Delsys Quattro: 2222 Hz (smaller sensor)

Six muscles: Biceps, Triceps, Posterior deltoid, Medial deltoid, Anterior deltoid, Upper trapezius
  ![6Muscles1](Pictures/ArmMuscles1.jpg "Arm_Muscles1")
  ![6Muscles2](Pictures/ArmMuscles2.jpg "Arm_Muscles2")
  
**Notes from vendor:**
The first subject was not included in EMG analysis since we had problems with the MVC trials and MOCAP-EMG synchronization. We provided the raw data but we did not include it in the statistical analysis. However, subject 1 kinematics data were included in the statistical analysis.

#### EMG processing and Analysis
_*1. Approach One (using the MVC values from the MVC trials)*_
- To obtain the MVC values (**MVC1**)
	- Filter, Rectify and Smooth (RMS) on the MVC trials--"m1 to m10" ([EMG_Processing_MVC_S03.m](functions/EMG_Processing_MVC_S03.m) and [EMG_Processing_MVC_S0510.m](functions/EMG_Processing_MVC_S0510.m), which call the function [EMG_processMVCTrial.m](functions/EMG_processMVCTrial.m))
	  - output: 
	    - *mXX_processed6EMG_w05.mat* (processed MVC trials using window @ 0.05s)
	    - *mXX_processed6EMG_w01.mat* (processed MVC trials using window @ 0.01s) 
	- maximum of the MVC trials (EMG_Calculate_MVC_S030510.m)
	  - output: 
	    - *MVC_6Muscles.mat* (the MVC values of six muscles at window=0.01s [row 1] and at at window=0.05s [**row 2**; use this one])

- To process the Dynamic Trials ("t17 to t32")
	- Filter, Rectify and Smooth (RMS; window=0.05s) on the dynamic trials
	- cut to the range of the trial only 
	- Normalize by the time and the MVC1 (**% of task** vs. **% of MVC**)
	   - based on the MVC1 values: "EMG_Processing_DynamicTrials.m"
	     - output: 
	       - *txx_processed6EMG_w05.mat*
	       - *txx_processed6EMG_w05_cut.mat*
	       - *txx_EMG_w05_cut_normbyTimeMVC1.mat*
	       
- To analyze the normalized EMG data ("t17 to t32")
  - Mean, Peak and Area (based on book EMG ABC)
  - [later] may need to look into Amplitude Probability Report (idea from Noraxon software): percentage of time at three levels (above, within, and below 20%~30% of MVC)
  - use "NormalizedEMG_calculations1.m"
  - output:
    - plots of normalized EMG data (**% of task** vs. **% of MVC**)
    - *Results_normalizedEMG_byMVCtrials.mat*
    - *Results_normalizedEMG_byMVCtrials.csv*

   
_*2. Approach Two (using the MVC values from the dynamic trials)*_
- To obatin **MVC2** (use the maximum EMG values of the muscles across the whole dynamic trials), and then process/nomalize the EMG data of the dynamic trials
  - Process all the dynamic trials and obtain MVC2 (EMG_Calculate_MVC_MaxDynamicTrials.m)
    - ouput: 
      - plots of the processed EMG with cutting ranges (*tXX processed EMG_w05.jpg*)
      - *txx_processed6EMG_w05.mat*
      - *MVC_6Muscles_MaxDynamicTrial.mat*
  -  Cut to the range of the tasks and normalize by the MVC2 and the time (EMG_Processing_DynamicTrials_byMaxDyna.m) 
     - ouput:
       - *txx_processed6EMG_w05_cut.mat*
       - *txx_EMG_w05_cut_normbyTimeMVC2.mat*
      
- To analyze on the normalized EMG data (NormalizedEMG_calculations2.m): Mean, Peak and Area (t17-t32)
  - output:
    - plots of normalized EMG data(**% of task** vs. **% of MVC**)
    - *Results_normalizedEMG_byMaxofDynamicTrials.mat*
    - *Results_normalizedEMG_byMaxofDynamicTrials.csv*

#### Statisical Analysis on normalized EMG data
- Two-way repeated ANOVA
  - two factors (with 7 or 8 subjects as a random factor): 
     - devices with 4 conditions: NoExo, SuitX,Levitate,and Ekso 
     - lifting levels with 2 conditions: elbow and shoulder
  - use *TwoWayRANOVA_EMG_byMaxofDynamicTrials.m*
    - input: *Results_normalizedEMG_byMaxofDynamicTrials.mat* (example)
    - ouput: *EMG_results_2wayRepeatedANOVA_byMaxofDynamicTrials.xls* (example)
    
- Plot means and error bars
  - use *TwoWayRANOVA_EMG_byMaxofDynamicTrials_Plots.m*
    - input: *Results_normalizedEMG_byMaxofDynamicTrials.mat* (example)
    - ouput: 
      - *results_byMaxofDynamicTrials/EMG_results_MeanSD_byMaxofDynamicTrials.xls* (example)
      - *results_byMaxofDynamicTrials/plots of mean and error bar (e.g., EMG_SixMuscles_area_elbow.jpg)*
      
**Note**: error bar = SD/sqrt(n); which is the standard error of the mean (s.e.m.). More information about [Error bars](https://www.nature.com/articles/nmeth.2659).


### Force plate data

### Kinematics data
