#!/usr/bin/env bash

# ========================================================================================
# Bash-Resolve User & Group
#
# The function retrieves and validates the user and group information from predefined variables to ensure a valid fallback user.
#
# @author      : Marcel Gräfen
# @version     : 0.0.1
# @date        : 2025-08-07
#
# @requires    : Bash 3.0+
#
# @see         : https://github.com/Marcel-Graefen/Bash-Resolve-User-Group
#
# @copyright   : Copyright (c) 2025 Marcel Gräfen
# @license     : MIT License
# ========================================================================================

#----------------------- EXTERNAL GLOBAL VARIABLES --------------------------------------

# SHOW_WARNING          : treu or false (default: true)

: "${SHOW_WARNING:=true}"

# ---------------------------------------------------------------------------------------

# FUNCTION: resolve_user_and_group

# Resolves and validates global user and group variables: SET_USER, SET_UID, SET_GROUP, SET_SET_GID.
# It ensures that these variables correspond to existing system users and groups.
# If USER or GROUP is missing or invalid, it falls back to a default user derived from SUDO_USER or USER.
#
# Arguments:
#   None (works with global variables SET_USER, SET_UID, SET_GROUP, SET_GID, and SUDO_USER)
#
# Returns:
#   Updates the global variables SET_USER, SET_UID, SET_GROUP, SET_GID with valid values.
#   Prints warnings if current or default users/groups do not exist.
#   Clears variables if neither current nor default_user_user_user_user are valid.

resolve_user_and_group() {

  local default_user="${SUDO_USER:-$USER}"  # <-- durchgehend default_user verwenden
  local default_group default_gid

  # --- Helper functions ---
  get_uid_from_user() {
    id -u "$1" 2>/dev/null
  }

  get_group_from_gid() {
    getent group "$1" | cut -d: -f1
  }

  get_gid_from_group() {
    getent group "$1" | cut -d: -f3
  }

  user_exists() {
    id "$1" &>/dev/null
  }

  group_exists() {
    getent group "$1" &>/dev/null
  }

  #----------------------

  # --- USER & SET_UID ---
  if [ -z "$SET_USER" ] && [ -z "$SET_UID" ]; then

      SET_USER="$default_user"
      SET_UID=$(get_uid_from_user "$SET_USER")

  elif [ -n "$SET_USER" ] && user_exists "$SET_USER"; then

      SET_UID=$(get_uid_from_user "$SET_USER")

  elif [ -n "$SET_UID" ]; then

      local tmp_user
      tmp_user=$(getent passwd "$SET_UID" | cut -d: -f1)

      if [ -n "$tmp_user" ]; then
          SET_USER="$tmp_user"
      fi

  fi

  #----------------------

  # If SET_USER invalid, fallback to default_user
  if ! user_exists "$SET_USER"; then

    SET_USER="$default_user"
    SET_UID=$(get_uid_from_user "$SET_USER")

    if ! user_exists "$SET_USER"; then

      [[ "$SHOW_WARNING" != "false" ]] && echo "⚠️ WARNING: Neither current USER nor default USER ('$default_user') exist. Clearing SET_USER and SET_UID."

      SET_USER=""
      SET_UID=""

    else

      [[ "$SHOW_WARNING" != "false" ]] && echo "⚠️ WARNING: USER did not exist, switched to default USER '$SET_USER'."

    fi

  fi

  #----------------------

  # --- GROUP & SET_GID ---
  if [ -z "$SET_GROUP" ] && [ -z "$SET_GID" ] && [ -n "$SET_USER" ]; then

    SET_GROUP=$(id -gn "$SET_USER" 2>/dev/null)
    SET_GID=$(id -g "$SET_USER" 2>/dev/null)

  elif [ -n "$SET_GROUP" ] && group_exists "$SET_GROUP"; then

    SET_GID=$(get_gid_from_group "$SET_GROUP")

  elif [ -n "$SET_GID" ]; then

    local tmp_group
    tmp_group=$(get_group_from_gid "$SET_GID")

    if [ -n "$tmp_group" ]; then
        SET_GROUP="$tmp_group"
    fi

  fi

  #----------------------

  # If SET_GROUP invalid, fallback to default_user group
  if ! group_exists "$SET_GROUP"; then

    default_group=$(id -gn "$default_user" 2>/dev/null)
    default_gid=$(id -g "$default_user" 2>/dev/null)

    if group_exists "$default_group"; then

      [[ "$SHOW_WARNING" != "false" ]] && echo "⚠️ WARNING: GROUP did not exist, switched to default GROUP '$default_group'."

      SET_GROUP="$default_group"
      SET_GID="$default_gid"

    else

      [[ "$SHOW_WARNING" != "false" ]] && echo "⚠️ WARNING: Neither current GROUP nor default GROUP exist. Clearing GROUP and GID."

      SET_GROUP=""
      SET_GID=""

    fi

  fi

}

# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------

# EXAMPLE

# Case 1: Normal Call Without Presets
# In this case, `SET_USER` and `SET_GROUP` are populated with the current user's information.

# # Before the call
# echo "SET_USER: $SET_USER"  # Output: (empty)
# echo "SET_UID: $SET_UID"    # Output: (empty)

# resolve_user_info

# # After the call (logged in as user 'frank')
# echo "SET_USER: $SET_USER"  # Output: frank
# echo "SET_UID: $SET_UID"    # Output: 1001 (or your UID)
# echo "SET_GROUP: $SET_GROUP" # Output: frank
# echo "SET_GID: $SET_GID"    # Output: 1001 (or your GID)

# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------

# Case 2: Call With a Valid User Variable
# Here, the function is called with a predefined `SET_USER`. The function recognizes the valid user and determines the corresponding group information.

# Presets
# SET_USER="www-data"

# resolve_user_info

# # After the call
# echo "SET_USER: $SET_USER"  # Output: www-data
# echo "SET_UID: $SET_UID"    # Output: 33 (www-data's UID)
# echo "SET_GROUP: $SET_GROUP" # Output: www-data
# echo "SET_GID: $SET_GID"    # Output: 33 (www-data's GID)

# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------

# Case 3: Call With an Invalid User Name
# The function recognizes that the specified user doesn't exist and falls back to the default user (`frank`).

# Presets
# SET_USER="non-existent-user"
# SHOW_WARNING="true"

# # Function call (logged in as user 'frank')
# resolve_user_info

# # After the call
# echo "SET_USER: $SET_USER"  # Output: frank
# echo "SET_UID: $SET_UID"    # Output: 1001
# echo "SET_GROUP: $SET_GROUP" # Output: frank
# echo "SET_GID: $SET_GID"    # Output: 1001

# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------

# Case 4: Call With `sudo`
# When you run the script with `sudo`, the function uses the `SUDO_USER` variable to determine the original, non-privileged user.


# Assume the script is called like this: sudo ./my-script.sh
# The current user is 'frank'. SUDO_USER is therefore 'frank'.

# # Function call
# resolve_user_info

# # After the call
# echo "SET_USER: $SET_USER"  # Output: frank
# echo "SET_UID: $SET_UID"    # Output: 1001
# echo "SET_GROUP: $SET_GROUP" # Output: frank
# echo "SET_GID: $SET_GID"    # Output: 1001
