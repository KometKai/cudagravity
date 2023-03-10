cmake_minimum_required(VERSION 3.10)
project(verlet CUDA CXX)

set(CMAKE_CUDA_STANDARD 17)

set(CMAKE_CUDA_ARCHITECTURES 75)

find_package(SDL2 REQUIRED)

add_subdirectory(glm)

set(CMAKE_CUDA_FLAGS ${CMAKE_CUDA_FLAGS} "")

# Simulator

add_executable(cudagravity_sim sim/main.cu common/particle.hpp common/definitions.hpp sim/cudaMemory.cuh sim/exportHelper.cu sim/exportHelper.cuh)

target_include_directories(cudagravity_sim PUBLIC common)

target_link_libraries(cudagravity_sim PUBLIC glm::glm)

set_target_properties(cudagravity_sim PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)

# Viewer

find_package(PkgConfig)
pkg_check_modules(SDL2GFX REQUIRED SDL2_gfx)

add_executable(cudagravity_viewer viewer/main.cpp common/particle.hpp common/definitions.hpp)
target_include_directories(cudagravity_viewer PUBLIC common ${SDL2GFX_INCLUDE_DIRS}})
target_link_libraries(cudagravity_viewer PUBLIC glm::glm SDL2::SDL2 ${SDL2GFX_LIBRARIES})