#include <memory>

#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"
/* Dependencies for this node. Note that you must create a package.xml and
 CMakeLists.txt file to include these dependencies in your project. */

class MinimalSubscriber : public rclcpp::Node
/* This is the class definition 'MinimalPublisher', which can be 
any name you wish. For its purposes, it must inherit 'rclcpp::Node' */
{
public:
  MinimalSubscriber()
      : Node("minimal_subscriber")
  {
    auto topic_callback =
        [this](std_msgs::msg::String::UniquePtr msg) -> void
    {
      RCLCPP_INFO(this->get_logger(), "I heard: '%s'", msg->data.c_str());
    };
    /* The auto-callback doesn't need a timer unlike the publisher. Once it
    recieves a message it will print it to the console along with the data
    it recieved. */

    subscription_ =
        this->create_subscription<std_msgs::msg::String>("topic", 10, topic_callback);
    /* In the constructor, we create a subscription to the 'topic' with a 
    queue size of 10 and a callback function, similar to the publisher.
    This makes sense since the topic name and message types of both the
    publisher and subscriber must match. */
  }

private:
  rclcpp::Subscription<std_msgs::msg::String>::SharedPtr subscription_;
  // The Subscription is declared.
};

int main(int argc, char *argv[])
{
  rclcpp::init(argc, argv);
  rclcpp::spin(std::make_shared<MinimalSubscriber>());
  rclcpp::shutdown();
  return 0;
  /* In main, the code is finally executed. ROS2 is initialized, then 
  rclcpp:spin() is called to execute the node, and finally rclcpp::shutdown() 
  is called to clean up. */
}
