cmake_minimum_required(VERSION 3.10)

include(${CMAKE_CURRENT_LIST_DIR}/cmake/Hunter/HunterGate.cmake)
HunterGate(
    URL "https://github.com/ruslo/hunter/archive/v0.23.158.tar.gz"
    SHA1 "4f3d8287a546091d1968ee80e02f121b312fceea"
    LOCAL # The project has a config.cmake file under cmake/hunter that should be used
)

project(odva_ethernetip VERSION 0.4.1)

hunter_add_package(console_bridge)
find_package(console_bridge CONFIG REQUIRED)

hunter_add_package(Boost COMPONENTS system)
find_package(Boost CONFIG REQUIRED system)

include_directories(
  include
)

## Declare a cpp library for just Ethernet/IP generic stuff
add_library(${PROJECT_NAME}
  src/connection.cpp
  src/copy_serializable.cpp
  src/cpf_item.cpp
  src/cpf_packet.cpp
  src/encap_header.cpp
  src/encap_packet.cpp
  src/identity_item_data.cpp
  src/io_scanner.cpp
  src/message_router_response.cpp
  src/path.cpp
  src/rr_data.cpp
  src/session.cpp
)
target_link_libraries(${PROJECT_NAME} PUBLIC
  Boost::system ros::console_bridge
)


if (CATKIN_ENABLE_TESTING)
  catkin_add_gtest(${PROJECT_NAME}-test
    test/serialization/buffer_writer_test.cpp
    test/serialization/buffer_reader_test.cpp
    test/serialization/stream_writer_test.cpp
    test/serialization/stream_reader_test.cpp
    test/serialization/serializable_buffer_test.cpp
    test/serialization/serializable_primitive_test.cpp
    test/test_socket_test.cpp
    test/encap_header_test.cpp
    test/encap_packet_test.cpp
    test/cpf_item_test.cpp
    test/cpf_packet_test.cpp
    test/sequenced_address_item_test.cpp
    test/identity_item_data_test.cpp
    test/path_test.cpp
    test/rr_data_test.cpp
    test/message_router_request_test.cpp
    test/message_router_response_test.cpp
    test/rr_data_request_test.cpp
    test/rr_data_response_test.cpp
    test/forward_open_request_test.cpp
    test/forward_open_success_test.cpp
    test/forward_close_request_test.cpp
    test/forward_close_success_test.cpp
    test/session_test.cpp
    test/test_main.cpp
  )
  target_link_libraries(${PROJECT_NAME}-test ${PROJECT_NAME})
endif()

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
set(CONFIG_INSTALL_DIR ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}/cmake/)

install(DIRECTORY include/
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}Targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

install(EXPORT ${PROJECT_NAME}Targets
  NAMESPACE ros::
  DESTINATION ${CONFIG_INSTALL_DIR}
)

write_basic_package_version_file(
  ${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
  VERSION ${PACKAGE_VERSION}
  COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(
  ${PROJECT_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in
  ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
  INSTALL_DESTINATION ${CONFIG_INSTALL_DIR}
)

install(
  FILES ${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
  ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
  DESTINATION ${CONFIG_INSTALL_DIR}
)
