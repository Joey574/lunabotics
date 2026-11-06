#include <chrono>
#include <memory>
#include <string>

#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"
/* Dependencies for this node. Note that you must create a package.xml and
 CMakeLists.txt file to include these dependencies in your project. */

using namespace std::chrono_literals;

/* This example creates a subclass of Node and uses a fancy C++11 lambda
* function to shorten the callback syntax, at the expense of making the
* code somewhat more difficult to understand at first glance. */

class MinimalPublisher : public rclcpp::Node
/* This is the class definition 'MinimalPublisher', which can be
any name you wish. For its purposes, it must inherit 'rclcpp::Node' */
{
public:
  MinimalPublisher()
  : Node("minimal_publisher"), count_(0)
  {
    publisher_ = this->create_publisher<std_msgs::msg::String>("topic", 10);
    /* create_publisher() will take the String "topic" as the message type,
    and the integer 10 as the queue size required to limit messages. */
    auto timer_callback =
      [this]() -> void {
        auto message = std_msgs::msg::String();
        message.data = "Hello, world! " + std::to_string(this->count_++);
        /* message.data is the actual message data, which is a string in
        this case. The counter is incremented each time the timer_callback is executed. */
        RCLCPP_INFO(this->get_logger(), "Publishing: '%s'", message.data.c_str());
        // RCLCPP_INFO is a macro that will print the message to the console.
        this->publisher_->publish(message);
      };
    timer_ = this->create_wall_timer(500ms, timer_callback);
    /* The timer declares that every 0.5 seconds, the function timer_callback
    will be executed. */
  }

private:
  rclcpp::TimerBase::SharedPtr timer_;
  rclcpp::Publisher<std_msgs::msg::String>::SharedPtr publisher_;
  size_t count_;
  // The Timer, Publisher, and Counter are all declared.
};

int main(int argc, char * argv[])
{
  rclcpp::init(argc, argv);
  rclcpp::spin(std::make_shared<MinimalPublisher>());
  rclcpp::shutdown();
  return 0;
  /* In main, the code is finally executed. ROS2 is initialized, then
  rclcpp:spin() is called to execute the node, and finally rclcpp::shutdown()
  is called to clean up. */
}
