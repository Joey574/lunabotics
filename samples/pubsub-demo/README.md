# PubSub demo

This is an example for a simple pub-sub enviroment/setup, copied from [this tutorial](https://docs.ros.org/en/lyrical/ROS-Framework/client-libraries/Working-with-Client-Libraries/Writing-A-Simple-Cpp-Publisher-And-Subscriber.html#create-a-package) (slightly modified).
 
## Requirements

Ensure you have the following installed:
- `rclcpp` and `std_msgs` (included with ros2-lyrical-base)
- `colcon` is the recommended build tool. [install instructions](https://docs.ros.org/en/lyrical/ROS-Framework/client-libraries/Working-with-Client-Libraries/Colcon-Tutorial.html)



## Run

After cloning this folder you can run:

```sh
colcon build --packages-select pubsub-demo
```

Then to run the publisher node, do:
```sh
. install/setup.bash   # adds ros2 command to terminal, must be run in new terminals

ros2 run cpp_pubsub talker
```

Open another terminal to run the listener node:
```sh
. install/setup.bash

ros2 run cpp_pubsub listener
```