#include <chrono>
#include <memory>
#include <string>
#include <random>
#include <ctime>

#include "rclcpp/rclcpp.hpp"
#include "geometry_msgs/msg/point.hpp"

using namespace std::chrono_literals;

class MinimalPublisher : public rclcpp::Node {
    public:
        MinimalPublisher() : Node("minimal_publisher") {
            publisher_ = this->create_publisher<geometry_msgs::msg::Point>("topic", 10);
            rng = std::uniform_real_distribution<float>(0.0f, 5.0f);

            auto timer_callback = [this]() {
                auto msg = MinimalPublisher::NewMessage(rng, gen);
                auto status = "(" + std::to_string(msg.x) + "," + std::to_string(msg.y) + ")";

                RCLCPP_INFO(this->get_logger(), "Publishing: '%s'", status.c_str());
                this->publisher_->publish(msg);
            };

            timer_ = this->create_wall_timer(1000ms, timer_callback);
        }

        static geometry_msgs::msg::Point NewMessage(std::uniform_real_distribution<float>& rng_, std::mt19937& gen_) {
            auto msg = geometry_msgs::msg::Point();
            msg.x = rng_(gen_);
            msg.y = rng_(gen_);
            msg.z = 0.0;
            return msg;
        }

    private:
        rclcpp::TimerBase::SharedPtr timer_;
        rclcpp::Publisher<geometry_msgs::msg::Point>::SharedPtr publisher_;

        std::mt19937 gen;
        std::uniform_real_distribution<float> rng;
}; // MinimalPublisher

int main(int argc, char * argv[]) {
  rclcpp::init(argc, argv);
  rclcpp::spin(std::make_shared<MinimalPublisher>());
  rclcpp::shutdown();
}
