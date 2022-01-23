# Indoor_real-time_navigation_for_robot_vehicles

## Overview

This is the final year project for the Embedded Systems Minor &amp; the Autonomous Systems Minor.

2021-2022,  
Polytech Nice-Sophia, Sophia-Antipolis, France  
Engineering degree, Major Electronics, Minor Autonomous Systems

The goal of the project is to implement a real-time navigation system for a robot vehicle and to
setup a complete demonstrator based on an existing robot (Turlebot 3 Burger, figure 1) operating
under the ROS framework (Robot Operating System).

## Project files and directories
* Raspberry_Pi_3
  * catkin_ws

* Vidéos
  *  Démonstration_navigation_robot
  *  Navigation_Temps-Réel_Enregistrement_Ecran
  *  Simulations_Navigation_Gazebo&RViz
  *  Téléopérations_[Navigation_non_autonome]

* Projet_GSE5_2021_2022.pdf : initial project specification 

* [ELEC_5-SA]-Hakan_TASPINAR-Saad_BARMAKI-Rapport_de_Projet_GSE-Indoor_real-time_navigation_for_robot_vehicles.pdf : final project report

* README.md : project files and directories description, prerequisite, compile and run instructions, test and demo

## Prerequisite, compile and run
* **Ubuntu 20.04 / gcc 11.2**
* **ROS (Robot Operating System) and dependant ROS Packages**
  * *Here, the one used on the laptop is ROS Noetic.*
  * *Here, the one used on the Raspberry Pi 3 is ROS Kinetic.*
* **Hector SLAM has to be configured on the laptop (https://github.com/tu-darmstadt-ros-pkg/hector_slam).**
* **https://emanual.robotis.com/docs/en/platform/turtlebot3/overview/**

## Create a map using the ROS Hector-SLAM package

### Download the Hector-SLAM package

First, move to your catkin workspace’s source folder:  
`cd ~/catkin_ws/src`

Then, clone the Hector-SLAM package into your workspace:  
`git clone https://github.com/tu-darmstadt-ros-pkg/hector_slam.git`

### Set the Coordinate Frame Parameters

We need to set the frame names and options correctly.

To do this (instead of nano, you can use any text edit you want):  
1. `nano ~/catkin_ws/src/hector_slam/hector_mapping/launch/mapping_default.launch`
2. Search for these lines (lines 5 and 6 in my code):  
`<arg name="base_frame" default="base_footprint"/>  
<arg name="odom_frame" default="nav"/>`  
Change those lines to this:  
`<arg name="base_frame" default="base_link"/>  
<arg name="odom_frame" default="base_link"/>`  
3. Now go to the end of this file, and find these lines (line 54 in my code) and look for:  
`<!--<node pkg="tf" type="static_transform_publisher" name="map_nav_broadcaster" args="0 0 0 0 0 0 map nav 100"/>-->`  
Change those lines to this (be sure to remove the comment tags (<!– and –>):  
`<node pkg="tf" type="static_transform_publisher" name="base_to_laser_broadcaster" args="0 0 0 0 0 0 base_link laser 100"/>`  
4. Save the file, and return to the terminal window.
5. Open the tutorial.launch file:  
`nano ~/catkin_ws/src/hector_slam/hector_slam_launch/launch/tutorial.launch`  
Find this line (line 7 in my code):  
`<param name="/use_sim_time" value="true"/>`  
Change that line to:  
`<param name="/use_sim_time" value="false"/>`  
6. Save the file, and close it.
7. Open a new terminal window, and type this command to build the packages:  
`cd ~/catkin_ws/ && catkin_make`

### Connect your RPLidar

1. Plug the RPLidar (the one used here is a RPLidar A2).
2. Open a terminal window, and check the permissions:  
`ls -l /dev | grep ttyUSB`  
2. If needed, change the permissions on the peripheral of the RPLidar (mine was `/dev/ttyUSB0`):  
`sudo chmod 666 /dev/ttyUSB0`

### Launch mapping

1. Open a new terminal window and move to your catkin workspace’s source folder:  
`cd ~/catkin_ws/src`  
2. Launch the RPLidar:  
`roslaunch rplidar_ros rplidar.launch`  
Now that the LIDAR is running, let’s start mapping (next step).
3. Open a new terminal, and type the following command (**RViz is mandatory**):  
`roslaunch hector_slam_launch tutorial.launch`  
![image](https://user-images.githubusercontent.com/91252172/150689869-803f5468-bd66-4732-bd72-47851efb6d98.png)
4. Move cautiously with the RPLidar to map.

### Save the map

1. If not already install, install **map_server** package (replace **xxx** by your ROS version, ndlr noetic for me):  
`sudo apt-get install ros-xxx-map-server`  
2. This is not mandatory, but better to do it. Create a maps folder:  
`mkdir ~/catkin_ws/maps`  
3. Move to the maps folder:  
`cd ~/catkin_ws/maps`  
4. Save the map as my_map.yaml and my_map.pgm (the map will be saved to the ~/catkin_ws/maps directory if you've done step 2 and 3):  
`rosrun map_server map_saver -f my_map`  

## Autonomous navigation

### Networking

1. You need to connect the Raspberry Pi 3 and the laptop **on the same network**:
2. Get the IP adress of both the laptop and the Raspberry Pi 3:  
`ifconfig`  
3. Configure correctly your bashrc file (instead of nano, you can use any text edit you want):  
`nano ~/.bashrc`  

#### Your laptop

4. Change (or write it at the end of the file, if it is the first time you are using ROS) those lines:
`export ROS_MASTER_URI=http=//xxx.xx.xx.x:11311`  
`export ROS_HOSTNAME=xxx.xx.xx.x`  
*Instead of xxx.xx.xx.x, put your IP address 2 times*

#### Raspberry Pi 3

4. Add those lines at the end of the ~/.bashrc file:  
`export ROS_MASTER_URI=http=//xxx.xx.xx.x:11311`  
***PAY ATTENTION PLEASE!** Instead of xxx.xx.xx.x, put **the IP address of the laptop***  
`export ROS_HOSTNAME=xxx.xx.xx.x`  
*Instead of xxx.xx.xx.x, put your IP address*

#### On both devices

5. Source your ~/.bashrc file for both laptop and Raspberry Pi 3:  
`. ~/.bashrc`  
6. Once all this done, you can start the ros master, which is the first command to run before running any ROS nodes:  
First on the laptop:  
`roscore`  
Then, on the Raspberry Pi 3:  
`roscore`  
7. On the Raspberry Pi 3, in a new terminal, bring up the Turtlebot3 Burger to run commands such as autonomous navigation or teleoperations:  
`roslaunch turtlebot3_bringup turtlebot3_robot.launch`  
8. On your laptop, in a new terminal:  
Export the robot model:  
`export TURTLEBOT3_MODEL=burger`  
Launch the autonomous navigation application (**RViz is mandatory**):  
*Replace **xxx** by your ROS version, ndlr my_map*  
`roslaunch turtlebot3_navigation turtlebot3_navigation.launch map_file:=$HOME/catkin_ws/xxx.yaml`  
9. On RViz, if needed, replace your robot initial position thanks to the **2D Pose Estimate**, clicking on the map and orienting the robot with the green arrow.
10. On RViz, set a navigation goal thanks to the **2D Nav Goal**, clicking on the map and orienting the robot with the rose arrow.
![image](https://user-images.githubusercontent.com/91252172/150691224-e2e39d3c-e314-498f-9fcc-f2d48368048b.png)

Enjoy your time with your autonomous robot navigation !

