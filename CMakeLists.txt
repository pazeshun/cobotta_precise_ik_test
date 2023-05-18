cmake_minimum_required(VERSION 3.0.2)
project(cobotta_precise_ik_test)

find_package(catkin REQUIRED COMPONENTS
  euscollada
)
find_package(denso_cobotta_descriptions) # Just in case when description is not released. Avoid compile failing

catkin_package()

if(denso_cobotta_descriptions_FOUND)
  add_custom_command(OUTPUT ${PROJECT_SOURCE_DIR}/robots/cobottax100.urdf
    COMMAND xacro --inorder cobottax100.urdf.xacro > cobottax100.urdf
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/robots
    DEPENDS ${PROJECT_SOURCE_DIR}/robots/cobottax100.urdf.xacro)
  add_custom_command(OUTPUT ${PROJECT_SOURCE_DIR}/robots/cobottax100.l
    COMMAND rosrun euscollada collada2eus cobottax100.urdf cobottax100.yaml cobottax100.l
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/robots
    DEPENDS ${PROJECT_SOURCE_DIR}/robots/cobottax100.urdf ${PROJECT_SOURCE_DIR}/robots/cobottax100.yaml)
  add_custom_target(compile_cobottax100 ALL DEPENDS ${PROJECT_SOURCE_DIR}/robots/cobottax100.l)
else()
  message(WARNING "denso_cobotta_descriptions is not found, so skip generating cobottax100.l")
endif()
