cmake_minimum_required(VERSION 3.20)
project(turtlesim-demo)

# Default to C++20
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 20)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)
find_package(geometry_msgs REQUIRED)

add_executable(circle src/circle.cpp)
target_link_libraries(circle PUBLIC rclcpp::rclcpp std_msgs::std_msgs
geometry_msgs::geometry_msgs__rosidl_typesupport_cpp
)

install(TARGETS
  circle
  DESTINATION lib/${PROJECT_NAME})

ament_package()