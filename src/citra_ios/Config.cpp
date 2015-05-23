// Copyright 2014 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include "citra/default_ini.h"

#include "common/file_util.h"
#include "common/logging/log.h"

#include "core/settings.h"
#include "core/core.h"

#include "config.h"

Config::Config() {
    // TODO: Don't hardcode the path; let the frontend decide where to put the config files.
    //glfw_config_loc = FileUtil::GetUserPath(D_CONFIG_IDX) + "glfw-config.ini";
    //glfw_config = new INIReader(glfw_config_loc);

    Reload();
}

bool Config::LoadINI(INIReader* config, const char* location, const std::string& default_contents, bool retry) {
    if (config->ParseError() < 0) {
        if (retry) {
            LOG_WARNING(Config, "Failed to load %s. Creating file from defaults...", location);
            FileUtil::CreateFullPath(location);
            FileUtil::WriteStringToFile(true, default_contents, location);
            *config = INIReader(location); // Reopen file

            return LoadINI(config, location, default_contents, false);
        }
        LOG_ERROR(Config, "Failed.");
        return false;
    }
    LOG_INFO(Config, "Successfully loaded %s", location);
    return true;
}

void Config::ReadValues() {
    // Controls
    Settings::values.pad_a_key = 1;
    Settings::values.pad_b_key = 1;
    Settings::values.pad_x_key = 1;
    Settings::values.pad_y_key = 1;
    Settings::values.pad_l_key = 1;
    Settings::values.pad_r_key = 1;
    Settings::values.pad_zl_key = 1;
    Settings::values.pad_zr_key = 1;
    Settings::values.pad_start_key  = 1;
    Settings::values.pad_select_key = 1;
    Settings::values.pad_home_key   = 1;
    Settings::values.pad_dup_key    = 1;
    Settings::values.pad_ddown_key  = 1;
    Settings::values.pad_dleft_key  = 1;
    Settings::values.pad_dright_key = 1;
    Settings::values.pad_sup_key    = 1;
    Settings::values.pad_sdown_key  = 1;
    Settings::values.pad_sleft_key  = 1;
    Settings::values.pad_sright_key = 1;
    Settings::values.pad_cup_key    = 1;
    Settings::values.pad_cdown_key  = 1;
    Settings::values.pad_cleft_key  = 1;
    Settings::values.pad_cright_key = 1;

    // Core
    Settings::values.gpu_refresh_rate = 30;
    Settings::values.frame_skip = 0;

    // Renderer
    Settings::values.bg_red   = 1.0;
    Settings::values.bg_green = 1.0;
    Settings::values.bg_blue  = 1.0;

    // Data Storage
    Settings::values.use_virtual_sd = true;

    // System Region
    Settings::values.region_value = 1;

    // Miscellaneous
    Settings::values.log_filter = "*:Debug";
}

void Config::Reload() {
    //LoadINI(glfw_config, glfw_config_loc.c_str(), DefaultINI::glfw_config_file);
    ReadValues();
}

Config::~Config() {
    //delete glfw_config;
}
