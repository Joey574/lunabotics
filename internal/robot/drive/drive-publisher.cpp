#include <chrono>
#include <functional>
#include <memory>
#include <string>

#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"

using namespace std::chrono_literals;

/* This example creates a subclass of Node and uses std::bind() to register a
* member function as a callback from the timer. */

// Add these dependencies to package.xml & CMakeLists.txt !!!!
class DriveStatePublisher : public rclcpp::Node {
    public:
        DriveStatePublisher()
        : Node("drive_state_publisher"), count_(0)
        { // 'this' refers to DriveStatePublisher
            publisher = this->create_publisher<std_msgs::msg:String>("topic", 10/* Required queue size to limit messages */);
            timer_ = this->create_wall_timer( // Executes timer_callback twice a second
            500ms, std::bind(&DriveStatePublisher::timer_callback, this));
        }

    // Contains the actual message data and publishes them
    private:
        void timer_callback()
        {
            auto message = std_msgs::msg::String();
            message.data = "Hello, world! " + std::to_string(count_++);
            RCLCPP_INFO(this->get_logger(), "Publishing '%s'", message.data.c_str()); // Also prints message to the console
            publisher_->publish(message);
        }
        rclcpp::TimerBase::SharedPtr timer_;
        rclcpp::Publisher<std_msgs::msg::String>:SharedPtr publisher_;
        size_t count_;
};

int main(int argc, char * argv[])
{
    rclcpp::init(argc, argv);
    rclcpp::spin(std:make_shared<DriveStatePublisher>());
    rclcpp::shutdown();
    return 0;
}