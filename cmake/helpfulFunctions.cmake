#
# Copyright (c) 2026 Nathaniel Smith
#
# SPDX-License-Identifier: BSD-2-Clause

function(registerFilesToFormat)
	cmake_parse_arguments(PARSE_ARGV 0 TARGET "" "" "FILES")

	if (NOT CLANG_FORMAT) #Make sure h file get included into clang-format
		return()
	endif()

    if (NOT TARGET format-check)
        add_custom_target(format-check)
    endif()
    
	if (NOT TARGET_FILES)
		message("Files list is empty")
		return()
	endif()

	foreach(file IN LISTS TARGET_FILES)
        string(MAKE_C_IDENTIFIER "${file}" file_identifier)

        set(Code "Format_${file_identifier}")
        set(Target "Target_${file_identifier}")
        set(Check "CheckFormat_${file_identifier}")

        set(fullTargetPath ${CMAKE_CURRENT_LIST_DIR}/${file})
        file(RELATIVE_PATH filePath ${CMAKE_SOURCE_DIR} ${fullTargetPath})
        message(STATUS "Targeting ${filePath} for formatting")

        add_custom_target(${Code} ALL
            COMMAND ${CLANG_FORMAT} -i -style=file ${fullTargetPath}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        )

        # Non-mutating check target for CI
        add_custom_target(${Check}
            COMMAND ${CLANG_FORMAT} --dry-run -Werror -style=file ${fullTargetPath}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        )

		add_custom_target(${Target} ALL
			SOURCES ${file}
		)

		add_dependencies(${Target} ${Code})

        if(TARGET format-check)
            add_dependencies(format-check ${Check})
        endif()

	endforeach()
endfunction()