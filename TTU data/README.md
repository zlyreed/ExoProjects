# Testing Data from SC: 

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

#### EMG processing and Analysis
_*1. Approach One (using the MVC values from the MVC trials)*_
- To obtain the MVC values (**MVC1**)
	- Filter, Rectify and Smooth (RMS) on the MVC trials--"m1 to m10" (EMG_Processing_MVC_S0510.m; EMG_Processing_MVC_S03.m)
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
	       -*txx_EMG_w05_cut_normbyTimeMVC.mat*
	       
- Analysis on the normalized EMG data
  - Mean, Peak and Area 
  - [later] may need to look into Amplitude Probability Report (idea from Noraxon software): percentage of time at three levels (above, within, and below 20%~30% of MVC)
  - use "NormalizedEMG_calculations1.m"
  - output:
    - plots of normalized EMG data (**% of task** vs. **% of MVC**)
    - *Results_normalizedEMG_byMVCtrials.mat*
    - *Results_normalizedEMG_byMVCtrials.csv*

   
_*2. Approach Two (using the MVC2 values from the dynamic trials)*_
- MVC2: use maximum of the dynamic trials (the whole trials) (EMG_Calculate_MVC_MaxDynamicTrials.m)
  - Need work on it (there are higher values in dynamc trials than in the MVC trials)
  
- based on the MVC2 values: need to work on "EMG_Processing_DynamicTrials_byMaxDyna.m"

#### EMG Analysis (on processed EMG data): based on book EMG ABC 
##### Output the result csv file and plot normalized EMG data(NormalizedEMG_calculations.m)
- Mean and/or Median
- Peak 
- Area 
- Need to look into: Amplitude Probability Report (idea from Noraxon software): percentage of time at three levels (above, within, and below 20%~30% of MVC)

**Notes from vendor:**
The first subject was not included in EMG analysis since we had problems with the MVC trials and MOCAP-EMG synchronization. We provided the raw data but we did not include it in the statistical analysis. However, subject 1 kinematics data were included in the statistical analysis.

### Force plate data

### Kinematics data
