# **Simulation Files**

This folder is a hub to store all of our simulaation software, including our electrical components (Pulse Forming Network and amplifier) and our mechanical designs (antenna and enclosure). The softwares used for these simulations are MATLAB (Simulink) and SolidWorks.

## **amplifierSim** 
This is a MATLAB file, which simulates the results of a MOSFET controlled amplifier, amplifying a high frequency sinusoid to match a pulsed input (resembling PFN output).

## **PFN**
The PFN simulation consists of 2 files, PFN.slx and PFN.m. This first contains the circuit schematic of the PFN, used to simulate the output waveform. The other, PFN.m, contains the necessary calculations to turn the input parameters (pulse length & output impedance), into component values.

## **horn_antenna**
This file simulates an ideal horn antenna for our applications, showing the radiation patterns in order to help visualize the directionality of the design. The ideal antenna would have very high directionality in order to help focus the energy at a target.
