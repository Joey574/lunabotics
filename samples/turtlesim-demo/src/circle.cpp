// This controller node makes the turtle move in a circle.

#include <chrono>
#include <functional>
#include <memory>

#include "geometry_msgs/msg/twist.hpp"
#include "rclcpp/rclcpp.hpp"

using namespace std::chrono_literals;

class TurtleController : public rclcpp::Node {
public:
  TurtleController() : Node("turtle_controller") {
    // this publishes every 100ms to the turtle1/cmd_vel topic
    publisher_ = this->create_publisher<geometry_msgs::msg::Twist>("turtle1/cmd_vel", 10);
    timer_ = this->create_wall_timer(100ms, std::bind(&TurtleController::publish_velocity, this));
  }

private:
  void publish_velocity() {
    auto message = geometry_msgs::msg::Twist();

    message.linear.x = 2.0;   // Forward speed
    message.angular.z = 1.8;  // Turning speed

    publisher_->publish(message);
  }

  rclcpp::Publisher<geometry_msgs::msg::Twist>::SharedPtr publisher_;
  rclcpp::TimerBase::SharedPtr timer_;
};

int main(int argc, char * argv[]) {
  rclcpp::init(argc, argv);
  rclcpp::spin(std::make_shared<TurtleController>());  // spin runs until ctrl+c
  rclcpp::shutdown();

  return 0;
}
